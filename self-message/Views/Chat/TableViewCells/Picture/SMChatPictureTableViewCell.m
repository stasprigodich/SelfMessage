//
//  SMChatPictureTableViewCell.m
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMChatPictureTableViewCell.h"

@interface SMChatPictureTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;

@end

@implementation SMChatPictureTableViewCell

- (void)configureWithImage:(UIImage*)image
{
    self.messageImageView.image = image;
}

@end
