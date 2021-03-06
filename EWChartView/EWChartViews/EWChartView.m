//
//  EWChartView.m
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWChartView.h"

//default parameter
NSInteger static const kEWChartViewSectionCount = 1;
NSInteger static const kEWChartViewLabelFont    = 10;

//const
CGFloat static const kEWChartViewXYAxisPadding = 3.0f;

//macro
#define kEWChartViewcoordinateLabelColor [UIColor blackColor]

@interface EWChartView ()

@property (nonatomic, assign) BOOL hasMaximumValue;
@property (nonatomic, assign) BOOL hasMinimumValue;

-(void)drawYAxisLabelsWithMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue context:(CGContextRef)ctx showGrid:(BOOL)showGrid;

@end

@implementation EWChartView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initData];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   
    if(self = [super initWithCoder:aDecoder]){
        [self initData];
    }
    return self;
}

#pragma mark - public method

-(void)initData
{
    self.backgroundColor = [UIColor whiteColor];
    self.sectionCount = kEWChartViewSectionCount;
    self.coordinateColor = kEWChartViewcoordinateColor;
    self.xLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kEWChartViewLabelFont],
                   NSForegroundColorAttributeName:kEWChartViewcoordinateLabelColor,
                              };
    self.yLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kEWChartViewLabelFont],
                   NSForegroundColorAttributeName:kEWChartViewcoordinateLabelColor,
                              };
    self.valueAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kEWChartViewLabelFont],
                  NSForegroundColorAttributeName:kEWChartViewcoordinateLabelColor,
                             };
}

- (void)resetMinimumValue
{
    _hasMinimumValue = NO; // clears min
}

- (void)resetMaximumValue
{
    _hasMaximumValue = NO; // clears max
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
    
//    CGContextSaveGState(ctx);
    
    CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth, kEWChartViewHeaderPadding);
    CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth, self.bounds.size.height - kEWChartViewXAxisHeight + kEWChartViewXYAxisWidth);
    CGContextAddLineToPoint(ctx, self.bounds.size.width - kEWChartViewXYAxisWidth, self.bounds.size.height - kEWChartViewXAxisHeight + kEWChartViewXYAxisWidth);
    
    [self.coordinateColor set];
    CGContextSetLineWidth(ctx, kEWChartViewXYAxisWidth);
    
    CGContextStrokePath(ctx);
}

-(void)drawYAxisLabelsWithMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue context:(CGContextRef)ctx showGrid:(BOOL)showGrid
{
    CGFloat ystepLength = (self.bounds.size.height - kEWChartViewHeaderPadding - kEWChartViewXAxisHeight)/self.sectionCount;
    CGFloat stepValue = ([self maximumValue] - [self minimumValue])/ self.sectionCount;
    
    for (int index = 0; index < self.sectionCount + 1; index++) {
        NSString *yValue = [NSString stringWithFormat:@"%.1f",[self maximumValue]-(stepValue * index)];
        
        CGContextSaveGState(ctx);
        {
            if (!showGrid) {
                CGContextMoveToPoint(ctx, kEWChartViewYAxisWidth, kEWChartViewHeaderPadding + kEWChartViewXYAxisWidth + ystepLength * index);
                CGContextAddLineToPoint(ctx, kEWChartViewYAxisWidth - kEWChartViewXYAxisPadding, kEWChartViewHeaderPadding + kEWChartViewXYAxisWidth + ystepLength * index);
                [self.coordinateColor set];
                CGContextSetLineWidth(ctx, kEWChartViewXYAxisWidth);
                CGContextStrokePath(ctx);
            }
            
            CGSize valueSize = [yValue sizeWithAttributes:self.yLabelAttributes];
            CGFloat pointX = (kEWChartViewYAxisWidth - kEWChartViewXYAxisPadding) * 0.5 - valueSize.width * 0.5;
            CGFloat pointY = kEWChartViewHeaderPadding + ystepLength * index - valueSize.height * 0.5;
            
            CGPoint point = (CGPoint){pointX,pointY};
            [yValue drawAtPoint:point withAttributes:self.yLabelAttributes];
        }
        CGContextRestoreGState(ctx);
    }

}

#pragma mark - Getter And Setter

- (void)setMinimumValue:(CGFloat)minimumValue
{
    NSAssert(minimumValue >= 0, @"EWChartView // the minimumValue must be >= 0.");
    _minimumValue = minimumValue;
    _hasMinimumValue = YES;
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    NSAssert(maximumValue >= 0, @"EWChartView // the maximumValue must be >= 0.");
    _maximumValue = maximumValue;
    _hasMaximumValue = YES;
}


@end
