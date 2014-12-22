/*
 TWLHomeViewController.m
 5Artists
 
 Created by Said on 28/11/2014.
 Copyright (c) 2014 Tower Labs. All rights reserved.
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the
 Free Software Foundation, Inc., 51 Franklin Street,
 Fifth Floor, Boston, MA  02110-1301, USA.
 */

//Header File
#import "TWLHomeViewController.h"

//Spotify Framework
#import <Spotify/Spotify.h>

//Core Data Classes
#import "CoreDataStack.h"
#import "TWLDailyArtists+Create.h"
#import "TWLShownArtists+Create.h"

//AFNetworking
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

//Login VC
#import "TWLLoginViewController.h"

//Credential Manager
#import "CredentialManager.h"

//UIImageView Resize
#import "UIImageView+Resize.h"



@interface TWLHomeViewController ()

//Credential Manager
@property (nonatomic, strong) CredentialManager *credentialManager;

//Core Data Stack

@property (nonatomic, strong) CoreDataStack *coreDataStack;

//Spotify Session
@property (nonatomic, strong) SPTSession *session;

//Biographies of artists
@property (nonatomic, strong) NSMutableArray *artistBios;

//Todays artists
@property (nonatomic, strong) NSMutableArray *todaysArtists;

//Related Artists of a root artist
@property (nonatomic, strong) NSMutableArray *relatedArtists;

//Current index for image slider
@property (nonatomic) NSInteger currentArtist;

@property (nonatomic, strong) NSMutableArray *notShownArtists;

@property (nonatomic) BOOL isNotificationActive;

@end

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";

@implementation TWLHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SpotifySession"];
    self.session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    self.currentArtist = 0;
    
    self.coreDataStack = [CoreDataStack sharedInstance];
    self.credentialManager = [CredentialManager sharedInstance];
    
    self.todaysArtists = [[NSMutableArray alloc] initWithArray:[self getTodaysArtists]];
    self.artistBios = [[NSMutableArray alloc] init];
    self.notShownArtists = [[NSMutableArray alloc] init];
    
    _artistPhoto.layer.cornerRadius = _artistPhoto.frame.size.height/2;
    _artistPhoto.layer.masksToBounds = YES;
    _artistPhoto.layer.borderWidth = 1.0;
    _artistPhoto.layer.borderColor = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1].CGColor;
    _artistPhoto.layer.shadowColor = [[UIColor blackColor] CGColor];
    _artistPhoto.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _artistPhoto.layer.shadowRadius = 2.0f;
    _artistPhoto.layer.shadowOpacity = 1.0f;
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDataWithNotification)
                                                 name:@"ApplicationDidBecomeActive"
                                               object:nil];

    [self handleData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - CoreData Related Methods
- (NSArray *)getTodaysArtists
{
    NSManagedObjectContext *moc = [_coreDataStack context];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"DailyArtists" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setReturnsObjectsAsFaults:NO];
    NSError *errorOfFetch;
    NSArray *response = [moc executeFetchRequest:request error:&errorOfFetch];
    //NSLog(@"Fetch Error: %@",errorOfFetch);
    
    return response;
}

- (void)saveTodaysArtists
{
    NSMutableDictionary *temp;
    
    for (SPTArtist *artist in _todaysArtists)
    {
        temp = [[NSMutableDictionary alloc] init];
        [temp setValue:artist.name forKey:@"name"];
        [temp setValue:artist.identifier forKey:@"artistIdentifier"];
        [temp setValue:[artist.uri absoluteString] forKey:@"uri"];
        [temp setValue:nil forKey:@"biography"];
        [temp setValue:[artist.largestImage.imageURL absoluteString] forKey:@"largestImageUrl"];
        [temp setValue:[NSNumber numberWithFloat:artist.popularity] forKey:@"popularity"];
        [temp setValue:[NSDate date] forKey:@"date"];
        
        [TWLDailyArtists createDailyArtistWithInfo:temp];
        [TWLShownArtists createShownArtistWithArtistIdentifier:artist.identifier];
    }
    
    
    
    _todaysArtists = [[NSMutableArray alloc] initWithArray:[self getTodaysArtists]];
    
}

