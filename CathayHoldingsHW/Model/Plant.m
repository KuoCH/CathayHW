//
//  Plant.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "Plant.h"

@implementation Plant

/***
 {
   "F_Name_Ch": "臺灣山菊",
   "F_Location": "蕨園；蟲蟲探索谷；亞洲熱帶雨林區",
   "F_Feature": "莖可能幾乎無毛或具有灰褐色長毛。葉長度6~30公分，寬度4~15公分，呈腎形，葉柄長達10~38公分，從根而非莖長出。開花的莖長度30~75公分，花的排列模式稱為頭狀花序，直徑4~6公分。花形可分為舌頭狀及管狀，舌狀花長度5~6公分，寬度3~4公分，管狀花長度僅11~12公厘。果實長度5~6.5公厘，呈圓柱狀，乾燥，多毛，每顆果實僅有一顆種子，種子長有類似蒲公英的冠毛，長度8~11公厘，呈暗褐色。",
   "F_Pic01_URL": "http:\/\/www.zoo.gov.tw\/iTAP\/04_Plant\/Asteraceae\/Farfugium\/Farfugium_1.jpg",
   ...
 }
 ***/
+ (instancetype) parseWithJSON:(NSDictionary *)json {
    if (json == nil || ![json isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *name = json[@"F_Name_Ch"];
    if (name == nil || ![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *location = json[@"F_Location"];
    if (location == nil || ![location isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *feature = json[@"F_Feature"];
    if (feature == nil || ![feature isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *picUrl = json[@"F_Pic01_URL"];
    if (picUrl == nil || ![picUrl isKindOfClass:[NSString class]]) {
        return nil;
    }
    return [[Plant alloc] initWithName:name
                              location:location
                               feature:feature
                                picUrl:picUrl];
}

- (instancetype) initWithName:(NSString *)name
                     location:(NSString *)location
                      feature:(NSString *)feature
                       picUrl:(NSString *)picUrl {
    self = [super init];
    if (self) {
        _name = name;
        _locatoin = location;
        _feature = feature;
        _picUrl = picUrl;
    }
    return self;
}
@end
