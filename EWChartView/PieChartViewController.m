//
//  PieChartViewController.m
//  EWChartView
//
//  Created by wansy on 15/8/10.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "PieChartViewController.h"
#import "EWPieChartView.h"

@interface PieChartViewController ()<EWPieChartViewDataSource,EWPieChartViewDelegate>

@property(nonatomic,strong) NSArray *array;

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSArray arrayWithObjects:@"1.5",@"1.2",@"2.3",@"1.1",@"1.7", nil];
    
    EWPieChartView *pie = [[EWPieChartView alloc] init];
    pie.frame = self.view.bounds;
    pie.dataSource = self;
    pie.delegate = self;
    pie.minRadius = 30.0;
    pie.showTitleType = EWPieChartShowTitleOutItem;
    pie.showItemPercent = YES;
    [pie reloadData];
    [self.view addSubview:pie];
}

#pragma mark - EWPieChartViewDataSource

-(NSUInteger)numberOfItemInPieChartView
{
    return self.array.count;
}

-(EWPieChartViewCell *)pieChartView:(EWPieChartView *)pieChartView pieChartViewCellForItemIndex:(NSUInteger)itemIndex
{
    EWPieChartViewCell *cell = [[EWPieChartViewCell alloc] init];
    cell.value = [self.array[itemIndex] floatValue];
    cell.title = [NSString stringWithFormat:@"扇形区域%ld",itemIndex];
    return cell;
}

#pragma mark - EWPieChartViewDelegate

-(void)pieChartView:(EWPieChartView *)pieChartView didSelectItemAtIndex:(NSUInteger)itemIndex
{
    NSLog(@"index:%ld",itemIndex);
}
@end
