//
//  EWPieChartView.m
//  JBChartViewDemo
//
//  Created by wansy on 15/8/4.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWPieChartView.h"

//default parameter
CGFloat static const kEWPieChartViewMaxRadius = 100.0f;
CGFloat static const kEWPieChartViewMinRadius = 0.0f;
CGFloat static const kEWPieChartViewStartAngle = 0.0f;
CGFloat static const kEWPieChartViewEndAngle = 360.0f;
//CGFloat static const kEWPieChartViewAnimationDuration = 0.6f;

EWPieChartShowTitleType static const kEWPieChartViewShowTitleType = EWPieChartShowTitleDefault;
BOOL static const kEWPieChartViewShowItemPercent = NO;

static inline float radians(float degrees) {
    return degrees * M_PI / 180.0;
}

//in [0..1], out [0..1]
static inline float easeInOut(float x){
    //1/(1+e^((0.5-x)*12))
    return 1/(1+powf(M_E, (0.5-x)*12));
}

//颜色
#define EWColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//随即色
#define EWRandomColor EWColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface EWPieChartView()

@property (nonatomic, strong) NSArray *chartData;

@property (nonatomic, strong) NSMutableArray *values;

@property (nonatomic, assign) CGPoint touchPoint;

//点击扇形的时候的偏移量
@property (nonatomic, assign) CGFloat centerOffset;
@end

@implementation EWPieChartView

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
    self.maxRadius = kEWPieChartViewMaxRadius;
    self.minRadius = kEWPieChartViewMinRadius;
    self.startAngle = kEWPieChartViewStartAngle;
    self.endAngle = kEWPieChartViewEndAngle;
    
    self.titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    self.percentAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    
//    self.animationDuration = kEWPieChartViewAnimationDuration;
    self.showTitleType = kEWPieChartViewShowTitleType;
    self.showItemPercent = kEWPieChartViewShowItemPercent;
}

-(EWPieChartShowTitleType)showItemTitleTypeAtItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(pieChartView:showItemTitleTypeAtItemIndex:)])
    {
        return [self.delegate pieChartView:self showItemTitleTypeAtItemIndex:index]?[self.delegate pieChartView:self showItemTitleTypeAtItemIndex:index]:EWPieChartShowTitleDefault;
    }else
    {
        return self.showTitleType;
    }
}

-(BOOL)showItemPercentAtItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(pieChartView:showItemPercentAtItemIndex:)])
    {
        return [self.delegate pieChartView:self showItemPercentAtItemIndex:index]?[self.delegate pieChartView:self showItemPercentAtItemIndex:index]:NO;
    }else
    {
        return self.showItemPercent;
    }
}


-(void)drawItemTitles:(CGContextRef)ctx sumValues:(CGFloat)sum
{
    float angleStart = radians(self.startAngle);
    float angleInterval = radians(self.endAngle - self.startAngle);
    
    for (int index = 0; index < self.chartData.count; index++) {
        EWPieChartViewCell *cell = self.chartData[index];
        float angleEnd = angleStart + angleInterval * cell.value / sum;
        float angle = (angleStart + angleEnd) / 2.0;
        
        EWPieChartShowTitleType showTitleType = [self showItemTitleTypeAtItemIndex:index];
        BOOL showPercent = [self showItemPercentAtItemIndex:index];

        if(showTitleType == EWPieChartShowTitleDefault && !showPercent){
            angleStart = angleEnd;
            continue;
        }else if (showTitleType != EWPieChartShowTitleDefault && showPercent)
        {
            [self drawTitle:cell angle:angle context:ctx];
            [self drawPercent:cell angle:angle context:ctx sum:sum];

        }else if(showTitleType != EWPieChartShowTitleDefault )
        {
           [self drawTitle:cell angle:angle context:ctx];
        }else if(showPercent)
        {
           [self drawPercent:cell angle:angle context:ctx sum:sum];
        }
        
        angleStart = angleEnd;
    }
}

