/*
 TWLDailyArtists.h
 5Artists
 
 Created by Said on 01/12/2014.
 Copyright (c) 2014 Tower Labs. All rights reserved.
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the
 Free Software Foundation, Inc., 51 Franklin Street,
 Fifth Floor, Boston, MA  02110-1301, USA.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TWLDailyArtists : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * artistIdentifier;
@property (nonatomic, retain) NSString * largestImageUrl;
@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSDate * date;

@end
