//
//  FPDetailViewController.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 12/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPDetailViewController.h"
#import "AppDelegate.h"
#import "UINavigationBar+FPUIAdditons.h"

static CGFloat const ThumbImageViewWidth = 100.0f;

@interface FPDetailViewController () {
    FPImageManager *commonImageManager;
}


@property (nonatomic) AppDelegate *appD;
@property (nonatomic) UIImage *thumbImage;
@property (nonatomic) NSString *photoURL;
@property (nonatomic) UIImageView *thumbImageView;
@property (nonatomic) UIImageView *detailImageView;
@property (nonatomic) NSString *imageTitle;

@end

@implementation FPDetailViewController

- (instancetype)initWithPhotoThumbnail:(UIImage *)thumbImage
                              photoURL:(NSString *)photoURL
                          imageManager:(FPImageManager *)imageManager
                                 title:(NSString *)fp_imageTitle {
    self = [super init];
    if (self) {
        _appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _thumbImage = thumbImage;
        _photoURL = photoURL;
        commonImageManager = imageManager;
        _imageTitle = fp_imageTitle;
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.thumbImageView = [[UIImageView alloc] initWithImage:self.thumbImage];
    [self.thumbImageView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - ThumbImageViewWidth,
                                             ([UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height)/2 - ThumbImageViewWidth ,
                                             ThumbImageViewWidth,
                                             ThumbImageViewWidth)];
    self.thumbImageView.image = self.thumbImage;
    
    self.detailImageView = [[UIImageView alloc] initWithImage:nil];
    [self.detailImageView setFrame:CGRectMake(0,
                                              0,
                                              [UIScreen mainScreen].bounds.size.width,
                                              [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height)];
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.thumbImageView];
    [self.view addSubview:self.detailImageView];
    [self.detailImageView setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:NULL];
    [item setBackButtonTitlePositionAdjustment:UIOffsetZero
                                 forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.backBarButtonItem = item;
    [self.navigationItem setTitle:self.imageTitle];

    [self.navigationController.navigationBar setBottomBorderColor:[UIColor colorWithRed:255.0f/255.0f
                                                                                  green:255.0f/255.0f
                                                                                   blue:255.0f/255.0f
                                                                                  alpha:1.0] height:1];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [commonImageManager getImageForURLString:self.photoURL
                             completionBlock:^(UIImage *image) {
                                 if (image != nil) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.detailImageView setHidden:NO];
                                         [self.thumbImageView setHidden:YES];
                                         self.detailImageView.image = image;
                                     });
                                 }
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
