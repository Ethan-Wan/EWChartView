//
//  EWPieChartViewCell.h
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EWPieChartViewCell : UIView
/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 颜色 */
@property (nonatomic, strong) UIColor *color;

/** 值 */
@property (nonatomic, assign) CGFloat value;

+(instancetype)cellWithTitle:(NSString *)title color:(UIColor *)color value:(CGFloat)value;

@end
