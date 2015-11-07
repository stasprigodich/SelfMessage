//
//  SMChatTextTableViewCell.h
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kChatTextCellID = @"chatTextCellID";

@interface SMChatTextTableViewCell : UITableViewCell

- (void)configureWithText:(NSString*)text;

@end
