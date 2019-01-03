//
//  HTTPManager.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "HTTPManager.h"

@interface HTTPManager ()
@property (nonatomic, strong) NSURLSession * session;
@end

@implementation HTTPManager
+ (instancetype)sharedInstance{
    static HTTPManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HTTPManager new];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (NSURLSessionTask *) httpGetWithUrl:(NSURL *)url
                           withParser:(id (^)(NSData *data, NSURLResponse *response))parser
                            onSuccess:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure {

    NSURLSessionTask * task = [_session dataTaskWithURL:url
                                      completionHandler:
                               ^(NSData * _Nullable data,
                                 NSURLResponse * _Nullable response,
                                 NSError * _Nullable error) {
                                   if (error) {
                                       failure(error);
                                       return;
                                   }
                                   id result = parser(data, response);
                                   if ([result isKindOfClass:[NSError class]]) {
                                       failure(result);
                                       return;
                                   }
                                   success(result);
                               }];
    [task resume];
    return task;
}

- (NSURLSessionTask *) httpGetJSONWithUrl:(NSURL *)url
                                onSuccess:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure {
    return [self httpGetWithUrl:url
                     withParser:^id(NSData *data, NSURLResponse *response) {
                         NSError * err;
                         id json = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&err];
                         if (err) {
                             return err;
                         } else {
                             return json;
                         }
                     }
                      onSuccess:success
                        failure:failure];
}
@end
