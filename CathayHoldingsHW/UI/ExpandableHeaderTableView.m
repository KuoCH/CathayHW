//
//  ExpandableHeaderTableView.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "ExpandableHeaderTableView.h"
#import "UIUtils.h"

@interface ExpandableHeaderTableView () {
    UITableView *_tableView;
    UIView *_headerView;
    NSLayoutConstraint *_headerHeightConstraint;
    CGFloat _expandedHeight, _collapsedHeight;
}
@end

@interface ExpandableHeaderTableView (UITableViewDelegate) <UITableViewDelegate>

@end

@implementation ExpandableHeaderTableView

- (instancetype)initWithExpandedHeight:(CGFloat)expandedHeight
                       collapsedHeight:(CGFloat)collapsedHeight {
    self = [super init];
    if (self) {
        [self setupWithExpandedHeight:expandedHeight
                      collapsedHeight:collapsedHeight];
    }
    return self;
}
- (void)setupWithExpandedHeight:(CGFloat)expandedHeight
                collapsedHeight:(CGFloat)collapsedHeight {
    if (expandedHeight > collapsedHeight) {
        _expandedHeight = expandedHeight;
        _collapsedHeight = collapsedHeight;
    } else {
        _expandedHeight = collapsedHeight;
        _collapsedHeight = expandedHeight;
    }
    _tableView = [UITableView new];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(_expandedHeight, 0, 0, 0);
    [_tableView setContentOffset:CGPointMake(0, -_expandedHeight) animated:NO];
    [self addSubview:_tableView];
    [UIUtils fillParentHorizontal:_tableView];
    [UIUtils fillParentVertical:_tableView];

    _headerView = [UIView new];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.clipsToBounds = YES;
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headerView];
    [UIUtils fillParentHorizontal:_headerView];
    [_headerView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    _headerHeightConstraint = [_headerView.heightAnchor constraintEqualToConstant:_expandedHeight];
    _headerHeightConstraint.active = YES;

    _collapsedHeaderView = [UIView new];
    _collapsedHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerView addSubview:_collapsedHeaderView];
    [UIUtils fillParentHorizontal:_collapsedHeaderView];
    [_collapsedHeaderView.topAnchor constraintEqualToAnchor:_headerView.topAnchor].active = YES;
    [_collapsedHeaderView.heightAnchor constraintEqualToConstant:_collapsedHeight].active = YES;
    _collapsedHeaderView.alpha = 0.f;

    _expandedHeaderView = [UIView new];
    _expandedHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerView addSubview:_expandedHeaderView];
    [UIUtils fillParentHorizontal:_expandedHeaderView];
    [_expandedHeaderView.topAnchor constraintEqualToAnchor:_headerView.topAnchor].active = YES;
    [_expandedHeaderView.heightAnchor constraintEqualToConstant:_expandedHeight].active = YES;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    _tableView.dataSource = dataSource;
}

- (id<UITableViewDataSource>)dataSource {
    return _tableView.dataSource;
}


- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}
@end

@implementation ExpandableHeaderTableView (UITableViewDelegate)


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = - scrollView.contentOffset.y;
    height = MAX(_collapsedHeight, MIN(_expandedHeight, height));
    CGFloat expandRatio = (height - _collapsedHeight) / (_expandedHeight - _collapsedHeight);
    _expandedHeaderView.alpha = expandRatio;
    _collapsedHeaderView.alpha = 1 - expandRatio;
    _headerHeightConstraint.constant = height;
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat x = targetContentOffset->x;
    CGFloat y = targetContentOffset->y;
    CGFloat mid = (_expandedHeight + _collapsedHeight) /2;
    if (y < -mid) {
        *targetContentOffset = CGPointMake(x, -_expandedHeight);
    } else if (y < -_collapsedHeight) {
        *targetContentOffset = CGPointMake(x, -_collapsedHeight);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<UITableViewDelegate> delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44;
}
// TODO: bridge required callback from UITableView to ExpandableHeaderTableView's delegate
@end
