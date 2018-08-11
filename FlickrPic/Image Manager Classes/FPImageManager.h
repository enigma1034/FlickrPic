//
//  FPImageManager.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FPImageManager : NSObject

- (instancetype)init;

- (void)getImageForURLString:(NSString *)imageURL completionBlock:(void (^)(UIImage *image))completionBlock;

- (void)clearAllCache;

@end
