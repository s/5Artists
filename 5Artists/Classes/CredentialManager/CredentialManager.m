//
//  CredentialsManager.m
//  5Artists
//
//  Created by Said on 06/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import "CredentialManager.h"

@implementation CredentialManager

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static CredentialManager *credentialManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        credentialManager= [CredentialManager new];
    });
    return credentialManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *spotifyKeysFilePath = [[NSBundle mainBundle] pathForResource:@"SpotifyKeys" ofType:@"plist"];
        if (self.spotifyKeysDict == nil)
        {
            _spotifyKeysDict = [[NSMutableDictionary alloc] initWithContentsOfFile:spotifyKeysFilePath];
            NSLog(@"%@", _spotifyKeysDict);
        }
    }
    return self;
}

- (NSString *)getValueForKey: (NSString *)key
{
    NSLog(@"%@",[_spotifyKeysDict valueForKey:key]);
    return [_spotifyKeysDict valueForKey:key];
}
@end
