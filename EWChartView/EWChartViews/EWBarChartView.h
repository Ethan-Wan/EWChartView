//
//  EWBarChartView.h
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWChartView.h"
@class EWBarChartView;

@protocol EWBarChartViewDataSource <EWChartViewDataSource>

@required

/**
 *  bar的数量 （理论上返回的都要相同）
 *
 *  @param barChartView 当前柱状图
 *  @param barIndex     柱状图索引
 *
 *  @return 返回不同柱状图所有柱的数量
 */
- (NSUInteger)barChartView:(EWBarChartView *)barChartView numberOfBarAtBarIndex:(NSUInteger)barIndex;

/**
 *  不同的柱子数据的具体值
 *
 *  @param barChartView    当前柱状图
 *  @param horizontalIndex x轴的索引
 *  @param barIndex        柱状图索引
 *
 *  @return 返回不同的柱子上数据的具体值
 */
- (CGFloat)barChartView:(EWBarChartView *)barChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atBarIndex:(NSUInteger)barIndex;

@optional

/**
 *  柱状图个数（默认是1条柱状图）
 *
 *  @param barChartView    当前柱状图
 *
 *  @return 返回柱状图数量
 */
- (NSUInteger)numberOfBarInBarChartView:(EWBarChartView *)barChartView;


/**
 *  水平坐标上的坐标值
 *
 *  @param barChartView    当前柱状图
 *  @param horizontalIndex x轴的索引
 *
 *  @return 返回坐标值的text
 */
- (NSString *)barChartView:(EWBarChartView *)barChartView horizontalTitlseForHorizontalIndex:(NSUInteger)horizontalIndex;

@end

@protocol EWBarChartViewDelegate <EWChartViewDelegate>

@optional

/**
 *  选择柱状图
 *
 *  @param barChartView    当前柱状图
 *  @param horizontalIndex x轴的索引
 *  @param barIndex        柱状图索引
 *  @param touchPoint      触摸点的坐标
 */
- (void)barChartView:(EWBarChartView *)barChartView didSelectbarAtIndex:(NSUInteger)barndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint;

/**
 *  选择柱状图
 *
 *  @param barChartView    当前柱状图
 *  @param horizontalIndex x轴的索引
 *  @param barIndex        柱状图索引
 */
- (void)barChartView:(EWBarChartView *)barChartView didSelectbarAtIndex:(NSUInteger)barndex horizontalIndex:(NSUInteger)horizontalIndex;

/**
 *  取消选择
 *
 *  @param lineChartView 当前抓状图
 */
- (void)didDeselectLineInLineChartView:(EWBarChartView *)lineChartView;

/**
 *  不同柱状图柱子的颜色 （设置了 barChartView:colorForBarAtHorizontalIndex: 后该方法就失效）
 *
 *  @param lineChartView 当前折线图
 *  @param lineIndex     第几条折线的索引
 *
 *  @return 返回不同线段的颜色
 */
- (UIColor *)barChartView:(EWBarChartView *)barChartView colorForBarAtBarIndex:(NSUInteger)barIndex;


/**
 *   一个柱状图中 不同柱子的颜色
 *
 *  @param barChartView    当前柱状图
 *  @param horizontalIndex x轴的索引
 *
 *  @return 返回不同柱状图中不同柱子的颜色
 */
- (UIColor *)barChartView:(EWBarChartView *)barChartView colorForBarAtHorizontalIndex:(NSUInteger)horizontalIndex;

/**
 *  显示柱子上的数据值
 *
 *  @param barChartView    当前柱状图
 *  @param horizontalIndex x轴的索引
 *  @param barIndex        柱状图索引
 *
 *  @return YES／NO
 */
- (BOOL)barChartView:(EWBarChartView *)barChartView showBarValuesAtHorizontalIndex:(NSUInteger)horizontalIndex atBarIndex:(NSUInteger)barIndex;

@end

@interface EWBarChartView : EWChartView

@property (nonatomic, weak) id<EWBarChartViewDataSource> dataSource;
@property (nonatomic, weak) id<EWBarChartViewDelegate> delegate;

/** 柱子的颜色 */
@property (nonatomic ,strong) UIColor *barColor;  //defalut nil

-(void)reloadData;

@end
