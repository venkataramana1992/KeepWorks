//
//  Event+CoreDataProperties.h
//  KeepWorks
//
//  Created by apple on 01/11/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSString *eventPlace;
@property (nullable, nonatomic, retain) NSString *eventType;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
