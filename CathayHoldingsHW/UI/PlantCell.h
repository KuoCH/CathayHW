//
//  PlantCell.h
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plant.h"
#define PLANT_CELL_ID @"plant_cell"

NS_ASSUME_NONNULL_BEGIN

@interface PlantCell : UITableViewCell
@property (nonatomic, strong) Plant *plant;
+ (CGFloat) heightForPlant:(Plant *)plant;
@end

NS_ASSUME_NONNULL_END
