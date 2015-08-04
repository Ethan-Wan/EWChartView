//
//  EWPieChartView.m
//  JBChartViewDemo
//
//  Created by wansy on 15/8/4.
//  Copyright (c) 2015年 Jawbone. All rights reserved.
//

#import "EWPieChartView.h"

//default parameter
CGFloat static const kEWPieChartViewMaxRadius = 100.0f;
CGFloat static const kEWPieChartViewMinRadius = 0.0f;
CGFloat static const kEWPieChartViewStartAngle = 0.0f;
CGFloat static const kEWPieChartViewEndAngle = 360.0f;
CGFloat static const kEWPieChartViewAnimationDuration = 0.6f;
EWPieChartShowTitleType static const kEWPieChartViewShowTitleType = EWPieChartShowTitleDefault;
BOOL static const kEWPieChartViewShowItemPercent = NO;

//颜色
#define EWColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//随即色
#define EWRandomColor EWColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface EWPieChartView()

@property (nonatomic, strong) UIFont* font;

@property (nonatomic, strong) NSArray *chartData;

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
    self.animationDuration = kEWPieChartViewAnimationDuration;
    self.showTitleType = kEWPieChartViewShowTitleType;
    self.showItemPercent = kEWPieChartViewShowItemPercent;
    self.font = [UIFont systemFontOfSize:15];
}

//-(UIColor *)itemColorAtItemIndex:(NSInteger)index
//{
//    if ([self.delegate respondsToSelector:@selector(pieChartView:colorForItemAtItemIndex:)])
//    {
//        return [self.delegate pieChartView:self colorForItemAtItemIndex:index];
//    }else
//    {
//        return EWRandomColor;
//    }
//}

-(EWPieChartShowTitleType)showItemTitleTypeAtItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(pieChartView:showItemTitleTypeAtItemIndex:)])
    {
        return [self.delegate pieChartView:self showItemTitleTypeAtItemIndex:index];
    }else
    {
        return EWPieChartShowTitleDefault;
    }
}

//-(NSString *)itemTitleAtItemIndex:(NSInteger)index
//{
//    if ([self.delegate respondsToSelector:@selector(pieChartView:colorForItemAtItemIndex:)])
//    {
//        return [self.delegate pieChartView:self colorForItemAtItemIndex:index];
//    }else
//    {
//        return EWRandomColor;
//    }
//}

-(void)drawItemTitles:(CGContextRef)ctx sumValues:(CGFloat)sum
{
    CGContextSetShadowWithColor(ctx, CGSizeMake(0,1), 3, [UIColor blackColor].CGColor);
    
    __block float angleStart = self.startAngle * M_PI / 180.0;
    float angleInterval = (self.endAngle - self.startAngle) * M_PI / 180.0;
    
    
    [self.chartData enumerateObjectsUsingBlock:^(EWPieChartViewCell *cell, NSUInteger idx, BOOL *stop) {
        float angleEnd = angleStart + angleInterval * cell.value / sum;
        
        EWPieChartShowTitleType showTitleType = [self showItemTitleTypeAtItemIndex:idx];
        if(showTitleType == EWPieChartShowTitleDefault){
            angleStart = angleEnd;
//            continue;
        }
        UIColor *color = cell.color?: [UIColor blackColor];
        CGContextSetFillColorWithColor(ctx, color.CGColor);

        float angle = (angleStart + angleEnd) / 2.0;
        
//        NSString *text = self.transformTitleBlock? self.transformTitleBlock(elem) : [NSString stringWithFormat:@"%.2f", cell.value];
        float radius = self.maxRadius;
//        [self drawText:text angle:-angle radius:radius context:ctx];
        
        angleStart = angleEnd;

    }];
}

#pragma mark - Public Method

-(void)reloadData
{
    [self setNeedsDisplay];
    
    //获取图表数据
//    dispatch_block_t createChartData = ^{
        NSMutableArray *mutableChartData = [NSMutableArray array];
        
        NSAssert([self.dataSource respondsToSelector:@selector(numberOfItemInPieChartView)], @"EWPieChartView // dataSource must implement - (NSUInteger)numberOfSection");
        NSUInteger numberOfItem = [self.dataSource numberOfItemInPieChartView];
        
        for (NSUInteger itemIndex = 0; itemIndex < numberOfItem; itemIndex++)
        {
            NSAssert([self.dataSource respondsToSelector:@selector(pieChartView:pieChartViewCellForItemIndex:)], @"EWPieChartView // delegate must implement - - (CGFloat)pieChartView:(EWPieChartView *)pieChartViewitemValueForItemIndex:(NSUInteger)itemIndex;");
            EWPieChartViewCell *cell =  [self.dataSource pieChartView:self pieChartViewCellForItemIndex:itemIndex];
            
            [mutableChartData addObject:cell];
        }
        self.chartData = [NSArray arrayWithArray:mutableChartData];
//    };
    
    
//    createChartData();
    
    [self setNeedsDisplay];
}

- (void)setMaxRadius:(float)maxRadius minRadius:(float)minRadius animated:(BOOL)isAnimated
{
    
}

- (void)setStartAngle:(float)startAngle endAngle:(float)endAngle animated:(BOOL)isAnimated
{
    
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(self.chartData.count == 0 || self.minRadius >= self.maxRadius)
        return;

    float sum = [[self.chartData valueForKeyPath:@"@sum.floatValue"] floatValue];
    if(sum <= 0)
        return;
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    //翻转
    CGContextTranslateCTM(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextScaleCTM(ctx, -1, -1);
    
    __block float angleStart = self.startAngle * M_PI / 180.0;
    float angleInterval = (self.endAngle - self.startAngle) * M_PI / 180.0;
    
    [self.chartData enumerateObjectsUsingBlock:^(EWPieChartViewCell *cell, NSUInteger idx, BOOL *stop) {
        float angleEnd = angleStart + angleInterval * cell.value / sum;
//        float centrAngle = (angleEnd + angleStart) * 0.5;
        
        UIColor *itemColor = cell.color?cell.color:EWRandomColor;
        
        CGPoint minRadiusStart = CGPointMake(center.x + self.minRadius*cosf(angleStart), center.y + self.minRadius*sinf(angleStart));
        CGPoint maxRadiusEnd = CGPointMake(center.x + self.maxRadius*cosf(angleEnd), center.y + self.maxRadius*sinf(angleEnd));
        
        //保存上下文
        CGContextSaveGState(ctx);
        
        //画扇形
        CGContextMoveToPoint(ctx, minRadiusStart.x, minRadiusStart.y);
        CGContextAddArc(ctx, center.x, center.y, self.minRadius, angleStart, angleEnd, NO);
        CGContextAddLineToPoint(ctx, maxRadiusEnd.x, maxRadiusEnd.y);
        CGContextAddArc(ctx, center.x, center.y, self.maxRadius, angleEnd, angleStart, YES);
        CGContextClosePath(ctx);
//        CGContextClip(ctx);
        
        //填充颜色，然后绘制渲染 （用set 设置颜色，不用区分实心和空心）
        [itemColor set];
//        CGContextFillRect(ctx, self.bounds);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        //还原上下文，会先将当前上下文delete，然后拿到之前save的上下文
        CGContextRestoreGState(ctx);
        
        angleStart = angleEnd;
    }];
    
    CGContextRestoreGState(ctx);
    
    if (self.showTitleType != EWPieChartShowTitleDefault || [self.delegate respondsToSelector:@selector(pieChartView:showItemTitleTypeAtItemIndex:)]) {
        [self drawItemTitles:ctx sumValues:sum];
    }
}

@end
