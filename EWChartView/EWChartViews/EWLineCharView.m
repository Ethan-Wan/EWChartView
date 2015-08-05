//
//  EWLineCharView.m
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWLineCharView.h"

//default parameter
BOOL static const kEWPieChartViewShowGrid = NO;

@interface JBLineChartPoint : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) BOOL hidden;

@end

@interface EWLineCharView()

@property (nonatomic, strong) NSArray *chartData;

@end

@implementation EWLineCharView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

#pragma mark - Private Method

- (void)setup
{
    self.showGrid = kEWPieChartViewShowGrid;
}

/**
 *  画网格
 *
 *  @param ctx 上下文
 */
-(void)drawGrid:(CGContextRef)ctx
{
     CGFloat verticalLength = (self.bounds.size.height - kEWChartViewHeaderPadding - kEWChartViewXAxisHeight)/self.sectionCount;
    
    for (int index = 0; index < self.sectionCount + 1; index++) {
        CGContextSaveGState(ctx);
        {
            CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth, kEWChartViewHeaderPadding + verticalLength * index);
            CGContextAddLineToPoint(ctx, self.bounds.size.width, kEWChartViewHeaderPadding + verticalLength * index);
            [self.coordinateColor set];
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    
    CGFloat dataCount = [self dataCount];
    CGFloat horizontalSpace = (self.bounds.size.width - kEWChartViewYAxisWidth - 0.5) / dataCount;
    
    for (int index = 0; index < dataCount; index++) {
        CGContextSaveGState(ctx);
        {
            CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth + index * horizontalSpace, kEWChartViewHeaderPadding);
            CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth + index * horizontalSpace, self.bounds.size.height - kEWChartViewXAxisHeight);
            [self.coordinateColor set];
//            可设置虚线
//            CGContextSetLineDash(ctx, <#CGFloat phase#>, <#const CGFloat *lengths#>, <#size_t count#>)
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }

}

/**
 *  水平方向上数据个数
 *
 *  @return 数据个数
 */
- (NSUInteger)dataCount
{
    NSUInteger dataCount = 0;
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfLinesInLineChartView:)], @"EWLineChartView // dataSource must implement - (NSUInteger)numberOfLinesInLineChartView:(EWLineChartView *)lineChartView");
    NSInteger numberOfLines = [self.dataSource numberOfLinesInLineChartView:self];
    for (NSInteger lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
    {
        NSAssert([self.dataSource respondsToSelector:@selector(lineChartView:numberOfLinesAtLineIndex:)], @"EWLineChartView // dataSource must implement - (NSUInteger)lineChartView:(EWLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex");
        NSUInteger lineDataCount = [self.dataSource lineChartView:self numberOfLinesAtLineIndex:lineIndex];
        if (lineDataCount > dataCount)
        {
            dataCount = lineDataCount;
        }
    }
    return dataCount;
}

/**
 *  将数据转化成图表中的高度
 *
 *  @param valueHeight 水平方向上数据的值
 */
-(CGFloat)standardizedHeightForvalueHeight:(CGFloat)valueHeight
{
    return 0;
}
#pragma mark - Public Method

-(void)reloadData
{
     __block CGRect mainViewRect = CGRectMake(kEWChartViewYAxisWidth, kEWChartViewHeaderPadding, self.bounds.size.width - kEWChartViewYAxisWidth -0.5, self.bounds.size.height - kEWChartViewXAxisHeight - kEWChartViewHeaderPadding);
    
        
        CGFloat pointSpace = mainViewRect.size.width / [self dataCount]; // Space in between points
    
//      CGFloat xOffset = chartPadding + pointSpace * 0.5 + self.lefterView.frame.size.width;
//      CGFloat yOffset = 0;
    
        NSMutableArray *mutableChartData = [NSMutableArray array];
        NSUInteger numberOfLines = [self.dataSource numberOfLinesInLineChartView:self];
        for (NSUInteger lineIndex=0; lineIndex<numberOfLines; lineIndex++)
        {
            NSUInteger dataCount = [self.dataSource lineChartView:self numberOfLinesAtLineIndex:lineIndex];
            NSMutableArray *chartPointData = [NSMutableArray array];
            for (NSUInteger horizontalIndex=0; horizontalIndex<dataCount; horizontalIndex++)
            {
                NSAssert([self.dataSource respondsToSelector:@selector(lineChartView:verticalValueForHorizontalIndex:atLineIndex:)], @"EWLineChartView // dataSource must implement - (CGFloat)lineChartView:(EWLineCharView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex");
                CGFloat valueHeight =  [self.dataSource lineChartView:self verticalValueForHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
                
                JBLineChartPoint *chartPoint = [[JBLineChartPoint alloc] init];
                
//                CGFloat normalizedHeight = [self standardizedHeightForvalueHeight:valueHeight];
//                yOffset = mainViewRect.size.height - normalizedHeight;
//                
//                chartPoint.position = CGPointMake(xOffset, yOffset);
//                
//                [chartPointData addObject:chartPoint];
//                xOffset += pointSpace;
            }
//            [mutableChartData addObject:chartPointData];
//            xOffset = chartPadding + pointSpace * 0.5 + self.lefterView.frame.size.width;
        }
        self.chartData = [NSArray arrayWithArray:mutableChartData];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (self.showGrid) {
        CGContextSaveGState(ctx);
        [self drawGrid:ctx];
        CGContextRestoreGState(ctx);
    }
}

#pragma mark - drawRect

-(NSArray *)chartData
{
    if (_chartData) {
        self.chartData = [NSMutableArray array];
    }
    return _chartData;
}

@end
