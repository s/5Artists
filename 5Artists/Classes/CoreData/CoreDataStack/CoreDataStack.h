//
//  CoreDataStack.h
//  5Artists
//
//  Created by Said on 01/12/2014.
//  Copyright (c) 2014 Tower Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (readonly, strong, nonatomic) NSPersistentStore *store;

+ (instancetype)sharedInstance;

- (void)saveContext;

@end