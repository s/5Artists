//
//  TWLHomeViewController.h
//  5Artists
//
//  Created by Said on 28/11/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWLHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *slideView;
@property (strong, nonatomic) IBOutlet UIButton *listenOnSpotifyButton;
@property (strong, nonatomic) IBOutlet UILabel *artistNameAndListenerCount;
@property (strong, nonatomic) IBOutlet UIImageView *artistPhoto;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *photoActivityIndicator;
- (IBAction)nextArtist:(id)sender;
- (IBAction)previousArtist:(id)sender;
- (IBAction)listenOnSpotify:(id)sender;
- (IBAction)signOut:(id)sender;

@end
