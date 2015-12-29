//
//  DiaryStore.h
//  MyDiary
//
//  Created by zhouhao on 15-3-22.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// Using the '@import' keyword makes Xcode load the Core Data framework
@import CoreData;

#import "Diary+CoreDataProperties.h"

@interface DiaryStore : NSObject
@property (nonatomic)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic)NSManagedObjectContext *managedObjectContext;
@property(nonatomic)NSManagedObjectModel *managedObjectModel;
//@property(nonatomic)EKEventStore* eventstore;
+(instancetype)defaultStack;

- (void)saveContext;
- (NSFetchedResultsController *)createfetchedResultsController;
- (NSURL *)applicationDocumentsDirectory;
@end
