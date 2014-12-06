//
//  SPPlaylist.h
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
#import "SPTJSONDecoding.h"
#import "SPTRequest.h"
#import "SPTTypes.h"
#import "SPTPartialPlaylist.h"
#import "SPTImage.h"

@class SPTPlaylistSnapshot;
@class SPTSession;
@class SPTUser;
@class SPTListPage;

/** The field indicating whether the playlist is public. */
FOUNDATION_EXPORT NSString * const SPTPlaylistSnapshotPublicKey;

/** The field indicating the name of the playlist. */
FOUNDATION_EXPORT NSString * const SPTPlaylistSnapshotNameKey;

/** Represents a user's playlist on the Spotify service. */
@interface SPTPlaylistSnapshot : SPTPartialPlaylist <SPTJSONObject>

///----------------------------
/// @name Requesting Playlists
///----------------------------

/** Request the playlist at the given Spotify URI.

 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.

 @param uri The Spotify URI of the playlist to request.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistReadScope` or `SPTAuthPlaylistReadPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)playlistWithURI:(NSURL *)uri session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Request multiple playlists given an array of Spotify URIs.
 
 @note This method takes an array of Spotify URIs in the form `spotify:*`, NOT HTTP URLs.
 
 @param uris An array of Spotify URIs.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistReadScope` or `SPTAuthPlaylistReadPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. The block will pass an array of Spotify SDK metadata objects on success, otherwise an error.
 */
+(void)playlistsWithURIs:(NSArray *)uris session:(SPTSession *)session callback:(SPTRequestCallback)block;

+(BOOL)isPlaylistURI:(NSURL*)uri;

+(BOOL)isStarredURI:(NSURL*)uri;

///----------------------------
/// @name Properties
///----------------------------

/** The tracks of the playlist, as a page of `SPTPartialTrack` objects. */
@property (nonatomic, readonly) SPTListPage *firstTrackPage;

/** The version identifier for the playlist. */
@property (nonatomic, readonly, copy) NSString *snapshotId;

/** The number of followers of this playlist */
@property (nonatomic, readonly) long followerCount;

/** The description of the playlist */
@property (nonatomic, readonly, copy) NSString *descriptionText;


///----------------------------
/// @name Playlist Manipulation
///----------------------------

/** Append tracks to the playlist.
 
 @note This operation is asynchronous on the server, it can take a couple of seconds for your changes to propagate everywhere after this operation has started.

 @param tracks The tracks to add, as `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is started. This block will pass an error if the operation failed.
 */
-(void)addTracksToPlaylist:(NSArray *)tracks withSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

/** Add tracks to the playlist at a certain position.

 @note This operation is asynchronous on the server, it can take a couple of seconds for your changes to propagate everywhere after this operation has started.
 
 @param tracks The tracks to add, as `SPTTrack` or `SPTPartialTrack` objects.
 @param position The position in which the tracks will be added, being 0 the top position.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is started. This block will pass an error if the operation failed.
 */
-(void)addTracksWithPositionToPlaylist:(NSArray *)tracks withPosition:(int)position withSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

/** Replace the tracks in a playlist, overwriting any tracks already in it

 @note This operation is asynchronous on the server, it can take a couple of seconds for your changes to propagate everywhere after this operation has started.
 
 @param tracks The tracks to set, as `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is started. This block will pass an error if the operation failed.
 */
-(void)replaceTracksInPlaylist:(NSArray *)tracks withSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

/** Change playlist details

 @note This operation is asynchronous on the server, it can take a couple of seconds for your changes to propagate everywhere after this operation has started.
 
 @param data The data to be changed. Use the key constants to refer to the field to change
 (e.g. `SPTPlaylistSnapshotNameKey`, `SPTPlaylistSnapshotPublicKey`). When passing boolean values, use @YES or @NO.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is started. This block will pass an error if the operation failed.
 */
-(void)changePlaylistDetails:(NSDictionary *)data
				 withSession:(SPTSession *)session
					callback:(SPTErrorableOperationCallback)block;

/** Remove tracks from playlist. It removes all occurrences of the tracks in the playlist.

 @note This operation is asynchronous on the server, it can take a couple of seconds for your changes to propagate everywhere after this operation has started.
 
 @param tracks The tracks to remove, as `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is started. This block will pass an error if the operation failed.
 */
-(void)removeTracksFromPlaylist:(NSArray *)tracks withSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

/** Remove tracks that are in specific positions from playlist.
 
 @note This operation is asynchronous on the server, it can take a couple of seconds for your changes to propagate everywhere after this operation has started.
 
 @param tracks An array of dictionaries with 2 keys: `track` with the track to remove, as `SPTTrack` or `SPTPartialTrack` objects, and `positions` that is an array of integers with the positions the track will be removed from.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is started. This block will pass an error if the operation failed.
 */
-(void)removeTracksWithPositionsFromPlaylist:(NSArray *)tracks withSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

@end
