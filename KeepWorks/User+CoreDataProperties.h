//
//  User+CoreDataProperties.h
//  KeepWorks
//
//  Created by apple on 01/11/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Event *> *trackedEvents;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)insertObject:(Event *)value inTrackedEventsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTrackedEventsAtIndex:(NSUInteger)idx;
- (void)insertTrackedEvents:(NSArray<Event *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTrackedEventsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTrackedEventsAtIndex:(NSUInteger)idx withObject:(Event *)value;
- (void)replaceTrackedEventsAtIndexes:(NSIndexSet *)indexes withTrackedEvents:(NSArray<Event *> *)values;
- (void)addTrackedEventsObject:(Event *)value;
- (void)removeTrackedEventsObject:(Event *)value;
- (void)addTrackedEvents:(NSOrderedSet<Event *> *)values;
- (void)removeTrackedEvents:(NSOrderedSet<Event *> *)values;

@end

NS_ASSUME_NONNULL_END
