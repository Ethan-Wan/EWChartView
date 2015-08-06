//
//  EWChartView.h
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import <UIKit/UIKit.h>

//default size
CGFloat static const kEWChartViewHeaderPadding = 10.0f;
CGFloat static const kEWChartViewYAxisWidth = 25.0f;
CGFloat static const kEWChartViewXAxisHeight = 20.0f;

//macro
#define kEWChartViewcoordinateColor [UIColor lightGrayColor]
#define kEWChartViewcoordinateLabelColor [UIColor blackColor]

@protocol EWChartViewDataSource <NSObject>

//to extend

@end

@protocol EWChartViewDelegate <NSObject>

//to extend

@end

@interface EWChartView : UIView

@property (nonatomic, weak) id<EWChartViewDataSource> dataSource;
@property (nonatomic, weak) id<EWChartViewDelegate> delegate;

/** y坐标的最小值 */
@property (nonatomic, assign) CGFloat minimumValue; //default 数据源数组中的最小值

/** y坐标的最大值 */
@property (nonatomic, assign) CGFloat maximumValue; //default 数据源数据中的最大值

/** y坐标上的分段数 */
@property (nonatomic, assign) NSInteger sectionCount; //default one

/** 是否显示坐标网格 */
//@property (nonatomic, assign) BOOL showGrid  ; //default NO  (暂定为折线图所有)


/** y坐标上的文字font */
@property (nonatomic, strong) UIFont *yLabelFont  ; //default 12

/** x坐标上的文字font */
@property (nonatomic, strong) UIFont *xLabelFont  ; //default 12

/** 坐标轴的颜色 */
@property (nonatomic, strong) UIColor *coordinateColor; //default lightGrayColor

/** 坐标上字体的颜色 */
@property (nonatomic, strong) UIColor *coordinateLabelColor; //default lightGrayColor

/** x坐标上文字的样式 */
@property (nonatomic, strong) NSDictionary *xLabelAttributes; //default

/** y坐标上文字的样式 */
@property (nonatomic, strong) NSDictionary *yLabelAttributes; //default

-(void)reloadData;

// 将最大值和最小值reset为默认值
- (void)resetMinimumValue;
- (void)resetMaximumValue;

-(void)creatYAxisWithSectionCount:(NSInteger)sectionCount minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

@end
