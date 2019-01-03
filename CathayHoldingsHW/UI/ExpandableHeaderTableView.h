//
//  ExpandableHeaderTableView.h
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpandableHeaderTableView : UIView
@property (nonatomic, strong, readonly) UIView *expandedHeaderView;
@property (nonatomic, strong, readonly) UIView *collapsedHeaderView;
- (instancetype)initWithExpandedHeight:(CGFloat)expandedHeight
                       collapsedHeight:(CGFloat)collapsedHeight;
@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
