//
//  PlantProvider.h
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plant.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PlantProviderStatePreparing,
    PlantProviderStateIdle,
    PlantProviderStateQuerying,
    PlantProviderStateQueryFailed,
    PlantProviderStateEnd,
    PlantProviderStateFatalError,
} PlantProviderState;

@protocol PlantProviderDelegate <NSObject>
- (void)onProviderReady;
- (void)onProviderSetupFailed:(NSError *)error;
- (void)onQuerySuccess;
- (void)onQueryFailed:(NSError *)error;
@end
@interface PlantProvider : NSObject
@property(strong, readonly, nonatomic) NSArray<Plant *> *plants;
@property(assign, readonly, nonatomic) PlantProviderState state;
- (instancetype)initWithDelegate:(id<PlantProviderDelegate>)delegate;
- (void)query;
@end

NS_ASSUME_NONNULL_END
