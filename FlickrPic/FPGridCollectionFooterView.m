//
//  FPGridCollectionFooterView.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPGridCollectionFooterView.h"

@interface FPGridCollectionFooterView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation FPGridCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupActivityIndicatorView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setupActivityIndicatorView {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidden = NO;
    [self addSubview:self.activityIndicator];
    [self fp_addConstraintsToActivityIndicator];
}

- (void)fp_addConstraintsToActivityIndicator {
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)startActivityIndicatorAnimation {
    [self.activityIndicator startAnimating];
}

- (void)endActivityIndicatorAnimation {
    [self.activityIndicator stopAnimating];
}

@end
