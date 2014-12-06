//
//  SPTUser.h
//  Spotify iOS SDK
//
//  Created by Daniel Kennett on 2014-06-09.
/*
 Copyright 2013 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "SPTJSONDecoding.h"
#import "SPTRequest.h"

@class SPTImage;

/** Represents a user's product level. */
typedef NS_ENUM(NSUInteger, SPTProduct) {
	/** The user has a Spotify Free account. */
	SPTProductFree,
	/** The user has a Spotify Unlimited account. */
	SPTProductUnlimited,
	/** The user has a Spotify Premium account. */
	SPTProductPremium,
	/** The user's product level is unknown. */
	SPTProductUnknown
};

/** This class represents a user on the Spotify service. */
@interface SPTUser : SPTJSONObjectBase

///----------------------------
/// @name Properties
///----------------------------

/** The full display name of the user.
 
 Will be `nil` unless your session has been granted the
 `SPTAuthUserReadPrivateScope` scope.
 */
@property (nonatomic, readonly, copy) NSString *displayName;

/** The canonical user name of the user. Not necessarily appropriate
 for UI use.
 */
@property (nonatomic, readonly, copy) NSString *canonicalUserName;

/** An ISO 3166 country code of the user's account. */
@property (nonatomic, readonly, copy) NSString *territory;

/** The user's email address.
 
 Will be `nil` unless your session has been granted the
 `SPTAuthUserReadEmailScope` scope.
 */
@property (nonatomic, readonly, copy) NSString *emailAddress;

/** The Spotify URI of the user. */
@property (nonatomic, readonly, copy) NSURL *uri;

/** The HTTP open.spotify.com URL of the user. */
@property (nonatomic, readonly, copy) NSURL *sharingURL;

/** Returns a list of user images in various sizes, as `SPTImage` objects.
 
 Will be `nil` unless your session has been granted the
 `SPTAuthUserReadPrivateScope` scope.
 */
@property (nonatomic, readonly, copy) NSArray *images;

/** Convenience method that returns the smallest available user image.
 
 Will be `nil` unless your session has been granted the
 `SPTAuthUserReadPrivateScope` scope.
 */
@property (nonatomic, readonly) SPTImage *smallestImage;

/** Convenience method that returns the largest available user image.
 
 Will be `nil` unless your session has been granted the
 `SPTAuthUserReadPrivateScope` scope.
 */
@property (nonatomic, readonly) SPTImage *largestImage;

/** The product of the user. For example, only Premium users can stream audio.
 
 Will be `SPTProductUnknown` unless your session has been granted the
 `SPTAuthUserReadPrivateScope` scope.
 */
@property (nonatomic, readonly) SPTProduct product;

/** The number of followers this user has. */
@property (nonatomic, readonly) long followerCount;

@end
