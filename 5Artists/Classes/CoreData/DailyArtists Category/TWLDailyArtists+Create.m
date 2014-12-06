//
//  TWLDailyArtists+Create.m
//  5Artists
//
//  Created by Said on 01/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import "TWLDailyArtists+Create.h"
#import "CoreDataStack.h"

@implementation TWLDailyArtists (Create)
+ (void)createDailyArtistWithInfo: (NSDictionary *)info
{
    CoreDataStack *coreDataStack = [CoreDataStack sharedInstance];
    NSManagedObject *object;
    NSError *errorOfSave;
    NSManagedObjectContext *managedObjectContext = [coreDataStack context];
    
    object = [NSEntityDescription insertNewObjectForEntityForName:@"DailyArtists" inManagedObjectContext:managedObjectContext];
    [object setValuesForKeysWithDictionary:info];
    NSLog(@"%@", info);
    [managedObjectContext save:&errorOfSave];
}
@end