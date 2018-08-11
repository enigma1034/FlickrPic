//
//  AppDelegate.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 09/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FPNetworkManager.h"
#import "FPImageManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic) FPNetworkManager *sharedNetworkManager;

@property (nonatomic) FPImageManager *imageManager;

- (void)saveContext;


@end

