//
//  FPDataParser.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 11/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPDataParser.h"
#import "FPPhoto+CoreDataClass.h"
#import "FPSearchDetail+CoreDataClass.h"
#import "FPJSONConstants.h"

@implementation FPDataParser

- (FPPhoto *)photoFromJSONDictionary:(NSDictionary *)jsonDict
                  searchDetailEntity:(FPSearchDetail *)searchDetail
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    FPPhoto *photo;
    NSNumber *photoID = jsonDict[FPPhotoID];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([FPPhoto class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", photoID];
    if (predicate != nil) {
        fetchRequest.predicate = predicate;
    }
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest
                                                           error:&error];
    if (results.count != 0) {
        photo = (FPPhoto *)results[0];
    } else {
       photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([FPPhoto class])
                                      inManagedObjectContext:managedObjectContext];
    }
    
    photo.id = [(NSNumber *)jsonDict[FPPhotoID] longLongValue];
    photo.farm = [(NSNumber *)jsonDict[FPPhotoFarmID] longValue];
    photo.secret = jsonDict[FPPhotoSecret];
    photo.serverId = [jsonDict[FPPhotoServerID] longLongValue];
    photo.title = jsonDict[FPPhotoTitle];
    [[photo mutableSetValueForKey:@"searchDetail"] addObject:searchDetail];
    photo.searchDetail = [photo mutableSetValueForKey:@"searchDetail"];
    
    photo.date = [NSDate date];
    [[searchDetail mutableSetValueForKey:@"photo"] addObject:photo];
    searchDetail.photo = [searchDetail mutableSetValueForKey:@"photo"];
    
    return photo;
}

- (FPSearchDetail *)searchDetailFromText:(NSString *)text
                    managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    FPSearchDetail *searchDetail;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([FPSearchDetail class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text = %@", text];
    if (predicate != nil) {
        fetchRequest.predicate = predicate;
    }
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest
                                                           error:&error];
    if (results.count != 0) {
        searchDetail = (FPSearchDetail *)results[0];
    } else {
        searchDetail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([FPSearchDetail class])
                                              inManagedObjectContext:managedObjectContext];
        searchDetail.text = text;
    }
    [managedObjectContext save:&error];
    return searchDetail;
}

@end
