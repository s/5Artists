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

#import "TWLHomeViewController.h"
#import "CoreDataStack.h"
#import "TWLDailyArtists+Create.h"
#import "TWLLoginViewController.h"
#import "AFNetworking.h"
#import "CredentialManager.h"

#import <Spotify/Spotify.h>


@interface TWLHomeViewController ()
@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) NSMutableArray *todaysArtists;
@property (nonatomic) CoreDataStack *coreDataStack;
@property (nonatomic) NSMutableArray *relatedArtists;
@property (nonatomic) NSInteger currentArtist;
@property (nonatomic) NSMutableArray *artistBios;
@end

@implementation TWLHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SpotifySession"];
    self.session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    self.currentArtist = 0;
    self.coreDataStack = [CoreDataStack sharedInstance];
    self.todaysArtists = [[NSMutableArray alloc] initWithArray:[self getTodaysArtists]];
    self.artistBios = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.navigationController.navigationBar.layer.shadowRadius = 2.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;

    
    NSLog(@"Today's Artists: \n %@", _todaysArtists);
    if(![_todaysArtists count])
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
                             NSLog(@"Error deciding root artist from user saved tracks. \n %@", [error description]);
                         }
                     }];
                }
                else
                {
                    //Getting the root artist
                    [SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:artist:53XhwfbYqKCa1cC15pYq2q"] withSession:_session callback:^(NSError *error, SPTArtist *artist) {
                        if (!error)
                        {
                            [self getRelatedArtistsOfRootArtist: artist callback:^{
                                [self decideTodaysArtists];
                            }];
                        }
                        else
                        {
                            NSLog(@"Error getting root artist from our choice. \n%@", [error description]);
                        }
                    }];
                }
            }
            else
            {
                NSLog(@"Error getting saved tracks of user. \n%@", [error description]);
            }
        }];
                     
    }
    else
    {
        BOOL isTodaysDataValid = [self isTodaysDataValid];
        
        if (isTodaysDataValid)
        {
            NSLog(@"Data valid");
            [self showTodaysArtists];
            [self sendArtistsToTheExtension];
        }
        else
        {
            NSLog(@"Data is not valid");
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DailyArtists"];
            
            fetchRequest.fetchLimit = 1;
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO]];
            
            NSError *error = nil;
            
            TWLDailyArtists *fetchedMostPopularArtist = [[_coreDataStack context] executeFetchRequest:fetchRequest error:&error].lastObject;

            [SPTArtist artistWithURI:[NSURL URLWithString:fetchedMostPopularArtist.uri] session:_session callback:^(NSError *error, SPTArtist *artist)
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
                    NSLog(@"Error getting artist object from yesterday's most popular artist. \n%@", [error description]);
                 }
            }];
        }
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helpers
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

- (void)decideTodaysArtists
{
    NSSortDescriptor *sortByPopularity = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
    [_relatedArtists sortUsingDescriptors:[NSArray arrayWithObject:sortByPopularity]];
    NSLog(@"Related Artists Sorted: \n");
    for(SPTArtist *artist in _relatedArtists)
    {
        NSLog(@"%@ - %f",artist.name, artist.popularity);
    }
    _todaysArtists = [NSMutableArray arrayWithArray:[_relatedArtists subarrayWithRange:NSMakeRange(0, 5)]];
    NSLog(@"Todays Artists:\n");
    for(SPTArtist *artist in _todaysArtists)
    {
        NSLog(@"%@ - %f",artist.name, artist.popularity);
    }
    [self saveTodaysArtists];
    NSLog(@"Today's Artists: \n %@", [self getTodaysArtists]);

    [self sendArtistsToTheExtension];
    [self showTodaysArtists];
    [self getArtistBiosWithArtistIndex:0];
}

- (void)saveTodaysArtists
{
    NSMutableDictionary *temp;
    NSMutableArray *tempTodaysArtists = [[NSMutableArray alloc] initWithArray:_todaysArtists];
    _todaysArtists = [[NSMutableArray alloc] init];
    for (SPTArtist *artist in tempTodaysArtists)
    {
        temp = [[NSMutableDictionary alloc] init];
        [temp setValue:artist.name forKey:@"name"];
        [temp setValue:artist.identifier forKey:@"artistIdentifier"];
        [temp setValue:[artist.uri absoluteString] forKey:@"uri"];
        [temp setValue:nil forKey:@"biography"];
        [temp setValue:[artist.largestImage.imageURL absoluteString] forKey:@"largestImageUrl"];
        [temp setValue:[NSNumber numberWithFloat:artist.popularity] forKey:@"popularity"];
        [temp setValue:[NSDate date] forKey:@"date"];
        
        [_todaysArtists addObject:temp];
        [TWLDailyArtists createDailyArtistWithInfo:temp];
    }
}

