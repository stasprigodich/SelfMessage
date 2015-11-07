//
//  SMAPIManager.m
//  self-message
//
//  Created by Stanislav Prigodich on 07/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import "SMAPIManager.h"
#import <Parse/Parse.h>
#import "SMSettings.h"

@implementation SMAPIManager

+ (void)addMessageWithText:(NSString*)text completion:(void(^)(SMMessage*))completion
{
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"type"] = @(SMMessageTypeText);
    message[@"text"] = text;
    message[@"userId"] = [SMSettings sharedInstance].userID;
    [self saveMessage:message completion:completion];
}

+ (void)addMessageWithImage:(UIImage*)image completion:(void(^)(SMMessage*))completion
{
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"type"] = @(SMMessageTypeImage);
    NSData * binaryImageData = UIImagePNGRepresentation(image);
    PFFile* imageFile = [PFFile fileWithData:binaryImageData];
    message[@"image"] = imageFile;
    message[@"userId"] = [SMSettings sharedInstance].userID;
    [self saveMessage:message completion:completion];
}

+ (void)addMessageWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(void(^)(SMMessage*))completion
{
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"type"] = @(SMMessageTypeLocation);
    PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
    message[@"location"] = geoPoint;
    message[@"userId"] = [SMSettings sharedInstance].userID;
    [self saveMessage:message completion:completion];
}

+ (void)saveMessage:(PFObject*)message completion:(void(^)(SMMessage*))completion
{
    [message saveEventually];
    [message pinInBackground];
    completion([SMMessage initWithParseObject:message]);
}

+ (void)getMessagesWithCompletion:(void(^)(NSArray<SMMessage*>* messages))completion cache:(void(^)(NSArray<SMMessage*>* messages))cache
{
    if (cache) {
        [self getMessagesWithCompletion:cache isFromCache:YES];
    }
    [self getMessagesWithCompletion:completion isFromCache:NO];
}

+ (void)getMessagesWithCompletion:(void (^)(NSArray<SMMessage *> *))completion isFromCache:(BOOL)isFromCache
{
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    if (isFromCache) {
        [query fromLocalDatastore];
    }
    [query whereKey:@"userId" equalTo:[SMSettings sharedInstance].userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            NSMutableArray *array = [NSMutableArray new];
            for (PFObject *object in objects) {
                [array addObject:[SMMessage initWithParseObject:object]];
                NSLog(@"%@", object.objectId);
            }
            completion(array);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
