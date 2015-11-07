//
//  SMBubbleView.m
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMBubbleView.h"

@implementation SMBubbleView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
