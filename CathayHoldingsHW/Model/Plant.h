//
//  Plant.h
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Plant : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *locatoin;
@property (nonatomic, strong) NSString *feature;
@property (nonatomic, strong) NSString *picUrl;
+ (instancetype)parseWithJSON:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
