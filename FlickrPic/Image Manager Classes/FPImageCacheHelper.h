//
//  FPImageCacheHelper.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FPImageCacheHelper : NSObject

- (instancetype)init;

- (UIImage *)getImageDataForKey:(NSString *)key;

- (UIImage *)getImageFromDiskForKey:(NSString *)key;

- (void)getImageForURLString:(NSString *)imageURL completionBlock:(void(^)(UIImage *image))completionBlock;

- (void)clearCache;

@end
