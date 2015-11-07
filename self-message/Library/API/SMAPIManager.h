//
//  SMAPIManager.h
//  self-message
//
//  Created by Stanislav Prigodich on 07/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMMessage.h"

@interface SMAPIManager : NSObject

+ (void)addMessageWithText:(NSString*)text completion:(void(^)(SMMessage*))completion;
+ (void)addMessageWithImage:(UIImage*)image completion:(void(^)(SMMessage*))completion;
+ (void)addMessageWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(void(^)(SMMessage*))completion;

+ (void)getMessagesWithCompletion:(void (^)(NSArray<SMMessage *> *))completion isFromCache:(BOOL)isFromCache;

@end
