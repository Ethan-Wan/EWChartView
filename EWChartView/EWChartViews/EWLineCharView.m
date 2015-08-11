//
//  EWLineCharView.m
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWLineCharView.h"

//default parameter
BOOL      static const kEWLineChartViewShowGrid        = NO;
BOOL      static const kEWLineChartViewShowLineValues  = NO;
BOOL      static const kEWLineChartViewShowLineCircle  = YES;
BOOL      static const kEWLineChartViewisHollowCircle  = NO;
CGFloat   static const kEWLineChartViewLineWidth       = 2.0f;
NSInteger static const kEWLineChartViewLineNumber      = 1;
CGFloat   static const kEWChartViewXYAxisPadding       = 3.0f;
CGFloat   static const kEWChartViewCachedHeight        = -1.0f;
CGFloat   static const kEWChartViewCricleRadius        = 4.0f;


//macro
#define EWPieChartViewLineDefalutColor [UIColor blackColor];

@interface EWLineChartInfo : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) BOOL hidden;

@end

@interface EWChartView (Private)

- (BOOL)hasMaximumValue;
- (BOOL)hasMinimumValue;

-(void)drawYAxisLabelsWithMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue context:(CGContextRef)ctx showGrid:(BOOL)showGrid;

@end


@interface EWLineCharView()

@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, assign) CGFloat cachedMinHeight;
@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) NSInteger dataNumber;

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
    self.showGrid = kEWLineChartViewShowGrid;
    self.showLineValues = kEWLineChartViewShowLineValues;
    self.isHollowCircle = kEWLineChartViewisHollowCircle;
}


-(NSInteger)numberOfLineInLineChart
{
    if ([self.dataSource respondsToSelector:@selector(numberOfLinesInLineChartView:)])
    {
        return [self.dataSource numberOfLinesInLineChartView:self];
    }else
    {
        return kEWLineChartViewLineNumber;
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
        return kEWLineChartViewLineWidth;
    }
}

-(CGFloat)isShowCircleForLineAtLineIndex:(NSInteger)lineIndex
{
    if ([self.dataSource respondsToSelector:@selector(lineChartView:showsCircleForLineAtLineIndex:)])
    {
        return [self.dataSource lineChartView:self showsCircleForLineAtLineIndex:lineIndex];
    }else
    {
        return kEWLineChartViewShowLineCircle;
    }
}

-(CGFloat)isHollowCircleForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if ([self.delegate respondsToSelector:@selector(lineChartView:isHollowCircleForHorizontalIndex:atLineIndex:)])
    {
        return [self.delegate lineChartView:self isHollowCircleForHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
    }else
    {
        return self.isHollowCircle;
    }
}

- (CGFloat)circleRadiustAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if ([self.delegate respondsToSelector:@selector(lineChartView:circleRadiustAtHorizontalIndex:atLineIndex:)])
    {
        return [self.delegate lineChartView:self circleRadiustAtHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
    }else
    {
        return kEWChartViewCricleRadius;
    }
}

- (BOOL)showLineValuesAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if ([self.delegate respondsToSelector:@selector(lineChartView:showLineValuesAtHorizontalIndex:atLineIndex:)])
    {
        return [self.delegate lineChartView:self showLineValuesAtHorizontalIndex:horizontalIndex atLineIndex:lineIndex];
    }else
    {
        return self.showLineValues;
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
    // Reset
    self.cachedMinHeight = kEWChartViewCachedHeight;
    self.cachedMaxHeight = kEWChartViewCachedHeight;
    
    //
    self.dataNumber = [self dataCount];
    
    CGRect mainViewRect = CGRectMake(kEWChartViewYAxisWidth, kEWChartViewHeaderPadding, self.bounds.size.width - kEWChartViewYAxisWidth -0.5, self.bounds.size.height - kEWChartViewXAxisHeight - kEWChartViewHeaderPadding);
    
    CGFloat pointSpace = mainViewRect.size.width / self.dataNumber; // Space in between points
    
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
                
            EWLineChartInfo *lineinfo = [[EWLineChartInfo alloc] init];
                
            CGFloat standardizedHeight = [self standardizedHeightForvalueHeight:valueHeight];
            
            yOffset = mainViewRect.size.height +  kEWChartViewHeaderPadding - standardizedHeight;

            lineinfo.position = CGPointMake(xOffset, yOffset);
            lineinfo.value = valueHeight;
            
            [chartPointData addObject:lineinfo];
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
    
    [self drawLineChart:ctx];
    
    [self drawXYLabelText:ctx];
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
            CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth, kEWChartViewHeaderPadding + kEWChartViewXYAxisWidth + verticalLength * index);
            CGContextAddLineToPoint(ctx, self.bounds.size.width, kEWChartViewHeaderPadding + kEWChartViewXYAxisWidth + verticalLength * index);
            [[super coordinateColor] set];
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    
    CGFloat horizontalSpace = (self.bounds.size.width - kEWChartViewYAxisWidth - 0.5) / self.dataNumber;
    
    for (int index = 1; index < self.dataNumber + 1 ; index++) {
        CGContextSaveGState(ctx);
        {
            CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth + index * horizontalSpace, kEWChartViewHeaderPadding);
            CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth + index * horizontalSpace, self.bounds.size.height - kEWChartViewXAxisHeight);
            [[super coordinateColor] set];
            //            可设置虚线
            //            CGContextSetLineDash(ctx, CGFloat phase, const CGFloat *lengths, size_t count)
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    
}

/**
 *  画折线图
 *
 *  @param ctx 上下文
 */
