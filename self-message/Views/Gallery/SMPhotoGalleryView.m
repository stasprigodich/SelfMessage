//
//  SMPhotoGalleryView.m
//  self-message
//
//  Created by Stanislav Prigodich on 08/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMPhotoGalleryView.h"
#import "SMPhotosHelper.h"

@interface SMPhotoGalleryView()

@property (nonatomic, strong) UIView* contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;

@property (nonatomic, strong) NSArray* assets;
@property (nonatomic, strong) NSMutableArray* thumbnailViews;

@end

@implementation SMPhotoGalleryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SMPhotoGalleryView"
                                                          owner:self
                                                        options:nil];
        
        UIView* mainView = (UIView*)[nibViews objectAtIndex:0];
        self.contentView = mainView;
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.contentView];
        NSDictionary *views = @{@"contentView": self.contentView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
        [self constructView];
    }
    return self;
}

- (void)constructView {
    __block NSArray *tmpAssets = [SMPhotosHelper getGalleryAssets];
    self.assets = tmpAssets;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void) {
        if (self.assets != nil && self.assets.count > 0)
        {
            [self constructThumbnailViews];
        }
        else
        {
            self.assets = [[NSArray alloc] init];
        }
    });
    
    
}

- (void)constructThumbnailViews {
    self.thumbnailViews = [NSMutableArray new];
    for (ALAsset* asset in self.assets) {
        UIImage* image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *views = @{@"imageView": imageView};
        [imageView  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(==80)]" options:0 metrics:nil views:views]];
        [imageView  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(==80)]" options:0 metrics:nil views:views]];
        [self.imagesScrollView addSubview:imageView];
        [self.thumbnailViews addObject:imageView];
        
        [self.imagesScrollView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imagesScrollView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    }
    
    for (int i = 0; i < self.thumbnailViews.count - 1; i++) {
        NSDictionary *views = @{@"currentView": self.thumbnailViews[i], @"nextView": self.thumbnailViews[i+1]};
        [self.imagesScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentView]-10-[nextView]" options:0 metrics:nil views:views]];
    }
    NSDictionary *views = @{@"firstView": self.thumbnailViews[0], @"lastView": self.thumbnailViews[self.thumbnailViews.count - 1]};
    [self.imagesScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[firstView]" options:0 metrics:nil views:views]];
    [self.imagesScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastView]-10-|" options:0 metrics:nil views:views]];
}

@end
