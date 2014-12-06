//
//  Spotify.h
//  Spotify iOS SDK
//
//  Created by Daniel Kennett on 2014-02-19.
/*
 Copyright 2014 Spotify AB

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
#import "SPTTypes.h"

// Auth and Session Handling

#import "SPTAuth.h"
#import "SPTSession.h"

#if TARGET_OS_IPHONE
#import "SPTConnectButton.h"
#endif

// Metadata

#import "SPTJSONDecoding.h"
#import "SPTRequest.h"
#import "SPTAlbum.h"
#import "SPTArtist.h"
#import "SPTPartialAlbum.h"
#import "SPTPartialArtist.h"
#import "SPTPartialObject.h"
#import "SPTPartialPlaylist.h"
#import "SPTPartialTrack.h"
#import "SPTPlaylistList.h"
#import "SPTPlaylistSnapshot.h"
#import "SPTTrack.h"
#import "SPTPlaylistTrack.h"
#import "SPTSavedTrack.h"
#import "SPTImage.h"
#import "SPTUser.h"
#import "SPTListPage.h"
#import "SPTFeaturedPlaylistList.h"

// Audio playback

#import "SPTCircularBuffer.h"
#import "SPTCoreAudioController.h"
#import "SPTAudioStreamingController.h"
#import "SPTAudioStreamingController_ErrorCodes.h"

#if !TARGET_OS_IPHONE
#import "SPTCoreAudioDevice.h"
#endif

