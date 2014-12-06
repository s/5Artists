//
//  SPTPage.h
//  Spotify iOS SDK
//
//  Created by Daniel Kennett on 2014-06-10.
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
#import "SPTRequest.h"
#import "SPTTypes.h"

/** This class represents a page within a paginated list.
 
 For the sake of conserving resources, lists that have the potential to be very large
 (such as search results, a playlist or album's tracks, etc) are not delivered as a whole
 from the Spotify backend - instead, such lists are paginated. This class allows you
 to work with those pages.
 */
@interface SPTListPage : NSObject<SPTTrackProvider>

///----------------------------
/// @name Properties
///----------------------------

/** The range of the receiver within the source list. */
@property (nonatomic, readonly) NSRange range;

/** The length of the source list. */
@property (nonatomic, readonly) NSUInteger totalListLength;

/** Returns `YES` if there is at least one page in the source list after the receiver, otherwise `NO`. */
@property (nonatomic, readonly) BOOL hasNextPage;

/** Returns `YES` if there is at least one page in the source list before the receiver, otherwise `NO`. */
@property (nonatomic, readonly) BOOL hasPreviousPage;

/** Returns `YES` if the page contains every single item in the source list, otherwise `NO`. */
@property (nonatomic, readonly) BOOL isComplete;

/** The items contained in the page the receiver represents. */
@property (nonatomic, readonly, copy) NSArray *items;

///----------------------------
/// @name Navigation and Manipulation
///----------------------------

/** Create a new page by adding a page to the receiver. 
 
 @warning The added page *must* start immediately after the receiver - that is,
 `nextPage.range.location` must equal `self.range.location + self.range.length`.

 @param nextPage The page to add to the receiver. 
 @return A new `SPTListPage` containing the union of the receiver and nextPage.
 */
-(SPTListPage *)pageByAppendingPage:(SPTListPage *)nextPage;

/** Request the next page in the source list.
 
 @param session The authenticated session. Must be valid and authenticated with the
 appropriate scopes to retrieve the requested list.
 @param block The block to be called when the operation is complete. This block will pass an error if the operation 
 failed, otherwise the next `SPTListPage` in the source list.
 */
-(void)requestNextPageWithSession:(SPTSession *)session callback:(SPTRequestCallback)block;

/** Request the previous page in the source list.

 @param session The authenticated session. Must be valid and authenticated with the
 appropriate scopes to retrieve the requested list.
 @param block The block to be called when the operation is complete. This block will pass an error if the operation
 failed, otherwise the previous `SPTListPage` in the source list.
 */
-(void)requestPreviousPageWithSession:(SPTSession *)session callback:(SPTRequestCallback)block;

@end
