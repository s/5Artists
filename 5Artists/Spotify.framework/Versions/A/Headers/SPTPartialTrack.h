//
//  SPTTrack.h
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
#import "SPTPartialObject.h"
#import "SPTTypes.h"

/** Represents a "partial" track on the Spotify service. You can promote this
 to a full track object using `SPTRequest`. */
@interface SPTPartialTrack : SPTJSONObjectBase<SPTPartialObject, SPTTrackProvider>

///----------------------------
/// @name Properties
///----------------------------

/** The id of the track. */
@property (nonatomic, readonly, copy) NSString *identifier;

/** The name of the track. */
@property (nonatomic, readonly, copy) NSString *name;

/** A playable Spotify URI for this track. */
@property (nonatomic, readonly, copy) NSURL *playableUri;

/** The HTTP open.spotify.com URL of the track. */
@property (nonatomic, readonly, copy) NSURL *sharingURL;

/** The duration of the track. */
@property (nonatomic, readonly) NSTimeInterval duration;

/** The artists of the track, as `SPTPartialArtist` objects. */
@property (nonatomic, readonly, copy) NSArray *artists;

/** The disc number of the track. I.e., if it's the first disc on the album this will be `1`. */
@property (nonatomic, readonly) NSInteger discNumber;

/** Returns `YES` if the track is flagged as explicit, otherwise `NO`. */
@property (nonatomic, readonly) BOOL flaggedExplicit;

/** An array of ISO 3166 country codes in which the album is available. */
@property (nonatomic, readonly, copy) NSArray *availableTerritories;

/** The HTTP URL of a 30-second preview MP3 of the track. */
@property (nonatomic, readonly, copy) NSURL *previewURL;

/** The track number of the track. I.e., if it's the first track on the album this will be `1`. */
@property (nonatomic, readonly) NSInteger trackNumber;

@end
