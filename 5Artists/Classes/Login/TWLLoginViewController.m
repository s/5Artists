/*
 TWLLoginViewController.m
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

#import "CredentialManager.h"
#import "TWLLoginViewController.h"
#import <Spotify/Spotify.h>

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";


@interface TWLLoginViewController ()
@property (nonatomic) CredentialManager *credentialManager;
@end

@implementation TWLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.scopes = @[SPTAuthUserReadPrivateScope, SPTAuthUserLibraryReadScope];
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionUserDefaultsKey];
    SPTSession *session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    
    [self.loginButton setHidden:NO];
    
    if (![session isValid])
    {
        [self.loginButton setEnabled:YES];
        [self.activityIndicator setHidden:YES];
    }
    else
    {
        [self.loginButton setEnabled:NO];
        [self.activityIndicator setHidden:NO];
    }
    self.credentialManager = [CredentialManager sharedInstance];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)login:(id)sender {
    NSURL *loginURL;
    
    NSString *clientId = [_credentialManager getValueForKey:@"clientId"];
    NSString *callbackURL = [_credentialManager getValueForKey:@"callbackURL"];

    loginURL = [[SPTAuth defaultInstance]  loginURLForClientId:clientId
                                           declaredRedirectURL:[NSURL URLWithString:callbackURL]
                                                        scopes:self.scopes];
    
    [[UIApplication sharedApplication] openURL:loginURL];
    [self.loginButton setEnabled:NO];
    [self.activityIndicator setHidden:NO];
}
@end