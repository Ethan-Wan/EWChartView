//
//  ViewController.m
//  EWChartView
//
//  Created by wansy on 15/8/4.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "ViewController.h"
#import "EWPieChartView.h"

@interface ViewController ()<EWPieChartViewDataSource,EWPieChartViewDelegate>

@property(nonatomic,strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EWPieChartView *pie = [[EWPieChartView alloc] init];
    pie.frame = self.view.bounds;
    pie.dataSource = self;
    pie.delegate = self;
    self.array = [NSArray arrayWithObjects:@"1.0",@"2.0",@"2.0",@"5.0", nil];
    pie.minRadius = 50.0;
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
    return cell;
}
//-(CGFloat)pieChartView:(EWPieChartView *)pieChartView itemValueForItemIndex:(NSUInteger)itemIndex
//{
//    return [self.array[itemIndex] floatValue];
//}

@end
