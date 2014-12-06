//
//  SPTRequest.h
//  Basic Auth
//
//  Created by Daniel Kennett on 14/11/2013.
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
#import "SPTPartialObject.h"

@class SPTSession;

typedef void (^SPTRequestCallback)(NSError *error, id object);

/// Defines types of result objects that can be searched for.
typedef NS_ENUM(NSUInteger, SPTSearchQueryType) {
	/// Specifies that all search results will be of type `SPTTrack`.
	SPTQueryTypeTrack = 0,
	/// Specifies that all search results will be of type `SPTArtist`.
	SPTQueryTypeArtist,
	/// Specifies that all search results will be of type `SPTAlbum`.
	SPTQueryTypeAlbum
};

/** This class provides methods to get Spotify SDK metadata objects. */
@interface SPTRequest : NSObject

///----------------------------
/// @name Generic Requests
///----------------------------

/** Request the item at the given Spotify URI.
 
 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.

 @param uri The Spotify URI of the item to request.
 @param session An authenticated session. Can be `nil` depending on the URI.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)requestItemAtURI:(NSURL *)uri withSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Convert an `SPTPartialObject` into a "full" metadata object.

 @param partialObject The object to promote to a "full" object.
 @param session An authenticated session. Can be `nil` depending on the URI.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)requestItemFromPartialObject:(id <SPTPartialObject>)partialObject withSession:(SPTSession *)session callback:(SPTRequestCallback)block;

///----------------------------
/// @name Playlists
///----------------------------

/** Get the authenticated user's playlist list.

 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistReadScope` or `SPTAuthPlaylistReadPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. The block will pass an `SPTPlaylistList` object on success, otherwise an error.
 */
+(void)playlistsForUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Get the authenticated user's starred playlist.

 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistReadScope` or `SPTAuthPlaylistReadPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. The block will pass an `SPTPlaylistSnapshot` object on success, otherwise an error.
 */
+(void)starredListForUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

///----------------------------
/// @name User Information
///----------------------------

/** Get the authenticated user's information.

 @param session An authenticated session. Must be valid and authenticated with the
 scopes required for the information you require. See the `SPTUser` documentation for details.
 @param block The block to be called when the operation is complete. The block will pass an `SPTUser` object on success, otherwise an error.
 @see SPTUser
 */
+(void)userInformationForUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

///----------------------------
/// @name Search
///----------------------------

/** Performs a search with a given query, offset and market filtering
 
 @param searchQuery The query to pass to the search.
 @param searchQueryType The type of search to do.
 @param offset The index at which to start returning results.
 @param session An authenticated session. Can be `nil`.
 @param market Either a ISO 3166-1 country code to filter the results to, or `from_token` to pick the market from the session (requires the `user-read-private` scope), or `nil` for no market filtering.
 @param block The block to be called when the operation is complete. The block will pass an `SPTListPage` containing results on success, otherwise an error.
 */
+(void)performSearchWithQuery:(NSString *)searchQuery queryType:(SPTSearchQueryType)searchQueryType offset:(NSInteger)offset session:(SPTSession *)session market:(NSString *)market callback:(SPTRequestCallback)block;

/** Performs a search with a given query and market filtering

 @param searchQuery The query to pass to the search.
 @param searchQueryType The type of search to do.
 @param session An authenticated session. Can be `nil`.
 @param market Either a ISO 3166-1 country code to filter the results to, or `from_token` to pick the market from the session (requires the `user-read-private` scope), or `nil` for no market filtering.
 @param block The block to be called when the operation is complete. The block will pass an `SPTListPage` containing results on success, otherwise an error.
 */
+(void)performSearchWithQuery:(NSString *)searchQuery queryType:(SPTSearchQueryType)searchQueryType session:(SPTSession *)session market:(NSString *)market callback:(SPTRequestCallback)block;

/** Performs a search with a given query and offset
 
 @param searchQuery The query to pass to the search.
 @param searchQueryType The type of search to do.
 @param offset The index at which to start returning results.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass an `SPTListPage` containing results on success, otherwise an error.
 */
+(void)performSearchWithQuery:(NSString *)searchQuery queryType:(SPTSearchQueryType)searchQueryType offset:(NSInteger)offset session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Performs a search with a given query.
 
 @param searchQuery The query to pass to the search.
 @param searchQueryType The type of search to do.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass an `SPTListPage` containing results on success, otherwise an error.
 */
+(void)performSearchWithQuery:(NSString *)searchQuery queryType:(SPTSearchQueryType)searchQueryType session:(SPTSession *)session callback:(SPTRequestCallback)block;

///----------------------------
/// @name Your Music Library
///----------------------------

/** Gets the authenticated user's Your Music Library tracks

 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthUserLibraryRead` scope.
 @param block The block will pass an `SPTListPage` containing results on success, otherwise an error.
 */
+(void)savedTracksForUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Adds a set of tracks to the authenticated user's Your Music Library.

 @param tracks An array of `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthUserLibraryModify` scope.
 @param block The block to be called when the operation is complete.
 */
+(void)saveTracks:(NSArray *)tracks forUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Checks whether the authenticated user's Your Music Library contains a set of tracks.

 @param tracks An array of `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthUserLibraryRead` scope.
 @param block The block to be called when the operation is complete. The block will pass an NSArray of Bool values on success, otherwise an error.
 */
+(void)savedTracksContains:(NSArray *)tracks forUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Removes a set of tracks from the authenticated user's Your Music Library.

 @param tracks An array of `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthUserLibraryModify` scope.
 @param block The block to be called when the operation is complete.
*/
+(void)removeTracksFromSaved:(NSArray *)tracks forUserInSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Get a list of featured playlists
 
 See https://developer.spotify.com/web-api/get-list-featured-playlists/ for more information on parameters
 
 @param country A ISO 3166-1 country code to get playlists for, or `nil` to get global recommendations.
 @param limit The number of results to return, max 50.
 @param offset The index at which to start returning results.
 @param locale The locale of the user, for localized recommendations, `nil` will default to American English.
 @param timestamp The time of day to get recommendations for (without timezone), or `nil` for current local time
 @param session An authenticated session. Must be valid and authenticated with the
 @param block The block to be called when the operation is complete, containing a `SPTFeaturedPlaylistList`
 */
+(void)requestFeaturedPlaylistsForCountry:(NSString *)country limit:(NSInteger)limit offset:(NSInteger)offset locale:(NSString *)locale timestamp:(NSDate*)timestamp session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Get a list of new releases.
 
 See https://developer.spotify.com/web-api/get-list-new-releases/ for more information on parameters

 @param country A ISO 3166-1 country code to get releases for, or `nil` for global releases.
 @param limit The number of results to return, max 50.
 @param offset The index at which to start returning results.
 @param session An authenticated session. Must be valid and authenticated with the `SPTAuthUserLibraryModify` scope.
 @param block The block to be called when the operation is complete, containing a `SPTListPage`
 */
+(void)requestNewReleasesForCountry:(NSString *)country limit:(NSInteger)limit offset:(NSInteger)offset session:(SPTSession *)session callback:(SPTRequestCallback)block;

@end
