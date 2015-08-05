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
CGFloat static const kEWPieChartViewLineWidth = 3.0f;
NSInteger static const kEWPieChartViewLineNumber = 1;

//macro
#define EWPieChartViewLineDefalutColor [UIColor blackColor];

@interface EWLineChartPoint : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) BOOL hidden;

@end

@interface EWChartView (Private)

- (BOOL)hasMaximumValue;
- (BOOL)hasMinimumValue;

@end


@interface EWLineCharView()

@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, assign) CGFloat cachedMinHeight;
@property (nonatomic, assign) CGFloat cachedMaxHeight;

@end

@implementation EWLineCharView
@dynamic dataSource;
@dynamic delegate;

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
    self.backgroundColor = [UIColor whiteColor];
    self.showGrid = kEWPieChartViewShowGrid;
}


-(NSInteger)numberOfLineInLineChart
{
    if ([self.dataSource respondsToSelector:@selector(numberOfLinesInLineChartView:)])
    {
        return [self.dataSource numberOfLinesInLineChartView:self];
    }else
    {
        return kEWPieChartViewLineNumber;
    }
}

-(UIColor *)colorForLineAtLineIndex:(NSInteger)lineIndex
{
    if ([self.delegate respondsToSelector:@selector(lineChartView:colorForLineAtLineIndex:)])
    {
        return [self.delegate lineChartView:self colorForLineAtLineIndex:lineIndex];
    }else
    {
        return EWPieChartViewLineDefalutColor;
    }
}

-(CGFloat)widthForLineAtLineIndex:(NSInteger)lineIndex
{
    if ([self.delegate respondsToSelector:@selector(lineChartView:widthForLineAtLineIndex:)])
    {
        return [self.delegate lineChartView:self widthForLineAtLineIndex:lineIndex];
    }else
    {
        return kEWPieChartViewLineWidth;
    }
}

/**
 *  画网格
 *
 *  @param ctx 上下文
 */
-(void)drawGrid:(CGContextRef)ctx
{
     CGFloat verticalLength = (self.bounds.size.height - kEWChartViewHeaderPadding - kEWChartViewXAxisHeight)/[super sectionCount];
    for (int index = 0; index < self.sectionCount ; index++) {
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
    
    for (int index = 1; index < dataCount + 1 ; index++) {
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
    NSInteger numberOfLines = [self numberOfLineInLineChart];
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
    CGFloat minHeight = [self minimumValue];
    CGFloat maxHeight = [self maximumValue];
    
    if ((maxHeight - minHeight) <= 0)
    {
        return 0;
    }
    
    return ((valueHeight - minHeight) / (maxHeight - minHeight)) * (self.bounds.size.height - kEWChartViewHeaderPadding - kEWChartViewXAxisHeight);
}

#pragma mark - Public Method

-(void)reloadData
{
    CGRect mainViewRect = CGRectMake(kEWChartViewYAxisWidth, kEWChartViewHeaderPadding, self.bounds.size.width - kEWChartViewYAxisWidth -0.5, self.bounds.size.height - kEWChartViewXAxisHeight - kEWChartViewHeaderPadding);
        
    CGFloat pointSpace = mainViewRect.size.width / [self dataCount]; // Space in between points
    
    CGFloat xOffset = kEWChartViewYAxisWidth + pointSpace * 0.5;
    CGFloat yOffset = 0;
    
    NSMutableArray *mutableChartData = [NSMutableArray array];
    NSUInteger numberOfLines = [self numberOfLineInLineChart];
    
    for (NSUInteger lineIndex=0; lineIndex<numberOfLines; lineIndex++)
    {
        NSUInteger dataCount = [self.dataSource lineChartView:self numberOfLinesAtLineIndex:lineIndex];
        NSMutableArray *chartPointData = [NSMutableArray array];
        for (NSUInteger horizontalIndex=0; horizontalIndex<dataCount; horizontalIndex++)
        {
            NSAssert([self.dataSource respondsToSelector:@selector(lineChartView:verticalValueForHorizontalIndex:atLineIndex:)], @"EWLineChartView // dataSource must implement - (CGFloat)lineChartView:(EWLineCharView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex");
            CGFloat valueHeight =  [self.dataSource lineChartView:self verticalValueForHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
                
            EWLineChartPoint *chartPoint = [[EWLineChartPoint alloc] init];
                
            CGFloat standardizedHeight = [self standardizedHeightForvalueHeight:valueHeight];
            
            yOffset = mainViewRect.size.height +  kEWChartViewHeaderPadding - standardizedHeight;

            chartPoint.position = CGPointMake(xOffset, yOffset);

            [chartPointData addObject:chartPoint];
            xOffset += pointSpace;
        }
        [mutableChartData addObject:chartPointData];
        xOffset = kEWChartViewYAxisWidth + pointSpace * 0.5;
    }
    self.chartData = [NSArray arrayWithArray:mutableChartData];
    [self setNeedsDisplay];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.chartData.count <= 0) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (self.showGrid) {
        CGContextSaveGState(ctx);
        [self drawGrid:ctx];
        CGContextRestoreGState(ctx);
    }
    
    int index = 0;

    for (NSArray *lineData in self.chartData)
    {
        CGContextSaveGState(ctx);
        if (lineData.count == 0)
        {
            continue;
        }
        
       [lineData enumerateObjectsUsingBlock:^(EWLineChartPoint *point, NSUInteger idx, BOOL *stop) {
           if (idx == 0)
           {
                CGContextMoveToPoint(ctx, point.position.x, point.position.y);
           }else
           {
               CGContextAddLineToPoint(ctx, point.position.x, point.position.y);
           }
           
           NSLog(@"%f--%f",point.position.x,point.position.y);
       }];
        CGContextSetLineWidth(ctx, [self widthForLineAtLineIndex:index]);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        [[self colorForLineAtLineIndex:index] set];
        
        CGContextStrokePath(ctx);
        
        index++;
        CGContextRestoreGState(ctx);
    }
    
    
    
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
    if (!_cachedMinHeight) {
        CGFloat minHeight = 0;
        NSUInteger numberOfLines = [self numberOfLineInLineChart];
        for (NSUInteger lineIndex = 0; lineIndex<numberOfLines; lineIndex++)
        {
            NSUInteger dataCount = [self.dataSource lineChartView:self numberOfLinesAtLineIndex:lineIndex];
            for (NSUInteger horizontalIndex = 0; horizontalIndex<dataCount; horizontalIndex++)
            {
                CGFloat height = [self.dataSource lineChartView:self verticalValueForHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
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
    if (!_cachedMaxHeight) {
        CGFloat maxHeight = 0;
        NSUInteger numberOfLines = [self numberOfLineInLineChart];
        for (NSUInteger lineIndex = 0; lineIndex<numberOfLines; lineIndex++)
        {
            NSUInteger dataCount = [self.dataSource lineChartView:self numberOfLinesAtLineIndex:lineIndex];
            for (NSUInteger horizontalIndex = 0; horizontalIndex<dataCount; horizontalIndex++)
            {
                 CGFloat height = [self.dataSource lineChartView:self verticalValueForHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
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
@implementation EWLineChartPoint

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self)
    {
        _position = CGPointZero;
    }
    return self;
}

#pragma mark - Compare

- (NSComparisonResult)compare:(EWLineChartPoint *)otherObject
{
    return self.position.x > otherObject.position.x;
}

@end
