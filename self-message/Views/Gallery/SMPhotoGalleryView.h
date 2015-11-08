//
//  SMPhotoGalleryView.h
//  self-message
//
//  Created by Stanislav Prigodich on 08/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPhotoGalleryViewDelegate <NSObject>

@end

@interface SMPhotoGalleryView : UIView

@property (weak, nonatomic) id<SMPhotoGalleryViewDelegate> delegate;

@end
