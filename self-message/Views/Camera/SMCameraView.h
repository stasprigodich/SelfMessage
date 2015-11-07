//
//  SMCameraView.h
//  self-message
//
//  Created by Stanislav Prigodich on 07/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCameraViewDelegate <NSObject>

- (void)fullScreenModeChanged;

@end

@interface SMCameraView : UIView

@property (weak, nonatomic) id<SMCameraViewDelegate> delegate;

@end
