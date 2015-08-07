//
//  EWBarChartView.m
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWBarChartView.h"

//default parameter
NSInteger static const   kEWBarChartViewBarNumber         = 1;
CGFloat   static const   kEWChartViewDefalutCachedHeight  = -1.0f;
CGFloat   static const   kEWChartViewXYAxisPadding        = 3.0f;
BOOL      static const   kEWChartViewShowBarValue         = YES;

//一个表的柱状图之间的距离 *0.5
CGFloat   static const   kEWBarChartViewBarMargin          = 3.0f;
//多个柱状图的柱之间的距离
CGFloat   static const   kEWBarChartViewMarginBetweenBarChart  = 1.0f;

CGFloat   static const   kEWBarChartViewValueMargin        = 3.0f;

//macro
#define kEWBarChartViewBarColor nil

@interface EWChartView (Private)

- (BOOL)hasMaximumValue;
- (BOOL)hasMinimumValue;

-(void)drawYAxisLabelsWithMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue context:(CGContextRef)ctx showGrid:(BOOL)showGrid;

@end

@interface EWBarChartInfo : NSObject

@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat value;

@end

@interface EWBarChartView()

@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, assign) CGFloat cachedMinHeight;
@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) NSInteger dataNumber;

@end

@implementation EWBarChartView

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
    self.barColor = kEWBarChartViewBarColor;
}

-(NSInteger)numberOfBarInLineChart
{
    if ([self.dataSource respondsToSelector:@selector(numberOfBarInBarChartView:)])
    {
        return [self.dataSource numberOfBarInBarChartView:self];
    }else
    {
        return kEWBarChartViewBarNumber;
    }
}

-(UIColor *)colorForBarAtBarIndex:(NSUInteger)barIndex;
{
    if ([self.delegate respondsToSelector:@selector(barChartView:colorForBarAtBarIndex:)])
    {
        return [self.delegate barChartView:self colorForBarAtBarIndex:barIndex];
    }else
    {
        return self.barColor;
    }
}

-(UIColor *)colorForBarAtHorizontalIndex:(NSUInteger)horizontalIndex;
{
    if ([self.delegate respondsToSelector:@selector(barChartView:colorForBarAtHorizontalIndex:)])
    {
        return [self.delegate barChartView:self colorForBarAtHorizontalIndex:horizontalIndex];
    }else
    {
        return self.barColor;
    }
}

