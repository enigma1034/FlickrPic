//
//  NSURLComponents+FPURLComponentsAdditions.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 09/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLComponents (FPURLComponentsAdditions)

- (NSURLComponents *)initWithQueryItemsArray:(NSArray<NSURLQueryItem *> *)queryItemsArray;

@end
