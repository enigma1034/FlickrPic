//
//  FPImageManager.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPImageManager.h"
#import "FPImageCacheHelper.h"

@interface FPImageManager ()

@property (nonatomic, strong) FPImageCacheHelper *imageCacheHelper;

@end

@implementation FPImageManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageCacheHelper = [[FPImageCacheHelper alloc] init];
    }
    return self;
}

- (void)getImageForURLString:(NSString *)imageURL
             completionBlock:(void (^)(UIImage *image))completionBlock {
    if ([self.imageCacheHelper getImageDataForKey:imageURL]) {
        completionBlock([self.imageCacheHelper getImageDataForKey:imageURL]);
    } else if ([self.imageCacheHelper getImageFromDiskForKey:imageURL]) {
        completionBlock([self.imageCacheHelper getImageFromDiskForKey:imageURL]);
    } else {
        [self.imageCacheHelper getImageForURLString:imageURL
                                    completionBlock:^(UIImage *image) {
                                        completionBlock(image);
                                    }];
    }
}

- (void)clearAllCache {
    [self.imageCacheHelper clearCache];
}

@end
