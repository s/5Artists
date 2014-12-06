//
//  AppDelegate.m
//  5Artists
//
//  Created by Said on 28/11/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import "CoreDataStack.h"
#import "TWLAppDelegate.h"
#import "CredentialManager.h"
#import "TWLHomeViewController.h"
#import "TWLLoginViewController.h"

#import <Spotify/Spotify.h>

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";


@interface TWLAppDelegate ()
@property (nonatomic) CoreDataStack *coreDataStack;
@property (nonatomic) CredentialManager *credentialManager;
@end

@implementation TWLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionUserDefaultsKey];
    SPTSession *session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    
    self.coreDataStack = [CoreDataStack sharedInstance];
    self.credentialManager = [CredentialManager sharedInstance];
    
    if (session)
    {
        if ([session isValid])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TWLHomeViewController *homeViewController = (TWLHomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            self.window.rootViewController = homeViewController;
        }
        else
        {
            [self renewToken];
        }
    }
    else
    {
        
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)renewToken
{
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionUserDefaultsKey];
    SPTSession *session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    NSString *tokenRefreshServiceURL = [_credentialManager getValueForKey:@"tokenRefresh"];
    [auth renewSession:session withServiceEndpointAtURL:[NSURL URLWithString:tokenRefreshServiceURL] callback:^(NSError *error, SPTSession *session) {
    
        if (error)
        {
            NSLog(@"*** Error renewing session: %@", error);
            return;
        }
        else
        {
            NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
            [[NSUserDefaults standardUserDefaults] setObject:sessionData forKey:kSessionUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self presentHomeViewController];
        }
    }];
}

- (void)presentHomeViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TWLHomeViewController *homeViewController = (TWLHomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.window.rootViewController presentViewController:homeViewController animated:NO completion:nil];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        
        if (error != nil)
        {
            NSLog(@"Auth fail.");
            return;
        }
        NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
        [[NSUserDefaults standardUserDefaults] setObject:sessionData
                                                  forKey:kSessionUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TWLHomeViewController *homeViewController = (TWLHomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        self.window.rootViewController = homeViewController;
    };
    
    NSString *callbackURL = [_credentialManager getValueForKey:@"callbackURL"];
    NSString *tokenSwapServiceURL = [_credentialManager getValueForKey:@"tokenSwap"];
    
    if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:callbackURL]]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
                                            tokenSwapServiceEndpointAtURL:[NSURL URLWithString:tokenSwapServiceURL]
                                                                 callback:authCallback];
        return YES;
    }
    
    return NO;
}
@end