//
//  SMViewController.h
//  self-message
//
//  Created by Stanislav Prigodich on 04/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMViewController : UIViewController

@property (nonatomic) BOOL enableKeyboardHidingOnTouch;

- (void)dismissKeyboard;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

@end
