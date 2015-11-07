//
//  SMCameraView.m
//  self-message
//
//  Created by Stanislav Prigodich on 07/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMCameraView.h"

@interface SMCameraView() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic) UIImagePickerController* pickerController;
@property (nonatomic, strong) UIView* contentView;
@property (weak, nonatomic) IBOutlet UIView *sendBorderView;

@end

@implementation SMCameraView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SMCameraView"
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
    self.pickerController = [[UIImagePickerController alloc] init];
    [self.pickerController setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self.pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        self.pickerController.showsCameraControls = NO;
        self.pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    float cameraAspectRatio = 3.0 / 3.0;
    float imageWidth = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
    
    self.pickerController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    
    self.pickerView = self.pickerController.view;
    [self.pickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView insertSubview:self.pickerView belowSubview:self.toolView];
    
    NSDictionary *views = @{@"pickerView": self.pickerView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pickerView]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pickerView]|" options:0 metrics:nil views:views]];
    
    self.sendBorderView.layer.cornerRadius = 30;
    self.sendBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sendBorderView.layer.borderWidth = 1;
}

#pragma mark - actions

- (IBAction)fullScreenButtonTapped:(id)sender {
    [self.delegate fullScreenModeChanged];
}

- (IBAction)switchCameraButtonTapped:(id)sender {
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        if (self.pickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
            self.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else {
            self.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
}

@end
