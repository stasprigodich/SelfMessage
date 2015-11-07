//
//  SMChatLocationTableViewCell.h
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kChatLocationCellID = @"chatLocationCellID";

@interface SMChatLocationTableViewCell : UITableViewCell

- (void)configureWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
