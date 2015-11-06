//
//  ViewController.m
//  self-message
//
//  Created by Stanislav Prigodich on 04/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMChatViewController.h"
#import "SMTextView.h"

@interface SMChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sendTextButton;
@property (weak, nonatomic) IBOutlet SMTextView *inputTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textInputViewHeightConstraint;

@end

@implementation SMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextView.placeholder = NSLocalizedString(@"Ваше сообщение...", nil);
    self.inputTextView.delegate = self;
}

#pragma mark - super class

- (BOOL)enableKeyboardHidingOnTouch {
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

#pragma mark - actions

- (IBAction)sendTextButtonTapped:(id)sender {
    NSString* textMessage = self.inputTextView.text;
    NSLog(@"%@", textMessage);
    self.inputTextView.text = @"";
    [self textViewDidChange:self.inputTextView];
}

- (IBAction)cameraButtonTapped:(id)sender {
}

- (IBAction)imagesButtonTapped:(id)sender {
}

- (IBAction)locationButtonTapped:(id)sender {
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    self.textInputViewHeightConstraint.constant = MIN(sizeThatFitsTextView.height + 8, 150);
    [self.inputTextView layoutIfNeeded];
    
    if (textView.text.length) {
        [self.sendTextButton setTitleColor:[UIColor colorWithRed:12/255.0f green:133/255.0f blue:254/255.0f alpha:1.0f] forState:UIControlStateNormal];
        self.sendTextButton.enabled = YES;
    } else {
        [self.sendTextButton setTitleColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f] forState:UIControlStateNormal];
        self.sendTextButton.enabled = NO;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - private methods

- (void)animateWithDuration:(CGFloat)duration bottomOffset:(CGFloat)bottomOffset {
    self.bottomConstraint.constant = bottomOffset;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}



@end