-(void)drawTitle:(EWPieChartViewCell *)cell angle:(CGFloat)angle context:(CGContextRef)ctx
{
    UIColor *color = cell.color?: [UIColor blackColor];
    
    NSString *title = cell.title?cell.title:[NSString stringWithFormat:@"%.2f", cell.value];
    float radius = self.maxRadius;
    [self drawTitle:title angle:M_PI*2 - angle radius:radius context:ctx color:color];
}

-(void)drawPercent:(EWPieChartViewCell *)cell angle:(CGFloat)angle context:(CGContextRef)ctx sum:(CGFloat)sum
{
    [[UIColor whiteColor] set];
    
    NSString *percent = [NSString stringWithFormat:@"%.1f%%",(cell.value / sum)*100];
    float radius = (self.maxRadius + self.minRadius) * 0.5;
    [self drawPercent:percent angle:M_PI*2 - angle radius:radius context:ctx];
}


/**
 *  画标题
 *
 *  @param text   标题内容
 *  @param angle  当前扇形的中间角度
 *  @param radius 半径
 *  @param ctx    上下文
 *  @param font   标题样式
 */
- (void)drawTitle:(NSString*)text angle:(float)angle radius:(float)radius context:(CGContextRef)ctx color:(UIColor *)color
{
    NSDictionary *dic = @{NSFontAttributeName:self.titleAttributes[NSFontAttributeName],
                          NSForegroundColorAttributeName:color};
    self.titleAttributes = dic;
    
    CGSize textSize = [text sizeWithAttributes:self.titleAttributes];
    CGPoint anchorPoint;
    
    //closewise
    if(angle >= -M_PI_4 && angle < M_PI_4){
        anchorPoint = CGPointMake(0, easeInOut((M_PI_4-angle) / M_PI_2));
    } else if(angle >= M_PI_4 && angle < M_PI_2+M_PI_4){
        anchorPoint = CGPointMake(easeInOut((angle-M_PI_4) / M_PI_2), 0);
    } else if(angle >= M_PI_2+M_PI_4 && angle < M_PI+M_PI_4){
        anchorPoint = CGPointMake(1, easeInOut((angle - (M_PI_2+M_PI_4)) / M_PI_2));
    } else {
        anchorPoint = CGPointMake(easeInOut(((2*M_PI - M_PI_4) - angle) / M_PI_2), 1);
    }
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGPoint pos = CGPointMake(center.x + radius*cosf(angle), center.y + radius*sinf(angle));
    
    CGRect frame = CGRectMake(pos.x - anchorPoint.x * textSize.width,
                              pos.y - anchorPoint.y * textSize.height,
                              textSize.width,
                              textSize.height);
    UIGraphicsPushContext(ctx);
    [text drawInRect:frame withAttributes:self.titleAttributes];
    UIGraphicsPopContext();
}

/**
 *  画百分比
 *
 *  @param text   标题内容
 *  @param angle  当前扇形的中间角度
 *  @param radius 半径
 *  @param ctx    上下文
 *  @param font   标题样式
 */
- (void)drawPercent:(NSString*)text angle:(float)angle radius:(float)radius context:(CGContextRef)ctx
{
    CGSize textSize = [text sizeWithAttributes:self.percentAttributes];
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGPoint textCenter = CGPointMake(center.x + radius*cosf(angle), center.y + radius*sinf(angle));
    CGPoint drawPoint = CGPointMake(textCenter.x - textSize.width * 0.5 ,textCenter.y - textSize.height * 0.5);
    
    UIGraphicsPushContext(ctx);
    [text drawAtPoint:drawPoint withAttributes:self.percentAttributes];
    UIGraphicsPopContext();

    
    
}
#pragma mark - Public Method

