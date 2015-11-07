//
//  UITableViewCell+AutoLayoutHeight.m
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "UITableViewCell+AutoLayoutHeight.h"

@implementation UITableViewCell (AutoLayoutHeight)

- (CGFloat)heightWithWidth:(CGFloat)width customizationBlock:(void(^)(id cell))customizationBlock
{
    CGRect cellBounds = [self bounds];
    cellBounds.size.width = width;
    [self setBounds:cellBounds];
    
    if (customizationBlock) {
        customizationBlock(self);
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    return height;
}

@end
