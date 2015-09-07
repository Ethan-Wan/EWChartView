//
//  ViewController.m
//  EWChartView
//
//  Created by wansy on 15/8/4.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "ViewController.h"
#import "EWSegmentView.h"
#import "BarChartViewController.h"
#import "LineChartViewController.h"
#import "PieChartViewController.h"
#import "EWSegmentHeadView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet EWSegmentHeadView *segmentHeadView;

@property (weak, nonatomic) IBOutlet EWSegmentView *segmentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PieChartViewController *pieChartVC = [[PieChartViewController alloc] init];
    pieChartVC.title = @"饼状图";
    LineChartViewController *lineChartVC = [[LineChartViewController alloc] init];
    lineChartVC.title = @"折现图";
    BarChartViewController *barChartVC = [[BarChartViewController alloc] init];
    barChartVC.title =@"柱状图";
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:lineChartVC];
    [array addObject:barChartVC];
    [array addObject:pieChartVC];
    
    self.segmentView.subViewControllers = array;
    
    self.segmentView.headView = self.segmentHeadView;
}

@end
