//
//  EWLineCharView.h
//  EWChartView
//
//  Created by wansy on 15/8/5.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWChartView.h"
@class EWLineCharView;

@protocol EWLineChartViewDataSource <EWChartViewDataSource>

@required

/**
 *  给个折线图的数据的数量
 *
 *  @param lineChartView 当前折线图
 *  @param lineIndex     第几条折线的索引
 *
 *  @return 返回不同折线的数据个数
 */
- (NSUInteger)lineChartView:(EWLineCharView *)lineChartView numberOfLinesAtLineIndex:(NSUInteger)lineIndex;

/**
 *  不同的折线上数据的具体值
 *
 *  @param lineChartView   当前折线图
 *  @param horizontalIndex x轴的索引
 *  @param lineIndex       第几条折线的索引
 *
 *  @return 返回不同的折线上数据的具体值
 */
- (CGFloat)lineChartView:(EWLineCharView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex;

@optional

/**
 *  折线图的个数
 *
 *  @param lineChartView 当前折线图
 *
 *  @return 返回折线图数量 （默认是1条折线图）
 */
- (NSUInteger)numberOfLinesInLineChartView:(EWLineCharView *)lineChartView;

/**
 *  是否显示折线图上的圆点
 *
 *  @param lineChartView 当前折线图
 *  @param lineIndex     第几条折线的索引
 *
 *  @return YES／NO （默认为NO）
 */
- (BOOL)lineChartView:(EWLineCharView *)lineChartView showsCircleForLineAtLineIndex:(NSUInteger)lineIndex;

/**
 *  是否显示折线图上的空心圆
 *
 *  @param lineChartView   当前折线图
 *  @param horizontalIndex x轴的索引
 *  @param lineIndex       第几条折线的索引
 *
 *  @return YES／NO （默认为NO）
 */
- (BOOL)lineChartView:(EWLineCharView *)lineChartView showsAnnulusForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex;

/**
 *  是否是光滑的险段
 *
 *  @param lineChartView 当前折线图
 *  @param lineIndex     第几条折线的索引
 *
 *  @return YES／NO （默认为NO）
 */
- (BOOL)lineChartView:(EWLineCharView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex;

/**
 *  水平坐标上的坐标值
 *
 *  @param lineChartView   当前折线图
 *  @param horizontalIndex x轴的索引
 *
 *  @return 返回坐标值的text
 */
- (NSString *)lineChartView:(EWLineCharView *)lineChartView horizontalTitlseForHorizontalIndex:(NSUInteger)horizontalIndex;

@end

@protocol EWLineChartViewDelegate <EWChartViewDelegate>

@optional

/**
 *  选择折线图
 *
 *  @param lineChartView   当前折线图
 *  @param horizontalIndex x轴的索引
 *  @param lineIndex       第几条折线的索引
 *  @param touchPoint      触摸点的坐标
 */
- (void)lineChartView:(EWLineCharView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint;

/**
 *  选择折线图
 *
 *  @param lineChartView   当前折线图
 *  @param horizontalIndex x轴的索引
 *  @param lineIndex       第几条折线的索引
 */
- (void)lineChartView:(EWLineCharView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex;

/**
 *  取消选择
 *
 *  @param lineChartView 当前折线图
 */
- (void)didDeselectLineInLineChartView:(EWLineCharView *)lineChartView;

/**
 *  不同线段的颜色
 *
 *  @param lineChartView 当前折线图
 *  @param lineIndex     第几条折线的索引
 *
 *  @return 返回不同线段的颜色
 */
- (UIColor *)lineChartView:(EWLineCharView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex;

/**
 *  不同线段的宽度
 *
 *  @param lineChartView 当前折线图
 *  @param lineIndex     第几条折线的索引
 *
 *  @return 返回不同线段的宽度
 */
- (CGFloat)lineChartView:(EWLineCharView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex;


/**
 *  圆或圆环的半径
 *
 *  @param lineChartView   当前折线图
 *  @param horizontalIndex x轴的索引
 *  @param lineIndex       第几条折线的索引
 *
 *  @return 返回圆或圆环的半径
 */
- (CGFloat)lineChartView:(EWLineCharView *)lineChartView circleRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex;


@end

@interface EWLineCharView : EWChartView

@property (nonatomic, weak) id<EWLineChartViewDataSource> dataSource;
@property (nonatomic, weak) id<EWLineChartViewDelegate> delegate;

/** 是否显示坐标网格 */
@property (nonatomic, assign) BOOL showGrid  ; //default NO

-(void)reloadData;
@end
