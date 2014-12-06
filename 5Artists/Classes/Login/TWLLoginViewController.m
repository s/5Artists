//
//  ViewController.m
//  5Artists
//
//  Created by Said on 28/11/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

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
    if (![session isValid])
    {
        [self.loginButton setHidden:NO];
        [self.loginButton setEnabled:YES];
        [self.activityIndicator setHidden:YES];
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