-(BOOL)showBarValuesAtHorizontalIndex:(NSUInteger)horizontalIndex atBarIndex:(NSUInteger)barIndex
{
    if ([self.delegate respondsToSelector:@selector(barChartView:showBarValuesAtHorizontalIndex:atBarIndex:)])
    {
        return [self.delegate barChartView:self showBarValuesAtHorizontalIndex:horizontalIndex atBarIndex:barIndex];
    }else
    {
        return kEWChartViewShowBarValue;
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
    NSInteger numberOfBar = [self numberOfBarInLineChart];
    for (NSInteger barIndex = 0; barIndex < numberOfBar; barIndex++)
    {
        NSAssert([self.dataSource respondsToSelector:@selector(barChartView:numberOfBarAtBarIndex:)], @"EWBarChartView // dataSource must implement - (NSUInteger)barChartView:(EWBarChartView *)barChartView numberOfBarAtBarIndex:(NSUInteger)barIndex;");
        NSUInteger barDataCount = [self.dataSource barChartView:self numberOfBarAtBarIndex:barIndex];
        if (barDataCount > dataCount)
        {
            dataCount = barDataCount;
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
    CGFloat minHeight = [self minimumValue];
    CGFloat maxHeight = [self maximumValue];
    
    if ((maxHeight - minHeight) <= 0)
    {
        return 0;
    }
    
    return ((valueHeight - minHeight) / (maxHeight - minHeight)) * (self.bounds.size.height - kEWChartViewHeaderPadding - kEWChartViewXAxisHeight);
}

/**
 *  每个柱的宽度
 */
-(CGFloat)barWidthWithBarCount:(NSInteger)barChartCount stepLength:(CGFloat)xstepLength
{
    return (xstepLength - 2*kEWBarChartViewBarMargin - (barChartCount - 1)*kEWBarChartViewMarginBetweenBarChart)/barChartCount;
}

#pragma mark - Public Method

-(void)reloadData
{
    // Reset
    self.cachedMinHeight = kEWChartViewDefalutCachedHeight;
    self.cachedMaxHeight = kEWChartViewDefalutCachedHeight;
    
    self.dataNumber = [self dataCount];
    
    CGRect mainViewRect = CGRectMake(kEWChartViewYAxisWidth, kEWChartViewHeaderPadding, self.bounds.size.width - kEWChartViewYAxisWidth -0.5, self.bounds.size.height - kEWChartViewXAxisHeight - kEWChartViewHeaderPadding - kEWChartViewXYAxisWidth);
    
    CGFloat yOffset = 0;
    
    NSMutableArray *mutableChartData = [NSMutableArray array];
    NSUInteger numberOfBar = [self numberOfBarInLineChart];
    
    for (NSUInteger barIndex=0; barIndex < numberOfBar; barIndex++)
    {
        NSUInteger dataCount = [self.dataSource barChartView:self numberOfBarAtBarIndex:barIndex];
        NSMutableArray *barInfoData = [NSMutableArray array];
        for (NSUInteger horizontalIndex=0; horizontalIndex < dataCount; horizontalIndex++)
        {
            NSAssert([self.dataSource respondsToSelector:@selector(barChartView:verticalValueForHorizontalIndex:atBarIndex:)], @"EWLineChartView // dataSource must implement - (CGFloat)barChartView:(EWBarChartView *)barChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atBarIndex:(NSUInteger)barIndex;");
            
            EWBarChartInfo *barInfo = [[EWBarChartInfo alloc] init];
            
            CGFloat valueHeight =  [self.dataSource barChartView:self verticalValueForHorizontalIndex:horizontalIndex atBarIndex:barIndex];
            CGFloat standardizedHeight = [self standardizedHeightForvalueHeight:valueHeight];
            yOffset = mainViewRect.size.height +  kEWChartViewHeaderPadding - standardizedHeight;
            
            barInfo.y = yOffset;
            barInfo.height = standardizedHeight;
            barInfo.value = valueHeight;
            
            [barInfoData addObject:barInfo];
        }
        [mutableChartData addObject:barInfoData];
    }
    self.chartData = [NSArray arrayWithArray:mutableChartData];
    
    [self setNeedsDisplay];

}

#pragma mark - Draw 

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.chartData.count <= 0) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawBarChart:ctx];
    
    [self drawXYLabelText:ctx];
}

-(void)drawBarChart:(CGContextRef)ctx
{
    int index = 0;
    
    CGFloat xstepLength = (self.bounds.size.width - kEWChartViewYAxisWidth - 0.5) / self.dataNumber;
    
    CGFloat barWidth = [self barWidthWithBarCount:self.chartData.count stepLength:xstepLength];
    
    for (NSArray *barData in self.chartData)
    {
        if (barData.count == 0)
        {
            continue;
        }
        __block CGFloat barX = kEWChartViewYAxisWidth + kEWBarChartViewBarMargin + index * (barWidth + kEWBarChartViewMarginBetweenBarChart);
        
        
        [barData enumerateObjectsUsingBlock:^(EWBarChartInfo *barInfo, NSUInteger idx, BOOL *stop) {
            CGContextSaveGState(ctx);
            
            CGContextAddRect(ctx, CGRectMake(barX, barInfo.y, barWidth, barInfo.height));
            
            [[self colorForBarAtBarIndex:index] set];
            [[self colorForBarAtHorizontalIndex:idx] set];
            
            CGContextFillPath(ctx);
            
            //画数值
            if ([self showBarValuesAtHorizontalIndex:idx atBarIndex:index]) {
                CGPoint point = CGPointMake(barX , barInfo.y);
                [self drawValueAtPoint:point value:barInfo.value];
            }
            
            barX += xstepLength;
            CGContextRestoreGState(ctx);
        }];

        
        index++;
    }
}

/**
 *  画坐标值
 *
 *  @param ctx 上下文
 */
