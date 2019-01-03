//
//  PlantCell.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "PlantCell.h"

@interface PlantCell ()
@property (nonatomic, strong) UIImageView *pic;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UITextView *feature;
@end

@implementation PlantCell

- (instancetype) init {
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:PLANT_CELL_ID];
    if (self) {
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 60, 60)];
        [self.contentView addSubview:self.pic];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(68, 0,
                                                              screenWidth-68, 30)];
        [self.contentView addSubview:self.name];
        self.location = [[UILabel alloc] initWithFrame:CGRectMake(68, 30,
                                                                  screenWidth-68, 30)];
        [self.contentView addSubview:self.location];
        self.feature = [[UITextView alloc] initWithFrame:CGRectMake(0, 60,
                                                                    screenWidth, 40)];
        self.feature.scrollEnabled = NO;
        [self.contentView addSubview:self.feature];
    }
    return self;
}

- (void)setPlant:(Plant *)plant {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _plant = plant;
    self.name.text = plant.name;
    self.location.text = plant.locatoin;
    self.feature.text = plant.feature;
    CGSize newFeatureSize = [self.feature sizeThatFits:CGSizeMake(screenWidth, MAXFLOAT)];
    CGRect rect = self.feature.frame;
    rect.size = newFeatureSize;
    self.feature.frame = rect;
}

+ (CGFloat)heightForPlant:(Plant *)plant {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    UITextView *tv = [UITextView new];
    tv.text = plant.feature;
    CGSize bestFeatureSize = [tv sizeThatFits:CGSizeMake(screenWidth, MAXFLOAT)];
    return bestFeatureSize.height + 60;
}
@end