-(void)drawLineChart:(CGContextRef)ctx
{
    int index = 0;
    
    for (NSArray *lineData in self.chartData)
    {
        CGContextSaveGState(ctx);
        if (lineData.count == 0)
        {
            continue;
        }
        
        UIColor *color = [self colorForLineAtLineIndex:index];
        CGFloat lineWidth = [self widthForLineAtLineIndex:index];
        BOOL isShowCircle = [self isShowCircleForLineAtLineIndex:index];
        __block CGFloat radius = 0;
        
        [color set];
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        
        //画线
        [lineData enumerateObjectsUsingBlock:^(EWLineChartInfo *point, NSUInteger idx, BOOL *stop) {
            if (idx == 0)
            {
                CGContextMoveToPoint(ctx, point.position.x, point.position.y);
            }else
            {
                CGContextAddLineToPoint(ctx, point.position.x, point.position.y);
            }
            //画圆
            if (isShowCircle) {
                BOOL isHollow = [self isHollowCircleForHorizontalIndex:idx atLineIndex:index];
                radius = [self circleRadiustAtHorizontalIndex:idx atLineIndex:index];
                
                [self drawCircleAtPoint:point.position
                               isHollow:isHollow
                                 radius:radius
                                context:ctx
                              lineWidth:lineWidth
                                  color:color];
            }
            
            //画数值
            if ([self showLineValuesAtHorizontalIndex:idx atLineIndex:index]) {
                [self drawValueAtPoint:point.position
                                 value:point.value
                                radius:radius
                               context:ctx];
            }
        }];
        
        CGContextStrokePath(ctx);
        
        index++;
        CGContextRestoreGState(ctx);
    }
}

/**
 *  画xy轴上的坐标值
 *
 *  @param ctx 上下文
 */
-(void)drawXYLabelText:(CGContextRef)ctx
{
    //draw y axis labels
    [self drawYAxisLabelsWithMaxValue:[self maximumValue] minValue:[self minimumValue] context:ctx showGrid:self.showGrid];
    
    //draw x axis labels
    CGFloat xstepLength = (self.bounds.size.width - kEWChartViewYAxisWidth - 0.5)/ self.dataNumber;
    
    for (int index = 0; index < self.dataNumber; index++) {
        NSString *title = nil;
        if([self.dataSource respondsToSelector:@selector(lineChartView:horizontalTitlseForHorizontalIndex:)])
        {
            title = [self.dataSource lineChartView:self horizontalTitlseForHorizontalIndex:index];
        }
        CGContextSaveGState(ctx);
        {
            if (!self.showGrid) {
                CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth + xstepLength * 0.5 +xstepLength * index , self.bounds.size.height - kEWChartViewXAxisHeight);
                CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth + xstepLength * 0.5 +xstepLength * index, self.bounds.size.height - kEWChartViewXAxisHeight + kEWChartViewXYAxisPadding);
                [[super coordinateColor] set];
                CGContextStrokePath(ctx);
            }
            
            CGSize  valueSize = [title sizeWithAttributes:[super xLabelAttributes]];
            CGFloat pointY = (2 * self.bounds.size.height - kEWChartViewXYAxisPadding - kEWChartViewXAxisHeight) * 0.5 - valueSize.height * 0.5;
            CGFloat pointX = kEWChartViewYAxisWidth + xstepLength * 0.5 + xstepLength * index - valueSize.width * 0.5;
            
            CGPoint point = (CGPoint){pointX,pointY};
            [title drawAtPoint:point withAttributes:[super xLabelAttributes]];
        }
        CGContextRestoreGState(ctx);

    }
   
}

/**
 *  画折线上的圆
 *
 *  @param point    坐标
 *  @param isHollow 是否是空心圆
 *  @param ctx      上下文
 */
-(void)drawCircleAtPoint:(CGPoint)center isHollow:(BOOL)isHollow radius:(CGFloat)radius context:(CGContextRef)ctx lineWidth:(CGFloat)lineWidth color:(UIColor *)color
{
    UIView *cricle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    cricle.center = center;
    cricle.layer.masksToBounds = YES;
    cricle.layer.cornerRadius = radius;
    cricle.layer.borderWidth = lineWidth;
    cricle.layer.borderColor = color.CGColor;
    
    if (isHollow) {
        cricle.backgroundColor = self.backgroundColor;
    }else{
        cricle.backgroundColor = color;
    }
    
    [self addSubview:cricle];

//    CGContextAddArc(ctx, center.x, center.y, radius, 0, 2 * M_PI, NO);
////    CGContextAddEllipseInRect(ctx, CGRectMake(center.x - radius, center.y - radius, radius*2, radius*2));
//    if (isHollow) {
//        CGContextStrokePath(ctx);
//    }else
//    {
//        CGContextFillPath(ctx);
//    }
}

/**
 *  在折线上画数值
 *
 *  @param value 要画的数值
 *  @param ctx   上下文
 */
-(void)drawValueAtPoint:(CGPoint)point value:(CGFloat)value radius:(CGFloat)radius context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    NSString *lineValue = [NSString stringWithFormat:@"%.1f",value];
    
    CGSize valueSize = [lineValue sizeWithAttributes:[super valueAttributes]];
    
    CGPoint valuePoint = CGPointMake(point.x - valueSize.width * 0.5, point.y - valueSize.height - radius - 2);
    
    [lineValue drawAtPoint:valuePoint withAttributes:[super valueAttributes]];
    
    CGContextRestoreGState(ctx);
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
    if (_cachedMinHeight == kEWChartViewCachedHeight) {
        CGFloat minHeight = FLT_MAX;
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
    if (_cachedMaxHeight == kEWChartViewCachedHeight) {
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
@implementation EWLineChartInfo

#pragma mark - Alloc/Init

- (id)init
{
    self = [super init];
    if (self)
    {
        _position = CGPointZero;
        _value = 0;
    }
    return self;
}

@end
