//
//  EWPieChartViewCell.m
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWPieChartViewCell.h"

@implementation EWPieChartViewCell

+(instancetype)cellWithTitle:(NSString *)title color:(UIColor *)color value:(CGFloat)value
{
    EWPieChartViewCell *cell = [[EWPieChartViewCell alloc] init];
    cell.title = title;
    cell.color = color;
    cell.value = value;
    return cell;
}

@end
