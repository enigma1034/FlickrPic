//
//  FPNetworkManager.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 09/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FPNetworkManager : NSURLSession

- (NSURLSessionDataTask *_Nonnull)GET:(NSString *_Nonnull)methodName
                           queryItems:(NSArray <NSURLQueryItem *> *_Nullable)queryItemsArray
                              success:(void (^_Nonnull)(NSData * _Nullable data, NSURLSessionDataTask * _Nonnull dataTask, NSDictionary * _Nullable responseObject))success
                              failure:(void (^_Nonnull)(NSURLSessionDataTask * _Nonnull dataTask, NSError * _Nonnull error))failure;

- (NSURLSessionDownloadTask *_Nonnull)getImageFromURL:(NSString *_Nonnull)imageURL
                                      success:(void (^_Nonnull)(UIImage * _Nullable image, NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))success
                                      failure:(void (^_Nonnull)(NSURLSessionDownloadTask * _Nullable, NSError * _Nonnull))failure;

@end
