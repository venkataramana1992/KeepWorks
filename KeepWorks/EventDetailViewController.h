//
//  EventDetailViewController.h
//  KeepWorks
//
//  Created by apple on 01/11/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController
{
    
}

@property (nonatomic, strong) NSDictionary *selectedEventDict;
@property (nonatomic, strong) Event *selectedEvent;
@property (nonatomic, strong) NSString *currentUser;
@end
