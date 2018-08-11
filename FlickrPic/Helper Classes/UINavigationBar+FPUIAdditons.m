//
//  UINavigationBar+FPUIAdditons.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "UINavigationBar+FPUIAdditons.h"

@implementation UINavigationBar (FPUIAdditons)

- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    CGRect bottomBorderRect = CGRectMake(0,
                                         CGRectGetHeight(self.frame),
                                         CGRectGetWidth(self.frame),
                                         height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self addSubview:bottomBorder];
}

@end