- (void)deleteTodaysArtists
{
    NSFetchRequest *dailyArtists = [[NSFetchRequest alloc] init];
    [dailyArtists setEntity:[NSEntityDescription entityForName:@"DailyArtists" inManagedObjectContext:[_coreDataStack context]]];
    [dailyArtists setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *allArtistsFromYesterday = [[_coreDataStack context] executeFetchRequest:dailyArtists error:&error];
    
    for (NSManagedObject *artist in allArtistsFromYesterday)
    {
        [[_coreDataStack context] deleteObject:artist];
    }
    NSError *saveError = nil;
    [[_coreDataStack context] save:&saveError];
    if (saveError)
    {
        NSLog(@"Error saving the context after deleting yesterday's artists");
    }
}

- (void)saveArtistsBiosToDB
{
    for(int i=0;i<5;i++)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DailyArtists"];
        request.sortDescriptors = nil;
        
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [[_todaysArtists objectAtIndex:i] valueForKey:@"name"] ];
        
        NSError *error;
        NSArray *matches = [_coreDataStack.context executeFetchRequest:request error:&error];
        
        if (!error)
        {
            [[matches objectAtIndex:0] setValue:[self trimBioFromText:[_artistBios objectAtIndex:i]] forKey:@"biography"];
            [_coreDataStack saveContext];
        }
    }
    [self updateArtist];
}

#pragma mark - SPT Requests

- (void)getRelatedArtistsOfRootArtist: (SPTArtist *)rootArtist callback:(void (^)(void))callbackBlock
{
    self.relatedArtists = [[NSMutableArray alloc] init];
    [rootArtist requestRelatedArtists:_session callback:^(NSError *error, NSArray *relatedArtists)
     {
         _relatedArtists = [NSMutableArray arrayWithArray:relatedArtists];
         if (callbackBlock)
         {
             callbackBlock();
         }
     }];
}

- (void)populateNotShownArtists: (void (^)(void))callbackBlock
{
    SPTArtist *newRootArtist;
    if ([_notShownArtists count])
    {
        newRootArtist = [_notShownArtists objectAtIndex:0];
    }
    else
    {
        newRootArtist = [_relatedArtists objectAtIndex:0];
    }
    [self getRelatedArtistsOfRootArtist:newRootArtist callback:^{
        [_notShownArtists addObjectsFromArray:_relatedArtists];
        [self findNotShownRelatedArtists];
        if (5>[_notShownArtists count])
        {
            [self populateNotShownArtists:nil];
        }
        else
        {
            if(callbackBlock)
            {
                callbackBlock();
            }
        }
    }];
}

#pragma mark - UI Related Methods
- (void)showTodaysArtists
{
    [_activityIndicator stopAnimating];
    [_slideView bringSubviewToFront:self.view];
    [_photoActivityIndicator setHidden:NO];
    _rightButton.enabled = YES;
    _leftButton.enabled = YES;
    [self updateArtist];
}

- (NSString *)trimBioFromText: (NSString *)text
{
    NSString *trimmedBio = @"";

    NSMutableArray *results = [NSMutableArray array];
    
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationBySentences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [results addObject:substring];
    }];
    int step = 0;
    while ([trimmedBio length] <= 120 && [results count] > step)
    {
        trimmedBio = [trimmedBio stringByAppendingFormat:@"%@",[results objectAtIndex:step]];
        step++;
    }
    
    return trimmedBio;
}

- (NSMutableAttributedString *)getAttributedBiographyForString: (NSString *)bio
{
    // Create the attributed string
    if(!bio)
    {
        return nil;
    }
    
    NSMutableAttributedString *biography = [[NSMutableAttributedString alloc]initWithString:
                                            bio];
    
    // Declare the fonts
    UIFont *biographyFont1 = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
    
    // Declare the colors
    UIColor *biographyColor1 = [UIColor colorWithRed:0.000000 green:0.000000 blue:0.000000 alpha:0.360784];
    UIColor *biographyColor2 = [UIColor colorWithWhite:1.000000 alpha:1.000000];
    
    // Declare the paragraph styles
    NSMutableParagraphStyle *biographyParaStyle1 = [[NSMutableParagraphStyle alloc]init];
    biographyParaStyle1.alignment = 3;
    
    NSRange range = NSMakeRange(0,[bio length]);
    
    // Create the attributes and add them to the string
    [biography addAttribute:NSParagraphStyleAttributeName value:biographyParaStyle1 range:range];
    [biography addAttribute:NSUnderlineColorAttributeName value:biographyColor1 range:range];
    [biography addAttribute:NSFontAttributeName value:biographyFont1 range:range];
    [biography addAttribute:NSForegroundColorAttributeName value:biographyColor2 range:range];
    
    return biography;
}

