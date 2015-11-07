//
//  SMMessage.h
//  self-message
//
//  Created by Stanislav Prigodich on 07/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef enum : NSUInteger {
    SMMessageTypeText = 0,
    SMMessageTypeImage,
    SMMessageTypeLocation
} SMMessageType;

@interface SMMessage : NSObject

+ (instancetype)initWithParseObject:(PFObject*)parseObject;

@property (nonatomic, assign) SMMessageType type;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
