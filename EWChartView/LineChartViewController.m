//
//  LineChartViewController.m
//  EWChartView
//
//  Created by wansy on 15/8/10.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "LineChartViewController.h"
#import "EWLineCharView.h"

@interface LineChartViewController ()<EWLineChartViewDataSource,EWLineChartViewDelegate>

@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSArray *array1;
@property(nonatomic,strong) NSArray *array2;
@property(nonatomic,strong) NSArray *array3;

@property(nonatomic,strong) NSArray *arrayTitle;

@end

@implementation LineChartViewController

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
    
    EWLineCharView *lineChart = [[EWLineCharView alloc] init];
    lineChart.dataSource = self;
    lineChart.delegate =self;
    lineChart.maximumValue = 3.0;
    lineChart.minimumValue = 0.0;
    lineChart.sectionCount = 3;
    lineChart.showGrid = YES;
    lineChart.frame = CGRectMake(10, 50, 300, 200);
    [lineChart reloadData];
    [self.view addSubview:lineChart];
}

#pragma mark - EWLineChartViewDataSource

-(NSUInteger)numberOfLinesInLineChartView:(EWLineCharView *)lineChartView
{
    return self.array.count;
}

-(NSUInteger)lineChartView:(EWLineCharView *)lineChartView numberOfLinesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.array[lineIndex] count];
}

-(CGFloat)lineChartView:(EWLineCharView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [self.array[lineIndex][horizontalIndex] floatValue];
}

#pragma mark - EWLineChartViewDelegate

-(UIColor *)lineChartView:(EWLineCharView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex{
    if (lineIndex == 0) {
        return [UIColor redColor];
    }
    else if(lineIndex == 1)
    {
        return [UIColor yellowColor];
    }
    else
        return [UIColor blueColor];
}


-(NSString *)lineChartView:(EWLineCharView *)lineChartView horizontalTitlseForHorizontalIndex:(NSUInteger)horizontalIndex
{
    return self.arrayTitle[horizontalIndex];
}

-(BOOL)lineChartView:(EWLineCharView *)lineChartView isHollowCircleForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if (lineIndex == 0) {
        return YES;
    }
    else if(lineIndex == 2){
        if (horizontalIndex == 1) {
            return YES;
        }
        return NO;

    }else{
        return NO;
    }
}

@end
