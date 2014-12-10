/*
 TWLHomeViewController.h
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

#import <UIKit/UIKit.h>

@interface TWLHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *slideView;
@property (strong, nonatomic) IBOutlet UIButton *listenOnSpotifyButton;
@property (strong, nonatomic) IBOutlet UILabel *artistNameAndListenerCount;
@property (strong, nonatomic) IBOutlet UIImageView *artistPhoto;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *photoActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *artistBiography;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *biographyActivityIndicator;
@property (strong, nonatomic) IBOutlet UIScrollView *biographyScrollView;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;


- (IBAction)nextArtist:(id)sender;
- (IBAction)previousArtist:(id)sender;
- (IBAction)listenOnSpotify:(id)sender;
- (IBAction)signOut:(id)sender;

@end
