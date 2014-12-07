/*
 CredentialsManager.m
 5Artists
 
 Created by Said on 06/12/2014.
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
        if ([[NSFileManager defaultManager] fileExistsAtPath:spotifyKeysFilePath])
        {
            if (self.spotifyKeysDict == nil)
            {
                NSLog(@"girdim");
                _spotifyKeysDict = [[NSMutableDictionary alloc] initWithContentsOfFile:spotifyKeysFilePath];
            }
        }
        else
        {
            [NSException raise:@"Please create SpotifyKeys.plist file and add the required credentials" format:@"No credentials file found."];
        }
    }
    return self;
}

- (NSString *)getValueForKey: (NSString *)key
{
    return [_spotifyKeysDict valueForKey:key];
}
@end
