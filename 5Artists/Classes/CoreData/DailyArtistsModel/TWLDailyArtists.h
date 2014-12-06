//
//  DailyArtists.h
//  5Artists
//
//  Created by Said on 01/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TWLDailyArtists : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * artistIdentifier;
@property (nonatomic, retain) NSString * largestImageUrl;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSDate * date;

@end
