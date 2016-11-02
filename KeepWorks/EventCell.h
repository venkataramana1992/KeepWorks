//
//  EventCell.h
//  KeepWorks
//
//  Created by apple on 01/11/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;
@property (weak, nonatomic) IBOutlet UILabel *eventType;
@end
