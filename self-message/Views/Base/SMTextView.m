//
//  SMTextView.m
//  self-message
//
//  Created by Stanislav Prigodich on 05/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMTextView.h"

@interface SMTextView()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation SMTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


- (void)textChanged:(NSNotification *)notification {
    if (self.placeholder.length == 0)
        return;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self showOrHidePlaceholder];
    }];
}

- (void)showOrHidePlaceholder {
    if (self.text.length == 0)
        [self.placeholderLabel setAlpha:1.0];
    else
        [self.placeholderLabel setAlpha:0];
}

- (void)drawRect:(CGRect)rect {
    if (self.placeholder.length > 0) {
        if (self.placeholderLabel == nil) {
            
            float linePadding = self.textContainer.lineFragmentPadding;
            CGRect placeholderRect = CGRectMake(self.textContainerInset.left + linePadding,
                                                self.textContainerInset.top,
                                                rect.size.width - self.textContainerInset.left - self.textContainerInset.right - 2 * linePadding,
                                                rect.size.height - self.textContainerInset.top - self.textContainerInset.bottom);
            self.placeholderLabel = [[UILabel alloc]initWithFrame:placeholderRect];
            self.placeholderLabel.font = self.font;
            self.placeholderLabel.textAlignment = self.textAlignment;
            self.placeholderLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
            [self addSubview:self.placeholderLabel];
            
            self.placeholderLabel.text = self.placeholder;
            [self.placeholderLabel sizeToFit];
        }
        [self showOrHidePlaceholder];
    }
    
    [super drawRect:rect];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self showOrHidePlaceholder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
