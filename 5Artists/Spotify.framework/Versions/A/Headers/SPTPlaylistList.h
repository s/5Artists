//
//  SPTPlaylistList.h
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
#import "SPTPlaylistSnapshot.h"
#import "SPTListPage.h"

@class SPTSession;

typedef void (^SPTPlaylistCreationCallback)(NSError *error, SPTPlaylistSnapshot *playlist);

/** This class represents a user's list of playlists. */
@interface SPTPlaylistList : SPTListPage

///----------------------------
/// @name Creating Playlists
///----------------------------

/**
 Create a new playlist and add it to the this playlist list.
 
 @param name The name of the newly-created playlist. 
 @param isPublic Whether the newly-created playlist is public.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The callback block to be fired when playlist creation is completed (or fails).
 */
-(void)createPlaylistWithName:(NSString *)name publicFlag:(BOOL)isPublic session:(SPTSession *)session callback:(SPTPlaylistCreationCallback)block;

@end
