//
//  UITableViewCell+AutoLayoutHeight.h
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (AutoLayoutHeight)

- (CGFloat)heightWithWidth:(CGFloat)width customizationBlock:(void(^)(id cell))customizationBlock;

@end
