//
//  HTTPManager.h
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPManager : NSObject
+ (instancetype) sharedInstance;
- (NSURLSessionTask *) httpGetWithUrl:(NSURL *)url
                           withParser:(id (^)(NSData *data, NSURLResponse *response))parser
                            onSuccess:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
- (NSURLSessionTask *) httpGetJSONWithUrl:(NSURL *)url
                                onSuccess:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
