//
//  ViewController.m
//  self-message
//
//  Created by Stanislav Prigodich on 04/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMChatViewController.h"

@interface SMChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@end

@implementation SMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - super class

- (BOOL)enableKeyboardHidingOnTouch
{
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    [self animateWithDuration:animationDuration bottomOffset:height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self animateWithDuration:animationDuration bottomOffset:0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - private methods

- (void)animateWithDuration:(CGFloat)duration bottomOffset:(CGFloat)bottomOffset
{
    self.bottomConstraint.constant = bottomOffset;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}



@end
