//
//  ViewController.m
//  CathayHoldingsHW
//
//  Created by Chia-Han Kuo on 2019/1/3.
//  Copyright © 2019 KuoCH. All rights reserved.
//

#import "ViewController.h"
#import "ExpandableHeaderTableView.h"
#import "UIUtils.h"

#define DATA_CELL_ID @"data"

@interface ViewController () <UITableViewDataSource>
@property (nonatomic, strong) ExpandableHeaderTableView *expandableHeaderTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _expandableHeaderTableView = [[ExpandableHeaderTableView alloc] initWithExpandedHeight:200 collapsedHeight:100];
    _expandableHeaderTableView.dataSource = self;
    _expandableHeaderTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_expandableHeaderTableView];
    [UIUtils fillParentHorizontal:_expandableHeaderTableView];
    [UIUtils fillParentVertical:_expandableHeaderTableView];

    UILabel *expandedLabel = [UILabel new];
    expandedLabel.text = @"Expanded";
    expandedLabel.backgroundColor = [UIColor cyanColor];
    expandedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_expandableHeaderTableView.expandedHeaderView addSubview:expandedLabel];
    [UIUtils fillParentHorizontal:expandedLabel];
    [UIUtils fillParentVertical:expandedLabel];

    UILabel *collapsedLabel = [UILabel new];
    collapsedLabel.text = @"Collapsed";
    collapsedLabel.backgroundColor = [UIColor redColor];
    collapsedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_expandableHeaderTableView.collapsedHeaderView addSubview:collapsedLabel];
    [UIUtils fillParentHorizontal:collapsedLabel];
    [UIUtils fillParentVertical:collapsedLabel];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DATA_CELL_ID];
    UILabel *label;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"items"];
        label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:label];
        [UIUtils fillParentVertical:label];
        [UIUtils fillParentHorizontal:label];
        label.tag = 1;
    } else {
        label = [cell.contentView viewWithTag:1];
    }
    label.text = [@(indexPath.row) description];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}


@end
