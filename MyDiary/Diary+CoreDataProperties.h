//
//  Diary+CoreDataProperties.h
//  
//
//  Created by zhouhao on 15/11/10.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Diary.h"

NS_ASSUME_NONNULL_BEGIN

@interface Diary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *audioNote;
@property (nullable, nonatomic, retain) NSString *background;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *font;
@property (nullable, nonatomic, retain) NSString *mood;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *video;
@property (nullable, nonatomic, retain) NSString *weather;

@end

NS_ASSUME_NONNULL_END
