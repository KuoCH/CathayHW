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
#import "PlantProvider.h"

#define DATA_CELL_ID @"data"

@interface ViewController ()
@property (nonatomic, strong) ExpandableHeaderTableView *expandableHeaderTableView;
@property (nonatomic, strong) PlantProvider *plantProvider;
@property (nonatomic, strong) NSArray<Plant *> *plants;
@end

@interface ViewController (UITableView) <UITableViewDataSource, UITableViewDelegate>
@end

@interface ViewController (PlantProviderDelegate) <PlantProviderDelegate>
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup UI
    _expandableHeaderTableView = [[ExpandableHeaderTableView alloc] initWithExpandedHeight:200 collapsedHeight:100];
    _expandableHeaderTableView.dataSource = self;
    _expandableHeaderTableView.delegate = self;
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

    // Plant Provider
    self.plantProvider = [[PlantProvider alloc] initWithDelegate:self];
    self.plants = @[];
}

@end

@implementation ViewController (UITableView)
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
    if (indexPath.section == 1) {
        switch (self.plantProvider.state) {
            case PlantProviderStatePreparing:
                label.text = @"Preparing";
                break;
            case PlantProviderStateIdle:
                [self.plantProvider query];
            case PlantProviderStateQuerying:
                label.text = @"Loading";
                break;
            case PlantProviderStateQueryFailed:{
                label.text = @"Load failed, tap to retry";
                break;
            }
            case PlantProviderStateEnd:
                label.text = @"No more data";
                break;
            case PlantProviderStateFatalError:
                label.text = @"Error!";
                break;
        }
    } else {
        label.text = _plants[indexPath.row].name;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _plants.count;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.plantProvider query];
        [self.expandableHeaderTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:YES];
    }
}
@end

@implementation ViewController (PlantProviderDelegate)
- (void)onProviderReady {
    [self.plantProvider query];
}

- (void)onProviderSetupFailed:(nonnull NSError *)error {
    [self.expandableHeaderTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:YES];
}

- (void)onQuerySuccess {
    NSUInteger previousCount = _plants.count;
    _plants = self.plantProvider.plants;
    NSMutableArray<NSIndexPath *> *paths = [NSMutableArray new];
    for (NSUInteger i = previousCount; i < _plants.count; i++) {
        [paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.expandableHeaderTableView insertRowsAtIndexPaths:paths withRowAnimation:NO];
}

- (void)onQueryFailed:(nonnull NSError *)error {
    [self.expandableHeaderTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:YES];
}

@end
