//
//  SMMessage.m
//  self-message
//
//  Created by Stanislav Prigodich on 07/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMMessage.h"

@implementation SMMessage

+ (instancetype)initWithParseObject:(PFObject*)parseObject
{
    SMMessage* message = [[SMMessage alloc] init];
    message.type = [parseObject[@"type"] intValue];
    switch (message.type) {
        case SMMessageTypeText:
            message.text = parseObject[@"text"];
            break;
        case SMMessageTypeImage:
            message.image = [UIImage imageWithData:[((PFFile*)parseObject[@"image"]) getData]];
            break;
        case SMMessageTypeLocation:
            message.location = CLLocationCoordinate2DMake(((PFGeoPoint*)parseObject[@"location"]).latitude, ((PFGeoPoint*)parseObject[@"location"]).longitude);
            break;
        default:
            break;
    }
    return message;
}

@end