- (void)updateArtist
{
    _artistNameAndListenerCount.text = [[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"name"];
    
    NSString *artistBio = @"";
    if ([_artistBios count])
    {
        artistBio = [_artistBios objectAtIndex:_currentArtist];
    }
    else
    {
        artistBio = [[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"biography"];
    }
    if (artistBio)
    {
        [_biographyActivityIndicator stopAnimating];
        _artistBiography.attributedText = [self getAttributedBiographyForString:artistBio];
        [self.biographyScrollView setContentOffset:CGPointZero animated:NO];
        [self.biographyScrollView setHidden:NO];
    }
    
    [_photoActivityIndicator setHidden:NO];
    [_photoActivityIndicator startAnimating];
    _artistPhoto.image = nil;
    
    NSURLRequest *imageDownloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"largestImageUrl"]]];
    __weak typeof(self) weakSelf = self;
    [_artistPhoto setImageWithURLRequest:imageDownloadRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [weakSelf.artistPhoto resizeWithImage:image];
         [weakSelf.photoActivityIndicator stopAnimating];
     }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         
     }];
}

- (void)showErrorMessageWithMessage: (NSString *)message
{
    [_photoActivityIndicator stopAnimating];
    [_activityIndicator stopAnimating];
    [_biographyActivityIndicator stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

#pragma mark - Extension Related Methods

- (void)sendArtistsToTheExtension
{

    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.towerlabs.fiveartists.TodayExtensionSharingDefaults"];
    NSData *encodedObject;
    NSMutableArray *todaysArtistWithEncodable = [[NSMutableArray alloc] init];
    
    for(TWLDailyArtists *artist in _todaysArtists)
    {

        NSArray *keys = [[[artist entity] attributesByName] allKeys];
        NSDictionary *artistDict = [artist dictionaryWithValuesForKeys:keys];
        [todaysArtistWithEncodable addObject:artistDict];
    }
    encodedObject = [NSKeyedArchiver archivedDataWithRootObject:todaysArtistWithEncodable];
    
    [sharedDefaults setObject:encodedObject forKey:@"todaysArtists"];
    [sharedDefaults synchronize];
}

#pragma mark - EchoNest API methods

- (void)getArtistBiosWithArtistIndex: (int)index
{
    if (nil != [[_todaysArtists objectAtIndex:0] valueForKey:@"biography"] && _isNotificationActive == NO)
    {
        return;
    }
    else
    {
        if (index == 0)
        {
            _artistBios = [[NSMutableArray alloc] init];
        }
    }
    NSString *apiCallURL = [_credentialManager getValueForKey:@"echoNestAPIURL"];
    NSString *apiKey = [_credentialManager getValueForKey:@"echoNestAPIKey"];
    NSString *artistName = [[_todaysArtists objectAtIndex:index] valueForKey:@"name"];
    
    NSDictionary *parameters = @{
                                 @"api_key":apiKey,
                                 @"name":artistName,
                                 @"format":@"json",
                                 @"results":@"1",
                                 @"start":@"0",
                                 @"license":@"cc-by-sa"
                                 };
    
    int nextIndex = index + 1;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:apiCallURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *bio = @"";
        bio = [[[[responseObject valueForKey:@"response"] valueForKey:@"biographies"] valueForKey:@"text"] objectAtIndex:0];
        [_artistBios addObject:[self trimBioFromText:bio]];
        if (index != 4)
        {
            [self getArtistBiosWithArtistIndex:nextIndex];
        }
        else
        {
            [self saveArtistsBiosToDB];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - IBActions
- (IBAction)listenOnSpotify:(id)sender
{
    NSString *applicationOpenUri = [NSString stringWithFormat:@"spotify://%@",[[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"uri"] ];
    NSURL *applicationOpenURL = [NSURL URLWithString:applicationOpenUri];
    if([[UIApplication sharedApplication] canOpenURL:applicationOpenURL])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:applicationOpenUri]];
    }
    else
    {
        UIAlertView *cantOpenOnSpotifyAlertView =
        [[UIAlertView alloc] initWithTitle:@"Warning"
                                   message:@"Spotify app isn't installed on your iPhone."
                                  delegate:self
                         cancelButtonTitle:@"Okay"
                         otherButtonTitles:nil, nil];
        [cantOpenOnSpotifyAlertView show];
    }
}

- (IBAction)signOut:(id)sender
{
    UIAlertView *signOutAlertView = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                               message:@"Signing out will destroy all the suggestion history. Do you still want to proceed?"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel "
                                                     otherButtonTitles:@"Sign Out", nil];
    signOutAlertView.tag = 22;
    [signOutAlertView show];
}

- (IBAction)nextArtist:(id)sender {
    if (_currentArtist == [_todaysArtists count]-1)
    {
        _currentArtist = 0;
    }
    else
    {
        _currentArtist++;
    }
    [self updateArtist];
}

- (IBAction)previousArtist:(id)sender
{
    if (_currentArtist == 0)
    {
        _currentArtist = [_todaysArtists count]-1;
    }
    else
    {
        _currentArtist--;
    }
    [self updateArtist];
}

#pragma mark - Helpers
- (void)clearUserInterface
{
    [_artistPhoto setImage:nil];
    [[self.view subviews] setValue:@NO forKey:@"hidden"];
    [_artistNameAndListenerCount setText:@"Loading.."];
    [_artistBiography setText:@""];
    [_activityIndicator startAnimating];
    [_photoActivityIndicator startAnimating];
    [_biographyActivityIndicator startAnimating];
}
- (void)renewToken: (void (^)(void))callbackBlock
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    NSString *tokenRefreshServiceURL = [_credentialManager getValueForKey:@"tokenRefresh"];
    [auth renewSession:_session withServiceEndpointAtURL:[NSURL URLWithString:tokenRefreshServiceURL] callback:^(NSError *error, SPTSession *session) {
        
        if (error)
        {
            NSLog(@"*** Error renewing session: %@", error);
            [self showErrorMessageWithMessage:@"An error occured while renewing your session. Please try terminating and reopenning application again."];
            return;
        }
        else
        {
            NSLog(@"Did renew token");
            NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
            [[NSUserDefaults standardUserDefaults] setObject:sessionData forKey:kSessionUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.session = session;
            if(callbackBlock)
            {
                callbackBlock();
            }
        }
    }];
}
- (void)handleDataWithNotification
{
    self.isNotificationActive = YES;
    _relatedArtists = [[NSMutableArray alloc] init];
    [self handleData];
}

- (void)getSavedTracksOfUser
{
    [SPTRequest savedTracksForUserInSession:_session callback:^(NSError *error, SPTListPage *listPage) {
        if (!error)
        {
            if (listPage.items.count)
            {
                
                int randomNumberForTrack = arc4random() % listPage.items.count;
                
                //Choosing a random track from saved tracks list
                SPTSavedTrack *track = [listPage.items objectAtIndex:randomNumberForTrack];
                
                //Getting the partial root artist
                SPTPartialArtist *rootArtist = [[track artists] objectAtIndex:0];
                
                //Getting the real root artist
                [SPTRequest requestItemFromPartialObject:rootArtist withSession:_session callback:^(NSError *error, SPTArtist *artist)
                 {
                     if (!error)
                     {
                         NSLog(@"Root artist decided: %@", artist);
                         [self getRelatedArtistsOfRootArtist: artist callback:^{
                             [self decideTodaysArtists];
                         }];
                     }
                     else
                     {
                         [self showErrorMessageWithMessage:@"An error occured while getting your trakcs. Please log out and try again."];
                         NSLog(@"Error deciding root artist from user saved tracks. \n %@", [error description]);
                     }
                 }];
            }
            else
            {
                [self showErrorMessageWithMessage:@"No saved tracks found on your account. Please save some tracks and try again."];
                NSLog(@"Error getting root artist from pre-defined choice. \n%@", [error description]);
            }
        }
        else
        {
            [self showErrorMessageWithMessage:@"An error occured while getting your artists. Please log out and try again."];
            NSLog(@"Error getting saved tracks of user. \n%@", [error description]);
        }
    }];
}

- (void)handleData
{
    if(![_todaysArtists count])
    {
        NSLog(@"There is no data");
        if (![_session isValid])
        {
            [self renewToken:^{
                [self getSavedTracksOfUser];
            }];
        }
        else
        {
            [self getSavedTracksOfUser];
        }
    }
    else
    {
        BOOL isTodaysDataValid = [self isTodaysDataValid];
        
        if (isTodaysDataValid)
        {
            NSLog(@"Data valid");
            [self showTodaysArtists];
        }
        else
        {
            NSLog(@"Data is not valid");
            if (![_session isValid])
            {
                [self renewToken:^{
                    [self findNewDaysArtists];
                }];
            }
        }
    }
}
- (BOOL)isTodaysDataValid
{
    NSDateComponents *componentsForNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *componentsOfData = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[[_todaysArtists objectAtIndex:0] valueForKey:@"date"]];
    
    NSInteger dayOfNow = [componentsForNow day];
    NSInteger dayOfData = [componentsOfData day];

    if ( dayOfData != dayOfNow)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)decideTodaysArtists
{
    [self findNotShownRelatedArtists];
    NSLog(@"Not shown artists: %@", _notShownArtists);
    
    if (5 > [_notShownArtists count])
    {
        [self populateNotShownArtists:^{
            [self finalizeTodaysArtists];
        }];
    }
    else
    {
        [self finalizeTodaysArtists];
    }
}

