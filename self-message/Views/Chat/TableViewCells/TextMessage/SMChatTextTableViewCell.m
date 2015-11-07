//
//  SMChatTextTableViewCell.m
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMChatTextTableViewCell.h"

@interface SMChatTextTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

@end

@implementation SMChatTextTableViewCell

- (void)configureWithText:(NSString*)text
{
    self.messageTextLabel.text = text;
}

@end