-(void)drawXYLabelText:(CGContextRef)ctx
{
    //draw y axis labels
    [self drawYAxisLabelsWithMaxValue:[self maximumValue] minValue:[self minimumValue] context:ctx showGrid:NO];
    
    //draw x axis labels
    CGFloat xstepLength = (self.bounds.size.width - kEWChartViewYAxisWidth - 0.5)/ self.dataNumber;

    for (int index = 0; index < self.dataNumber; index++) {
        NSString *title = nil;
        if([self.dataSource respondsToSelector:@selector(barChartView:horizontalTitlseForHorizontalIndex:)])
        {
            title = [self.dataSource barChartView:self horizontalTitlseForHorizontalIndex:index];
        }
        CGContextSaveGState(ctx);
        {
            CGSize valueSize = [title sizeWithAttributes:[super xLabelAttributes]];
            CGFloat pointY = (2 * self.bounds.size.height - kEWChartViewXYAxisPadding - kEWChartViewXAxisHeight) * 0.5 - valueSize.height * 0.5;
            CGFloat pointX = kEWChartViewYAxisWidth + xstepLength * 0.5 + xstepLength * index - valueSize.width * 0.5;
            
            CGPoint point = (CGPoint){pointX,pointY};
            [title drawAtPoint:point withAttributes:[super xLabelAttributes]];
        }
        CGContextRestoreGState(ctx);
    }
}

/**
 *  画具体数据值
 *
 *  @param point 需要处理的坐标点
 */
-(void)drawValueAtPoint:(CGPoint)point value:(CGFloat)value
{
    NSString *barValue = [NSString stringWithFormat:@"%.1f",value];
    
    CGSize valueSize = [barValue sizeWithAttributes:[super valueAttributes]];
    
    CGPoint valuePoint = CGPointMake(point.x , point.y - valueSize.height  - kEWBarChartViewValueMargin);
    
    [barValue drawAtPoint:valuePoint withAttributes:[super valueAttributes]];
}

#pragma mark - Getter And Setter

- (CGFloat)minimumValue
{
    if ([self hasMinimumValue])
    {
        return fminf(self.cachedMinHeight, [super minimumValue]);
    }
    return self.cachedMinHeight;
}

- (CGFloat)maximumValue
{
    if ([self hasMaximumValue])
    {
        return fmaxf(self.cachedMaxHeight, [super maximumValue]);
    }
    return self.cachedMaxHeight;
}

-(CGFloat)cachedMinHeight
{
    if (_cachedMinHeight == kEWChartViewDefalutCachedHeight) {
        CGFloat minHeight = FLT_MAX;
        NSUInteger numberOfBar = [self numberOfBarInLineChart];
        for (NSUInteger barIndex = 0; barIndex < numberOfBar; barIndex++)
        {
            NSUInteger dataCount = [self.dataSource barChartView:self numberOfBarAtBarIndex:barIndex];
            for (NSUInteger horizontalIndex = 0; horizontalIndex < dataCount; horizontalIndex++)
            {
                CGFloat height = [self.dataSource barChartView:self verticalValueForHorizontalIndex:horizontalIndex atBarIndex:barIndex];
                if (height < minHeight)
                {
                    minHeight = height;
                }
            }
        }
        _cachedMinHeight = minHeight;
    }
    return _cachedMinHeight;
}

-(CGFloat)cachedMaxHeight
{
    if (_cachedMaxHeight == kEWChartViewDefalutCachedHeight) {
        CGFloat maxHeight = 0;
        NSUInteger numberOfBar = [self numberOfBarInLineChart];
        for (NSUInteger barIndex = 0; barIndex < numberOfBar; barIndex++)
        {
            NSUInteger dataCount = [self.dataSource barChartView:self numberOfBarAtBarIndex:barIndex];
            for (NSUInteger horizontalIndex = 0; horizontalIndex < dataCount; horizontalIndex++)
            {
                CGFloat height = [self.dataSource barChartView:self verticalValueForHorizontalIndex:horizontalIndex atBarIndex:barIndex];
                if (height > maxHeight)
                {
                    maxHeight = height;
                }
            }
        }
        _cachedMaxHeight = maxHeight;
    }
    return _cachedMaxHeight;
}


@end

@implementation EWBarChartInfo

@end
