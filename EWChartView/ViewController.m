//
//  ViewController.m
//  EWChartView
//
//  Created by wansy on 15/8/4.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "ViewController.h"
#import "EWPieChartView.h"
#import "EWLineCharView.h"

@interface ViewController ()<EWLineChartViewDataSource,EWLineChartViewDelegate>

@property(nonatomic,strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    EWPieChartView *pie = [[EWPieChartView alloc] init];
//    pie.frame = self.view.bounds;
//    pie.dataSource = self;
//    pie.delegate = self;
    self.array = [NSArray arrayWithObjects:@"1.0",@"1.5",@"0.3",@"2.1",@"1.1", nil];
//    pie.minRadius = 30.0;
//    pie.showTitleType = EWPieChartShowTitleOutItem;
//    pie.showItemPercent = YES;
//    [pie reloadData];
//    [self.view addSubview:pie];
    
//    EWChartView *chartView = [[EWChartView alloc] init];
//    
//    chartView.frame = self.view.bounds;
//    [self.view addSubview:chartView];
    EWLineCharView *lineChart = [[EWLineCharView alloc] init];
    lineChart.dataSource = self;
    lineChart.delegate =self;
    lineChart.maximumValue = 5.0;
    lineChart.sectionCount = 5;
    lineChart.showGrid = YES;
    lineChart.frame = CGRectMake(10, 50, 300, 200);
    [lineChart reloadData];
    [self.view addSubview:lineChart];
}

-(NSUInteger)lineChartView:(EWLineCharView *)lineChartView numberOfLinesAtLineIndex:(NSUInteger)lineIndex
{
    return self.array.count;
}

-(CGFloat)lineChartView:(EWLineCharView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [self.array[horizontalIndex] floatValue];
}

-(UIColor *)lineChartView:(EWLineCharView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex{
    return [UIColor redColor];
}

//#pragma mark - EWPieChartViewDataSource
//
//-(NSUInteger)numberOfItemInPieChartView
//{
//    return self.array.count;
//}
//
//-(EWPieChartViewCell *)pieChartView:(EWPieChartView *)pieChartView pieChartViewCellForItemIndex:(NSUInteger)itemIndex
//{
//    EWPieChartViewCell *cell = [[EWPieChartViewCell alloc] init];
//    cell.value = [self.array[itemIndex] floatValue];
//    cell.title = [NSString stringWithFormat:@"扇形区域%ld",itemIndex];
//    return cell;
//}

@end
