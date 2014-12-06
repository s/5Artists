//
//  SPTAlbumCover.h
//  Spotify iOS SDK
//
//  Created by Daniel Kennett on 2014-04-04.
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
#import <CoreGraphics/CoreGraphics.h>

/** This class represents an image from the Spotify service. It could be an
 album's cover art or a user image, for example. */
@interface SPTImage : NSObject

///----------------------------
/// @name Properties
///----------------------------

/** The image's size as reported from the backed.
 
@warning This property may be `CGSizeZero` if the size of the image is unknown
 by the backend. This is particularly the case with images not owned by Spotify, for
 example if a user's image is taken from their Facebook account.
 */
@property (nonatomic, readonly) CGSize size;

/** The HTTP URL to the image. */
@property (nonatomic, readonly, copy) NSURL *imageURL;

@end
