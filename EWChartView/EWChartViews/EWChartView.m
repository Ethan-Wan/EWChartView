//
//  EWChartView.m
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWChartView.h"

//default parameter
CGFloat   static const kEWChartViewMinValue     = 0.0f;
CGFloat   static const kEWChartViewManValue     = 1.0f;
NSInteger static const kEWChartViewSectionCount = 1;
NSInteger static const kEWChartViewLabelFont    = 12;

//const
CGFloat static const kEWChartViewXYAxisPadding = 3.0f;
CGFloat static const kEWChartViewXYAxisWidth   = 0.5f;

@implementation EWChartView

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

#pragma mark - public method

-(void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.minimumValue = kEWChartViewMinValue;
    self.maximumValue = kEWChartViewManValue;
    self.sectionCount = kEWChartViewSectionCount;
    self.yLabelFont = [UIFont systemFontOfSize:kEWChartViewLabelFont];
    self.xLabelFont = [UIFont systemFontOfSize:kEWChartViewLabelFont];
    self.coordinateColor = kEWChartViewcoordinateColor;
    self.coordinateLabelColor = kEWChartViewcoordinateLabelColor;
}

#pragma mark - public method

-(void)reloadData
{
     // Override
}

-(void)creatYAxisWithSectionCount:(NSInteger)sectionCount minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
{
    self.minimumValue = minValue;
    self.maximumValue = maxValue;
    self.sectionCount = sectionCount;
}

#pragma mark - drawRect 

/**
 *  画坐标轴
 */
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth, kEWChartViewHeaderPadding);
    CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth, self.bounds.size.height - kEWChartViewXAxisHeight);
    CGContextAddLineToPoint(ctx, self.bounds.size.width - kEWChartViewXYAxisWidth, self.bounds.size.height - kEWChartViewXAxisHeight);
    
    [self.coordinateColor set];
    CGContextSetLineWidth(ctx, kEWChartViewXYAxisWidth);
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
    CGFloat stepLength = (self.bounds.size.height - kEWChartViewHeaderPadding - kEWChartViewXAxisHeight)/self.sectionCount;
    CGFloat stepValue = (self.maximumValue - self.minimumValue)/ self.sectionCount;
    
    for (int index = 0; index < self.sectionCount + 1; index++) {
        NSString *yValue = [NSString stringWithFormat:@"%.1f",1-(stepValue * index)];
        
        CGContextSaveGState(ctx);
        {
            CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth, kEWChartViewHeaderPadding + stepLength * index);
            CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth - kEWChartViewXYAxisPadding, kEWChartViewHeaderPadding + stepLength * index);
            [self.coordinateColor set];
            CGContextStrokePath(ctx);
        
            CGSize valueSize = [yValue sizeWithAttributes:@{NSFontAttributeName:self.yLabelFont}];
            CGFloat pointX = (kEWChartViewYAxisWidth - kEWChartViewXYAxisPadding) * 0.5 - valueSize.width * 0.5;
            CGFloat pointY = kEWChartViewHeaderPadding + stepLength * index - valueSize.height * 0.5;
        
            CGPoint point = (CGPoint){pointX,pointY};
            [yValue drawAtPoint:point withAttributes:@{NSFontAttributeName:self.yLabelFont,NSForegroundColorAttributeName:self.coordinateLabelColor}];
        }
        CGContextRestoreGState(ctx);
    }
    
}

#pragma mark - Getter And Setter

- (void)setMinimumValue:(CGFloat)minimumValue
{
    NSAssert(minimumValue >= 0, @"EWChartView // the minimumValue must be >= 0.");
    _minimumValue = minimumValue;
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    NSAssert(maximumValue >= 0, @"EWChartView // the maximumValue must be >= 0.");
    _maximumValue = maximumValue;
}


@end
