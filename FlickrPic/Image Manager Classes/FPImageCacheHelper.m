//
//  FPImageCacheHelper.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPImageCacheHelper.h"
#import "FPNetworkManager.h"
#import "AppDelegate.h"

@interface FPImageCacheHelper () {
    NSArray *diskPath;
}

@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) AppDelegate *appD;

@end

@implementation FPImageCacheHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _memoryCache = [[NSCache alloc] init];
        _fileManager = [NSFileManager defaultManager];
        diskPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    }
    return self;
}

- (void)setImageData:(NSData *)imageData forKey:(NSString *)key {
    [self.memoryCache setObject:imageData forKey:key];
}

- (UIImage *)getImageDataForKey:(NSString *)key {
    UIImage *image = [UIImage imageWithData:[self.memoryCache objectForKey:key]];
    return image;
}

- (UIImage *)getImageFromDiskForKey:(NSString *)key {
    NSString *cachedDirectory = diskPath[0];
    NSString *fileDiskPath = [cachedDirectory stringByAppendingString:
                              [NSString stringWithFormat:@"/%@",[self fp_filterFileNameString:key]]];
    if ([self.fileManager fileExistsAtPath:fileDiskPath]) {
        return [UIImage imageWithContentsOfFile:fileDiskPath];
    } else {
        return nil;
    }
}

- (void)getImageForURLString:(NSString *)imageURL
             completionBlock:(void(^)(UIImage *image))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.appD.sharedNetworkManager
         getImageFromURL:imageURL
         success:^(UIImage * _Nullable image,
                   NSURL * _Nullable location,
                   NSURLResponse * _Nullable response,
                   NSError * _Nullable error) {
             NSString *cachedDirectory = diskPath[0];
             NSString *fileDiskPath = [cachedDirectory stringByAppendingString:
                                       [NSString stringWithFormat:@"/%@",[self fp_filterFileNameString:imageURL]]];
             
             if (![self.fileManager fileExistsAtPath:fileDiskPath]) {
                 [UIImagePNGRepresentation(image) writeToFile:fileDiskPath atomically:YES];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 completionBlock(image);
             });
         } failure:^(NSURLSessionDownloadTask * _Nullable d, NSError * _Nonnull error) {
         }];
    });
}

- (NSString *)fp_filterFileNameString:(NSString *)fileName {
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
    return [[fileName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

- (void)clearCache {
    [self.memoryCache removeAllObjects];
    [self.fileManager removeItemAtPath:diskPath[0] error:nil];
}

@end
