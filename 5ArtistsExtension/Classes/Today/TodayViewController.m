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

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic) NSInteger currentArtist;
@property (nonatomic) NSMutableArray *todaysArtists;
@property (nonatomic) NSMutableArray *loadedImages;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentArtist = 0;
    self.loadedImages = [[NSMutableArray alloc] init];

    // Define general attributes for the entire text
    _artistPhoto.layer.cornerRadius = _artistPhoto.frame.size.height/2;
    _artistPhoto.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultsDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    

    [self retrieveTodaysArtists];
    if ([_todaysArtists count])
    {
        [self updateArtist];
    }
    else
    {
        [_normalView.subviews setValue:@YES forKey:@"hidden"];
        [_noResultsView setHidden:NO];
        [_noResultsLabel setHidden:NO];
    }
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![_todaysArtists count])
    {
        [_normalView.subviews setValue:@YES forKey:@"hidden"];
        [_noResultsView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.left = 0.0;
    margins.bottom = 10;
    return margins;
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

- (IBAction)listenOnSpotify:(id)sender
{
    NSString *applicationOpenUri = [NSString stringWithFormat:@"spotify://%@",[[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"uri"] ];
    [self.extensionContext openURL:[NSURL URLWithString:applicationOpenUri] completionHandler:nil];
}

- (void)updateArtist
{

    _artistNameAndListenerCount.text = [[_todaysArtists objectAtIndex:_currentArtist] valueForKey:@"name"];

    if (![_loadedImages containsObject:[NSNumber numberWithInt:_currentArtist]])
    {
        [_activityIndicator setHidden:NO];
        [_activityIndicator startAnimating];
        _artistPhoto.image = nil;
    }
    
    //download image async and cache it.
}

- (void)retrieveTodaysArtists
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.towerlabs.fiveartists.TodayExtensionSharingDefaults"];
    NSData *encodedObject = [defaults objectForKey:@"todaysArtists"];
    self.todaysArtists = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject]];
}

- (void)userDefaultsDidChange:(NSNotification *)notification
{
    [self retrieveTodaysArtists];
    if ([_todaysArtists count])
    {
        [_normalView.subviews setValue:@NO forKey:@"hidden"];
        [_noResultsView setHidden:YES];
    }
}

- (void)imageLoadDidFinish:(NSNotification *)notification
{
    [_activityIndicator stopAnimating];
}
@end