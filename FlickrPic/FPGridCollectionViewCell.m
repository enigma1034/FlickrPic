//
//  FPGridCollectionViewCell.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPGridCollectionViewCell.h"

@interface FPGridCollectionViewCell ()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation FPGridCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:imageView];
    self.imageView = imageView;
    [self fp_addConstraintsToImageView];
}

- (void)fp_addConstraintsToImageView {
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.imageView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imageView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.imageView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0];
    
    [self addConstraints:@[leading, trailing, top, bottom]];
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    
}

- (UIImage *)getImage {
    return self.imageView.image;
}

@end
