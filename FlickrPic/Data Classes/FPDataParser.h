//
//  FPDataParser.h
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPPhoto+CoreDataProperties.h"

@interface FPDataParser : NSObject

- (FPPhoto *)photoFromJSONDictionary:(NSDictionary *)jsonDict
                  searchDetailEntity:(FPSearchDetail *)searchDetail
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (FPSearchDetail *)searchDetailFromText:(NSString *)text
                    managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