- (void)deleteTodaysArtists
{
    NSFetchRequest *dailyArtists = [[NSFetchRequest alloc] init];
    [dailyArtists setEntity:[NSEntityDescription entityForName:@"DailyArtists" inManagedObjectContext:[_coreDataStack context]]];
    [dailyArtists setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *allArtistsFromYesterday = [[_coreDataStack context] executeFetchRequest:dailyArtists error:&error];

    //error handling goes here
    for (NSManagedObject *artist in allArtistsFromYesterday)
    {
        [[_coreDataStack context] deleteObject:artist];
    }
    NSError *saveError = nil;
    [[_coreDataStack context] save:&saveError];
    if (saveError)
    {
        NSLog(@"Error saving after deleting yesterday's artists");
    }
    //more error handling here
}

- (BOOL)isTodaysDataValid
{
    NSDateComponents *componentsForNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *componentsOfData = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[[_todaysArtists objectAtIndex:0] valueForKey:@"date"]];

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

- (void)showTodaysArtists
{
    [_activityIndicator stopAnimating];
    [_slideView bringSubviewToFront:self.view];
    [_photoActivityIndicator setHidden:NO];
    _rightButton.enabled = YES;
    _leftButton.enabled = YES;
    _artistPhoto.layer.cornerRadius = _artistPhoto.frame.size.height/2;
    _artistPhoto.layer.masksToBounds = YES;
    _artistPhoto.layer.borderWidth = 1.0;
    _artistPhoto.layer.borderColor = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1].CGColor;
    _artistPhoto.layer.shadowColor = [[UIColor blackColor] CGColor];
    _artistPhoto.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    _artistPhoto.layer.shadowRadius = 2.0f;
    _artistPhoto.layer.shadowOpacity = 1.0f;
    [self updateArtist];
}

- (void)sendArtistsToTheExtension
{

    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.towerlabs.fiveartists.TodayExtensionSharingDefaults"];
    NSData *encodedObject;

    encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_todaysArtists];
    [sharedDefaults setObject:encodedObject forKey:@"todaysArtists"];
    [sharedDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDefaultsDidChangeNotification object:self];
}

- (IBAction)nextArtist:(id)sender {
    if (_currentArtist == 4)
    {
        _currentArtist = 0;
    }
    else
    {
        _currentArtist++;
    }
    NSLog(@"Current Artist:%d", _currentArtist);
    [self updateArtist];
}

- (IBAction)previousArtist:(id)sender
{
    if (_currentArtist == 0)
    {
        _currentArtist = 4;
    }
    else
    {
        _currentArtist--;
    }
    NSLog(@"Current Artist:%d", _currentArtist);
    [self updateArtist];
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
    //download image async and cache it.
}

- (void)getArtistBiosWithArtistIndex: (int)index
{
    if (nil != [[_todaysArtists objectAtIndex:0] valueForKey:@"biography"])
    {
        return;
    }
    NSString *apiCallURL = [[CredentialManager sharedInstance] getValueForKey:@"echoNestAPIURL"];
    NSString *apiKey = [[CredentialManager sharedInstance] getValueForKey:@"echoNestAPIKey"];
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
        [_artistBios addObject:bio];
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
           
            [[matches objectAtIndex:0] setValue:[_artistBios objectAtIndex:i] forKey:@"biography"];
            [_coreDataStack saveContext];
        }
    }
    [self updateArtist];
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
    biographyParaStyle1.alignment = 1;
    
    NSRange range = NSMakeRange(0,[bio length]);
    
    // Create the attributes and add them to the string
    [biography addAttribute:NSParagraphStyleAttributeName value:biographyParaStyle1 range:range];
    [biography addAttribute:NSUnderlineColorAttributeName value:biographyColor1 range:range];
    [biography addAttribute:NSFontAttributeName value:biographyFont1 range:range];
    [biography addAttribute:NSForegroundColorAttributeName value:biographyColor2 range:range];
    
    return biography;
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
    [self deleteTodaysArtists];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SpotifySession"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TWLLoginViewController *loginViewController = (TWLLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.towerlabs.fiveartists.TodayExtensionSharingDefaults"];
    [sharedDefaults removeObjectForKey:@"todaysArtists"];
    
    [viewControllers replaceObjectAtIndex:0 withObject:loginViewController];
    [self.navigationController setViewControllers:viewControllers];
}
@end