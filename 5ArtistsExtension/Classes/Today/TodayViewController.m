/*
 TodayViewController.m
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

#import "AFNetworking.h"
#import "UIImageView+Resize.h"
#import "TodayViewController.h"
#import "UIImageView+AFNetworking.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic) NSInteger currentArtist;
@property (nonatomic) NSMutableArray *todaysArtists;
@end

@implementation TodayViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Define general attributes for the entire text
    _artistPhoto.layer.cornerRadius = _artistPhoto.frame.size.width/2;
    _artistPhoto.clipsToBounds = YES;
    
    [self handleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    self.currentArtist = 0;
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.left = 0.0;
    margins.bottom = 10;
    return margins;
}

#pragma mark - IBActions
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

- (IBAction)listenOnSpotify:(id)sender
{
    NSString *applicationOpenUri = [NSString stringWithFormat:@"spotify://%@",[[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"uri"] ];
    [self.extensionContext openURL:[NSURL URLWithString:applicationOpenUri] completionHandler:nil];
}

#pragma mark - UI related methods
- (void)updateArtist
{
    
    _artistNameAndListenerCount.text = [[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"name"];
    NSURLRequest *imageDownloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"largestImageUrl"]]];
    _artistPhoto.image = nil;
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    __weak typeof(self) weakSelf = self;
    [_artistPhoto setImageWithURLRequest:imageDownloadRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [weakSelf.artistPhoto resizeWithImage:image];
         [weakSelf.activityIndicator stopAnimating];
     }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         
     }];
    
    
}

#pragma mark - Communication related methods
- (void)retrieveTodaysArtists
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.towerlabs.fiveartists.TodayExtensionSharingDefaults"];
    NSData *encodedObject = [defaults objectForKey:@"todaysArtists"];
    self.todaysArtists = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject]];
}


#pragma mark - Helpers
- (void)handleData
{
    [self retrieveTodaysArtists];
    
    if (![_todaysArtists count])
    {
        [_normalView.subviews setValue:@YES forKey:@"hidden"];
        [_noResultsView setHidden:NO];
        [_noResultsLabel setHidden:NO];
        [_noResultsLabel setText:@"Please login with Spotify to see suggestions."];
        [_activityIndicator stopAnimating];
    }
    else
    {
        NSDateComponents *componentsForNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
        NSDateComponents *componentsOfData = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[[_todaysArtists objectAtIndex:0] valueForKey:@"date"]];
        
        NSInteger dayOfNow = [componentsForNow day];
        NSInteger dayOfData = [componentsOfData day];
        
        if ( dayOfData != dayOfNow)
        {
            [_normalView.subviews setValue:@YES forKey:@"hidden"];
            [_noResultsView setHidden:NO];
            [_noResultsLabel setHidden:NO];
            [_activityIndicator stopAnimating];
            [_noResultsLabel setText:@"Please open the application for today's five."];
        }
        else
        {
            [self updateArtist];
        }
    }
}
@end