//
//  FPNetworkManager.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 09/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPNetworkManager.h"
#import "NSURLComponents+FPURLComponentsAdditions.h"
#import "FPConstants.h"

@implementation FPNetworkManager

- (NSURLSessionDataTask *)GET:(NSString *)methodName
                   queryItems:(NSArray <NSURLQueryItem *> *)queryItemsArray
                      success:(void (^)(NSData *data, NSURLSessionDataTask * _Nonnull, NSDictionary * _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSURLQueryItem *methodNameItem = [[NSURLQueryItem alloc] initWithName:@"method"
                                                                    value:methodName];
    NSURLQueryItem *apiKeyItem = [[NSURLQueryItem alloc] initWithName:@"api_key"
                                                                value:[[NSUserDefaults standardUserDefaults]
                                                                       objectForKey:FlickrAPIKeyName]];
    NSURLQueryItem *formatItem = [[NSURLQueryItem alloc] initWithName:@"format"
                                                                value:@"json"];
    NSURLQueryItem *callBackItem = [[NSURLQueryItem alloc] initWithName:@"nojsoncallback"
                                                                  value:@"1"];
    
    NSArray *queryArray = @[];
    queryArray  = [queryArray arrayByAddingObjectsFromArray:@[methodNameItem,
                                                              apiKeyItem,
                                                              formatItem,
                                                              callBackItem]];
    queryArray = [queryArray arrayByAddingObjectsFromArray:queryItemsArray];
    
    //FIXME:Not handled duplication
    
    NSURLComponents *searchURLComponents = [[NSURLComponents alloc]
                                            initWithQueryItemsArray:queryArray];
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]
                                       initWithURL:searchURLComponents.URL];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [session dataTaskWithRequest:urlRequest
                          completionHandler:^(NSData *data,
                                              NSURLResponse *response,
                                              NSError *error) {
                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                              if(httpResponse.statusCode == 200)
                              {
                                  NSError *parseError = nil;
                                  NSDictionary *responseDictionary = [NSJSONSerialization
                                                                      JSONObjectWithData:data
                                                                      options:0
                                                                      error:&parseError];
                                  if (parseError) {
                                      failure(nil, error);
                                  } else {
                                      success (data, dataTask, responseDictionary);
                                  }
                                  NSLog(@"The response is - %@",responseDictionary);
                              }
                              else
                              {
                                  failure(nil, error);
                                  NSLog(@"Error");
                              }
                          }];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDownloadTask *_Nonnull)getImageFromURL:(NSString *_Nonnull)imageURL
                                              success:(void (^_Nonnull)(UIImage * _Nullable image, NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))success
                                              failure:(void (^_Nonnull)(NSURLSessionDownloadTask * _Nullable, NSError * _Nonnull))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSURLSessionDownloadTask *downloadTask = nil;
    downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:imageURL]
                              completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                  
                                  if (!error) {
                                      UIImage *downloadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                      success(downloadImage, location, response, error);
                                  } else {
                                      failure(nil, error);
                                  }
    }];
    [downloadTask resume];
    return downloadTask;

}



@end
