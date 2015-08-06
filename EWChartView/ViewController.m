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
#import "EWBarChartView.h"

@interface ViewController ()<EWBarChartViewDataSource,EWBarChartViewDelegate>

@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSArray *arrayTitle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    EWPieChartView *pie = [[EWPieChartView alloc] init];
//    pie.frame = self.view.bounds;
//    pie.dataSource = self;
//    pie.delegate = self;
    
    NSArray *array1 = [NSArray arrayWithObjects:@"1.5",@"1.2",@"2.3",@"1.1",@"1.7", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"1.0",@"1.5",@"0.3",@"2.1",@"1.1", nil];
    self.array = [NSMutableArray array];
    [self.array addObject:array1];
    [self.array addObject:array2];
    
    
    self.arrayTitle = [NSArray arrayWithObjects:@"R-1",@"R-2",@"R-3",@"R-4",@"R-5", nil];//[NSArray arrayWithObjects:@"礼拜一",@"礼拜二",@"礼拜三",@"礼拜四",@"礼拜五", nil];
//    pie.minRadius = 30.0;
//    pie.showTitleType = EWPieChartShowTitleOutItem;
//    pie.showItemPercent = YES;
//    [pie reloadData];
//    [self.view addSubview:pie];
    
//    EWChartView *chartView = [[EWChartView alloc] init];
//    
//    chartView.frame = self.view.bounds;
//    [self.view addSubview:chartView];
    
//-------------------line-----------------
//    EWLineCharView *lineChart = [[EWLineCharView alloc] init];
//    lineChart.dataSource = self;
//    lineChart.delegate =self;
//    lineChart.maximumValue = 3.0;
//    lineChart.sectionCount = 3;
//    lineChart.showGrid = YES;
//    lineChart.frame = CGRectMake(10, 50, 300, 200);
//    [lineChart reloadData];
//    [self.view addSubview:lineChart];
    
    //-------------------bar-----------------
    EWBarChartView *barChart = [[EWBarChartView alloc] init];
    barChart.dataSource = self;
    barChart.delegate =self;
    barChart.maximumValue = 3.0;
    barChart.sectionCount = 3;
    barChart.frame = CGRectMake(10, 50, 300, 200);
    [barChart reloadData];
    [self.view addSubview:barChart];
    
}

//---------------------bar---------------
-(NSUInteger)numberOfBarInBarChartView:(EWBarChartView *)barChartView
{
    return self.array.count;
}

-(NSUInteger)barChartView:(EWBarChartView *)barChartView numberOfBarAtBarIndex:(NSUInteger)barIndex
{
    return [self.array[barIndex] count];
}

-(CGFloat)barChartView:(EWBarChartView *)barChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atBarIndex:(NSUInteger)barIndex
{
    return [self.array[barIndex][horizontalIndex] floatValue];
}

-(NSString *)barChartView:(EWBarChartView *)barChartView horizontalTitlseForHorizontalIndex:(NSUInteger)horizontalIndex
{
    return self.arrayTitle[horizontalIndex];
}

-(UIColor *)barChartView:(EWBarChartView *)barChartView colorForBarAtBarIndex:(NSUInteger)barIndex
{
    if (barIndex == 0) {
        return [UIColor redColor];
    }
    else
    {
        return [UIColor greenColor];
    }
}

//-----------------------line-----------------
//-(NSUInteger)numberOfLinesInLineChartView:(EWLineCharView *)lineChartView
//{
//    return self.array.count;
//}
//
//-(NSUInteger)lineChartView:(EWLineCharView *)lineChartView numberOfLinesAtLineIndex:(NSUInteger)lineIndex
//{
//    return [self.array[lineIndex] count];
//}
//
//-(CGFloat)lineChartView:(EWLineCharView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
//{
//    return [self.array[lineIndex][horizontalIndex] floatValue];
//}
//
//-(UIColor *)lineChartView:(EWLineCharView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex{
//    if (lineIndex == 0) {
//        return [UIColor redColor];
//    }
//    else
//    {
//        return [UIColor yellowColor];
//    }
//}
//
//
//-(NSString *)lineChartView:(EWLineCharView *)lineChartView horizontalTitlseForHorizontalIndex:(NSUInteger)horizontalIndex
//{
//    return self.arrayTitle[horizontalIndex];
//}

//---------------------pie---------------------
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
