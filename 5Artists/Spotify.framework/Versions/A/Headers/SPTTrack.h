//
//  SPTTrack.h
//  Basic Auth
//
//  Created by Daniel Kennett on 19/11/2013.
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
#import "SPTPartialAlbum.h"
#import "SPTPartialTrack.h"
#import "SPTRequest.h"

/** This class represents a track on the Spotify service. */
@interface SPTTrack : SPTPartialTrack <SPTJSONObject>

///----------------------------
/// @name Requesting Tracks
///----------------------------

/** Request the track at the given Spotify URI.

 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.

 @param uri The Spotify URI of the track to request.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)trackWithURI:(NSURL *)uri session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Request multiple tracks with given an array of Spotify URIs.
 
 @note This method takes an array of Spotify URIs in the form `spotify:*`, NOT HTTP URLs.
 
 @param uris An array of Spotify Track URIs.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass an array of Spotify SDK metadata objects on success, otherwise an error.
 */
+(void)tracksWithURIs:(NSArray *)uris session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Checks if the Spotify URI is a valid Spotify Track URI.
 
 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.
 
 @param uri The Spotify URI to check.
 */
+(BOOL)isTrackURI:(NSURL*)uri;

///----------------------------
/// @name Properties
///----------------------------

/** The popularity of the track as a value between 0.0 (least popular) to 100.0 (most popular). */
@property (nonatomic, readonly) double popularity;

/** The album this track is. */
@property (nonatomic, readonly, strong) SPTPartialAlbum *album;

/** Any external IDs of the track, such as the ISRC code. */
@property (nonatomic, readonly, copy) NSDictionary *externalIds;

@end
