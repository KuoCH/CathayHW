//
//  UIUtils.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils
+ (void)fillParentHorizontal:(UIView *)v {
    UILayoutGuide *guide = v.superview.safeAreaLayoutGuide;
    [v.leftAnchor constraintEqualToAnchor:guide.leftAnchor].active = YES;
    [v.rightAnchor constraintEqualToAnchor:guide.rightAnchor].active = YES;
}
+ (void)fillParentVertical:(UIView *)v {
    UILayoutGuide *guide = v.superview.safeAreaLayoutGuide;
    [v.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
    [v.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
}
@end
