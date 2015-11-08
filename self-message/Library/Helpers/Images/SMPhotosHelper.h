//
//  SMPhotosHelper.h
//  self-message
//
//  Created by Stanislav Prigodich on 08/11/15.
//  Copyright © 2015 prigodich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SMPhotosHelper : NSObject

+ (NSArray<ALAsset*>*)getGalleryAssets;

@end
