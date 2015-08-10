//
//  BarChartViewController.m
//  EWChartView
//
//  Created by wansy on 15/8/10.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "BarChartViewController.h"
#import "EWBarChartView.h"

@interface BarChartViewController ()<EWBarChartViewDataSource,EWBarChartViewDelegate>

@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSArray *array1;
@property(nonatomic,strong) NSArray *array2;
@property(nonatomic,strong) NSArray *array3;

@property(nonatomic,strong) NSArray *arrayTitle;

@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array1 = [NSArray arrayWithObjects:@"1.5",@"1.2",@"2.3",@"1.1",@"1.7", nil];
    self.array2 = [NSArray arrayWithObjects:@"1.0",@"1.5",@"0.9",@"2.1",@"1.1", nil];
    self.array3 = [NSArray arrayWithObjects:@"1.2",@"0.7",@"1.3",@"1.5",@"1.1", nil];
    self.array = [NSMutableArray array];
    [self.array addObject:self.array1];
    [self.array addObject:self.array2];
    [self.array addObject:self.array3];
    
    self.arrayTitle = [NSArray arrayWithObjects:@"R-1",@"R-2",@"R-3",@"R-4",@"R-5", nil];//[NSArray arrayWithObjects:@"礼拜一",@"礼拜二",@"礼拜三",@"礼拜四",@"礼拜五", nil];
    
    EWBarChartView *barChart = [[EWBarChartView alloc] init];
    barChart.dataSource = self;
    barChart.delegate =self;
    barChart.maximumValue = 3.0;
    barChart.minimumValue = 0.0;
    barChart.sectionCount = 4;

    barChart.xLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor redColor]};
    barChart.coordinateColor = [UIColor redColor];
    barChart.frame = CGRectMake(10, 50, 300, 200);
    [barChart reloadData];
    [self.view addSubview:barChart];
}

#pragma mark - EWBarChartViewDataSource

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

#pragma mark - EWBarChartViewDelegate

-(UIColor *)barChartView:(EWBarChartView *)barChartView colorForBarAtBarIndex:(NSUInteger)barIndex
{
    if (barIndex == 0) {
        return [UIColor redColor];
    }
    else if(barIndex == 1)
    {
        return [UIColor yellowColor];
    }
    return nil;
}

-(UIColor *)barChartView:(EWBarChartView *)barChartView colorForBarAtHorizontalIndex:(NSUInteger)horizontalIndex
{
    switch (horizontalIndex) {
        case 0:
            return [UIColor redColor];
            break;
        case 1:
            return [UIColor blackColor];
            break;
        case 2:
            return [UIColor greenColor];
            break;
        case 3:
            return [UIColor yellowColor];
            break;
        case 4:
            return [UIColor grayColor];
            break;

        default:
            break;
    }return nil;
}
@end
