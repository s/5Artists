//
//  CredentialsManager.h
//  5Artists
//
//  Created by Said on 06/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialManager : NSObject

@property (nonatomic, readonly, strong) NSMutableDictionary *spotifyKeysDict;

+ (instancetype)sharedInstance;
- (NSString *)getValueForKey: (NSString *)key;

@end