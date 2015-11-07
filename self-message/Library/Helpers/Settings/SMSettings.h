//
//  SMSettings.h
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSettings : NSObject

+ (instancetype)sharedInstance;

@property (readwrite, nonatomic) NSString *userID;

@end
