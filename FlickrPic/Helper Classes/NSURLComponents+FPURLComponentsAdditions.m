//
//  NSURLComponents+FPURLComponentsAdditions.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 09/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "NSURLComponents+FPURLComponentsAdditions.h"

@implementation NSURLComponents (FPURLComponentsAdditions)

- (NSURLComponents *)initWithQueryItemsArray:(NSArray<NSURLQueryItem *> *)queryItemsArray {
    self = [super init];
    self.scheme = @"https";
    self.host = @"api.flickr.com";
    self.path = @"/services/rest/";
    self.queryItems = queryItemsArray;
    return self;
}


@end
