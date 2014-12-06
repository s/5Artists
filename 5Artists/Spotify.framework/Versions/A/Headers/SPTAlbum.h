//
//  SPTAlbum.h
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
#import "SPTRequest.h"
#import "SPTTypes.h"
#import "SPTPartialAlbum.h"

@class SPTImage;
@class SPTPartialArtist;
@class SPTListPage;

/** This class represents an album on the Spotify service. */
@interface SPTAlbum : SPTPartialAlbum <SPTJSONObject, SPTTrackProvider>

///----------------------------
/// @name Requesting Albums
///----------------------------

/** Request the album at the given Spotify URI.

 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.

 @param uri The Spotify URI of the album to request.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)albumWithURI:(NSURL *)uri session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Request multiple albums given an array of Spotify URIs.
 
 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.
 
 @param uris An array of Spotify URIs.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass an array of Spotify SDK metadata object on success, otherwise an error.
 */
+(void)albumsWithURIs:(NSArray *)uris session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Checks if the Spotify URI is a valid Spotify Album URI.
 
 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.
 
 @param uri The Spotify URI to check.
 */
+(BOOL)isAlbumURI:(NSURL*)uri;

///----------------------------
/// @name Properties
///----------------------------

/** Any external IDs of the album, such as the UPC code. */
@property (nonatomic, readonly, copy) NSDictionary *externalIds;

/** An array of artists for this album, as `SPTPartialArtist` objects. */
@property (nonatomic, readonly) NSArray *artists;

/** The tracks contained by this album, as a page of `SPTPartialTrack` objects. */
@property (nonatomic, readonly) SPTListPage *firstTrackPage;

/** The release year of the album if known, otherwise `0`. */
@property (nonatomic, readonly) NSInteger releaseYear;

/** Day-accurate release date of the track if known, otherwise `nil`. */
@property (nonatomic, readonly) NSDate *releaseDate;

/** Returns a list of genre strings for the album. */
@property (nonatomic, readonly, copy) NSArray *genres;

/** The popularity of the album as a value between 0.0 (least popular) to 100.0 (most popular). */
@property (nonatomic, readonly) double popularity;

@end