- (void)finalizeTodaysArtists
{
    NSSortDescriptor *sortByPopularity = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
    [_notShownArtists sortUsingDescriptors:[NSArray arrayWithObject:sortByPopularity]];
    
    _todaysArtists = [NSMutableArray arrayWithArray:[_notShownArtists subarrayWithRange:NSMakeRange(0, 5)]];
    NSLog(@"New todays artists:%@", _todaysArtists);
    [self saveTodaysArtists];
    [self sendArtistsToTheExtension];
    [self showTodaysArtists];
    [self getArtistBiosWithArtistIndex:0];
}

- (void)findNotShownRelatedArtists
{
    _notShownArtists = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ShownArtists"];
    NSError *error;
    request.sortDescriptors = nil;
  
    for (int i=0; i<[_relatedArtists count]; i++)
    {
        request.predicate = [NSPredicate predicateWithFormat:@"artistIdentifier = %@", [[_relatedArtists objectAtIndex:i] valueForKey:@"identifier"] ];
        NSArray *matches = [[NSArray alloc] initWithArray:[_coreDataStack.context executeFetchRequest:request error:&error]];
        if (!error && ![matches count])
        {
            [_notShownArtists addObject:[_relatedArtists objectAtIndex:i]];
        }
    }
}

- (void)findNewDaysArtists
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DailyArtists"];
    
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:YES]];
    
    NSError *error = nil;
    
    TWLDailyArtists *fetchedMostPopularArtist = [[_coreDataStack context] executeFetchRequest:fetchRequest error:&error].lastObject;

    [SPTArtist artistWithURI:[NSURL URLWithString:fetchedMostPopularArtist.uri] session:nil callback:^(NSError *error, SPTArtist *artist)
     {
         if (!error)
         {
             [self getRelatedArtistsOfRootArtist:artist callback:^{
                 [self deleteTodaysArtists];
                 [self decideTodaysArtists];
             }];
         }
         else
         {
             [self showErrorMessageWithMessage:@"An error occured while getting your artists. Please try terminating and reopenning the application again."];
             NSLog(@"Error getting artist object from yesterday's most popular artist. \n%@", [error description]);
         }
     }];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 22 && buttonIndex == 1)
    {
        [self deleteTodaysArtists];
        
        NSFetchRequest *fetchRequestForShownArtists = [[NSFetchRequest alloc] init];
        [fetchRequestForShownArtists setIncludesPropertyValues:NO];
        
        NSError *fetchError = nil;
        NSError *saveError = nil;
        
        [fetchRequestForShownArtists setEntity:[NSEntityDescription entityForName:@"ShownArtists" inManagedObjectContext:[_coreDataStack context]]];
        NSArray *allResults = [[_coreDataStack context] executeFetchRequest:fetchRequestForShownArtists error:&fetchError];
        
        for (NSManagedObject *artist in allResults)
        {
            [[_coreDataStack context] deleteObject:artist];
        }
        
        [[_coreDataStack context] save:&saveError];
        
        
        if (saveError)
        {
            NSLog(@"Error saving after deleting yesterday's artists: %@",[saveError description]);
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpotifySession"];
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.towerlabs.fiveartists.TodayExtensionSharingDefaults"];
        [sharedDefaults removeObjectForKey:@"todaysArtists"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TWLLoginViewController *loginViewController = (TWLLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        
        [viewControllers replaceObjectAtIndex:0 withObject:loginViewController];
        [self.navigationController setViewControllers:viewControllers];
    }
}
@end