-(void)reloadData
{
    [self setNeedsDisplay];
    
    NSMutableArray *mutableChartData = [NSMutableArray array];
        
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemInPieChartView)], @"EWPieChartView // dataSource must implement - (NSUInteger)numberOfSection");
    NSUInteger numberOfItem = [self.dataSource numberOfItemInPieChartView];
        
    for (NSUInteger itemIndex = 0; itemIndex < numberOfItem; itemIndex++)
    {
        NSAssert([self.dataSource respondsToSelector:@selector(pieChartView:pieChartViewCellForItemIndex:)], @"EWPieChartView // delegate must implement - - (CGFloat)pieChartView(EWPieChartView *)pieChartViewitemValueForItemIndex:(NSUInteger)itemIndex;");
        EWPieChartViewCell *cell =  [self.dataSource pieChartView:self pieChartViewCellForItemIndex:itemIndex];
            
        [mutableChartData addObject:cell];
        [self.values addObject:@(cell.value)];
    }
    self.chartData = [NSArray arrayWithArray:mutableChartData];
    
    [self setNeedsDisplay];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(self.chartData.count == 0 || self.minRadius >= self.maxRadius)
        return;

    float sum = [[self.values valueForKeyPath:@"@sum.floatValue"] floatValue];
    if(sum <= 0)
        return;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    //翻转
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    __block float angleStart = radians(self.startAngle);
    float angleInterval = radians(self.endAngle - self.startAngle);
    
    [self.chartData enumerateObjectsUsingBlock:^(EWPieChartViewCell *cell, NSUInteger idx, BOOL *stop) {
        float angleEnd = angleStart + angleInterval * cell.value / sum;
//        float centrAngle = (angleEnd + angleStart) * 0.5;
        
        UIColor *itemColor = cell.color?cell.color:EWRandomColor;
        cell.color = itemColor;
        
        CGPoint minRadiusStart = CGPointMake(center.x + self.minRadius*cosf(angleStart), center.y + self.minRadius*sinf(angleStart));
        CGPoint maxRadiusEnd = CGPointMake(center.x + self.maxRadius*cosf(angleEnd), center.y + self.maxRadius*sinf(angleEnd));
        
        CGContextSaveGState(ctx);

        //画扇形
        CGContextMoveToPoint(ctx, minRadiusStart.x, minRadiusStart.y);
        CGContextAddArc(ctx, center.x, center.y, self.minRadius, angleStart, angleEnd, NO);
        CGContextAddLineToPoint(ctx, maxRadiusEnd.x, maxRadiusEnd.y);
        CGContextAddArc(ctx, center.x, center.y, self.maxRadius, angleEnd, angleStart, YES);
        CGContextClosePath(ctx);
        [itemColor set];
    
        //选择的扇形
        CGPoint transPoint = CGPointMake(self.touchPoint.x, self.frame.size.height - self.touchPoint.y);
        BOOL containsPoint = CGContextPathContainsPoint(ctx, transPoint, kCGPathFill);
        if (containsPoint) {
            if ([self.delegate respondsToSelector:@selector(pieChartView:didSelectItemAtIndex:)]) {
                [self.delegate pieChartView:self didSelectItemAtIndex:idx];
            }
        }
            CGContextFillPath(ctx);
            CGContextRestoreGState(ctx);
        angleStart = angleEnd;
    }];
    
    CGContextRestoreGState(ctx);
    
    if (self.showTitleType != EWPieChartShowTitleDefault
        || [self.delegate respondsToSelector:@selector(pieChartView:showItemTitleTypeAtItemIndex:)]
        || self.showItemPercent
        || [self.delegate respondsToSelector:@selector(pieChartView:showItemPercentAtItemIndex:)]) {
        
        [self drawItemTitles:ctx sumValues:sum];
    }
}

#pragma mark - Touch

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.touchPoint = touchPoint;
    [self setNeedsDisplay];
}

#pragma mark - getter and setter

-(NSMutableArray *)values
{
    if (!_values) {
        self.values = [NSMutableArray array];
    }
    return _values;
}
@end
