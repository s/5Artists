//
//  TodayViewController.h
//  5ArtistsExtension
//
//  Created by Said on 28/11/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *listenOnSpotifyButton;
@property (strong, nonatomic) IBOutlet UILabel *artistNameAndListenerCount;
@property (strong, nonatomic) IBOutlet UIImageView *artistPhoto;
@property (strong, nonatomic) IBOutlet UIView *noResultsView;
@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (strong, nonatomic) IBOutlet UILabel *noResultsLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)nextArtist:(id)sender;
- (IBAction)previousArtist:(id)sender;
- (IBAction)listenOnSpotify:(id)sender;


@end
