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

//颜色
#define EWColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//随即色
#define EWRandomColor EWColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))


@interface ViewController ()<EWBarChartViewDataSource,EWBarChartViewDelegate>
//                            EWPieChartViewDataSource,EWPieChartViewDelegate>
//                            EWLineChartViewDataSource,EWLineChartViewDelegate>

@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSArray *arrayTitle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array1 = [NSArray arrayWithObjects:@"1.5",@"1.2",@"2.3",@"1.1",@"1.7", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"1.0",@"1.5",@"0.9",@"2.1",@"1.1", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"1.2",@"0.7",@"1.3",@"1.5",@"1.1", nil];
    self.array = [NSMutableArray array];
    [self.array addObject:array1];
    [self.array addObject:array2];
    [self.array addObject:array3];
    
    self.arrayTitle = [NSArray arrayWithObjects:@"R-1",@"R-2",@"R-3",@"R-4",@"R-5", nil];//[NSArray arrayWithObjects:@"礼拜一",@"礼拜二",@"礼拜三",@"礼拜四",@"礼拜五", nil];
    
    
//    EWPieChartView *pie = [[EWPieChartView alloc] init];
//    pie.frame = self.view.bounds;
//    pie.dataSource = self;
//    pie.delegate = self;
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
//    lineChart.minimumValue = 0.0;
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
    barChart.minimumValue = 0.0;
    barChart.sectionCount = 4;
    
    barChart.xLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor redColor]};
    barChart.coordinateColor = [UIColor redColor];
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
//    else if(lineIndex == 1)
//    {
//        return [UIColor yellowColor];
//    }
//    else
//        return [UIColor blueColor];
//}
//
//
//-(NSString *)lineChartView:(EWLineCharView *)lineChartView horizontalTitlseForHorizontalIndex:(NSUInteger)horizontalIndex
//{
//    return self.arrayTitle[horizontalIndex];
//}
//
//-(BOOL)lineChartView:(EWLineCharView *)lineChartView isHollowCircleForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
//{
//    if (lineIndex == 0) {
//        return YES;
//    }
//    else if(lineIndex == 2){
//        if (horizontalIndex == 1) {
//            return YES;
//        }
//        return NO;
//        
//    }else{
//        return NO;
//    }
//}
//
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
