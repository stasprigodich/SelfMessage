//
//  ViewController.m
//  self-message
//
//  Created by Stanislav Prigodich on 04/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMChatViewController.h"
#import "SMTextView.h"
#import "SMChatTextTableViewCell.h"
#import "SMChatPictureTableViewCell.h"
#import "SMChatLocationTableViewCell.h"
#import "SMSettings.h"
#import "SMAPIManager.h"
#import "SMCameraView.h"
#import "UITableViewCell+AutoLayoutHeight.h"

static const int cameraViewHeight = 230;
static const int cameraViewTag = 3;

@interface SMChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CLLocationManagerDelegate, SMCameraViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sendTextButton;
@property (weak, nonatomic) IBOutlet SMTextView *inputTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textInputViewHeightConstraint;

@property (nonatomic, strong) NSMutableArray<SMMessage*>* messages;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocation;

@property (nonatomic, strong) NSLayoutConstraint* heightPickerViewConstraint;

@property (nonatomic, strong) SMCameraView* cameraView;

@end

@implementation SMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [NSMutableArray new];
    self.inputTextView.placeholder = NSLocalizedString(@"Ваше сообщение...", nil);
    self.inputTextView.delegate = self;

    self.cameraView = [[SMCameraView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - cameraViewHeight, self.view.frame.size.width, cameraViewHeight)];
    self.cameraView.delegate = self;
    self.cameraView.tag = cameraViewTag;
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    } else {
        NSLog(@"Location services are not enabled");
    }
    
    [self loadFromCache];
    [self loadData];
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
    __weak typeof(self) weakSelf = self;
    [SMAPIManager addMessageWithText:textMessage completion:^(SMMessage *message) {
        [weakSelf.messages addObject:message];
        [weakSelf updateDataWithMessages:weakSelf.messages];
    }];
    self.inputTextView.text = @"";
    [self textViewDidChange:self.inputTextView];
}

- (IBAction)cameraButtonTapped:(id)sender {
    if (![self.view viewWithTag:cameraViewTag]) {
        [self.view addSubview:self.cameraView];
        [self.cameraView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *views = @{@"cameraView": self.cameraView};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cameraView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cameraView]|" options:0 metrics:nil views:views]];
        self.heightPickerViewConstraint = [[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[cameraView(==%d)]", cameraViewHeight] options:0 metrics:nil views:views] firstObject];
        [self.cameraView addConstraint:self.heightPickerViewConstraint];
    }
    [self animateWithDuration:0.3 bottomOffset:cameraViewHeight];
}

- (IBAction)imagesButtonTapped:(id)sender {
}

- (IBAction)locationButtonTapped:(id)sender {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.lastLocation = nil;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    __weak typeof(self) weakSelf = self;
    if (!self.lastLocation) {
        self.lastLocation = [locations lastObject];
        [SMAPIManager addMessageWithLatitude:self.lastLocation.coordinate.latitude longitude:self.lastLocation.coordinate.longitude completion:^(SMMessage *message) {
            [weakSelf.messages addObject:message];
            [weakSelf updateDataWithMessages:weakSelf.messages];
        }];
    }
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

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
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMMessage* message = self.messages[indexPath.row];
    if (message.type == SMMessageTypeText) {
        SMChatTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatTextCellID];
        [cell configureWithText:message.text];
        return cell;
    } else if (self.messages[indexPath.row].type == SMMessageTypeImage) {
        SMChatPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatPictureCellID];
        [cell configureWithImage:message.image];
        return cell;
    } else {
        SMChatLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatLocationCellID];
        [cell configureWithLatitude:message.location.latitude longitude:message.location.longitude];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMMessage* message = self.messages[indexPath.row];
    if (message.type == SMMessageTypeText) {
        SMChatTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatTextCellID];
        CGFloat height = [cell heightWithWidth:self.tableView.frame.size.width customizationBlock:^(id cell) {
            [cell configureWithText:message.text];
        }];
        return height;
    }
    return 150;
}

#pragma mark - SMCameraViewDelegage

- (void)fullScreenModeChanged {
    if (self.heightPickerViewConstraint.constant < self.view.frame.size.height) {
        self.heightPickerViewConstraint.constant = self.view.frame.size.height;
    } else {
        self.heightPickerViewConstraint.constant = cameraViewHeight;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - private methods

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [SMAPIManager getMessagesWithCompletion:^(NSArray<SMMessage *> *messages) {
        [weakSelf updateDataWithMessages:messages];
    } isFromCache:NO];
}

- (void)loadFromCache {
    __weak typeof(self) weakSelf = self;
    [SMAPIManager getMessagesWithCompletion:^(NSArray<SMMessage *> *messages) {
        [weakSelf updateDataWithMessages:messages];
    } isFromCache:YES];
}

- (void)updateDataWithMessages:(NSArray<SMMessage*> *)messages {
    self.messages = [NSMutableArray arrayWithArray:messages];
    
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom {
    if (self.messages.count > 0) {
        NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)animateWithDuration:(CGFloat)duration bottomOffset:(CGFloat)bottomOffset {
    self.bottomConstraint.constant = bottomOffset;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
}



@end
