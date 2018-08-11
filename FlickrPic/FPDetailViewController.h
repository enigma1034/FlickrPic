//
//  FPDetailViewController.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 12/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPImageManager.h"

@interface FPDetailViewController : UIViewController

- (instancetype)initWithPhotoThumbnail:(UIImage *)thumbImage
                              photoURL:(NSString *)photoURL
                          imageManager:(FPImageManager *)imageManager
                                 title:(NSString *)title;
@end
