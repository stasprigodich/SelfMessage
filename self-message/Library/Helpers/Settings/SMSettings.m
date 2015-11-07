//
//  SMSettings.m
//  self-message
//
//  Created by Stanislav Prigodich on 06/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMSettings.h"

static NSString * const SMSettingsUserIDKey = @"SMSettingsUserIDKey";

@implementation SMSettings

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return  sharedInstance;
}

- (NSString* )userID {
    return [self valueForUserDefaultsKey:SMSettingsUserIDKey];
}

- (void)setUserID:(NSString *)userID {
    [self setValue:userID forUserDefaultsKey:SMSettingsUserIDKey];
}

#pragma mark - User Defaults Logics

- (id)valueForUserDefaultsKey:(id)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setValue:(id)value forUserDefaultsKey:(id)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}

- (BOOL)boolForUserDefaultsKey:(id)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setBool:(BOOL)value forUserDefaultsKey:(id)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
@end
