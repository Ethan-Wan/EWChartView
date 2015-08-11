//
//  EWPieChartView.h
//  JBChartViewDemo
//
//  Created by wansy on 15/8/4.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EWPieChartViewCell.h"

@class EWPieChartView;

typedef enum {
    EWPieChartShowTitleDefault = 0, //默认不显示标题
    EWPieChartShowTitleOutItem = 1, //在item外面显示标题
    EWPieChartShowTitleInItem  = 2  //在item内部显示标题（美观问题，暂时没有去实现）
}EWPieChartShowTitleType;

@protocol EWPieChartViewDataSource <NSObject>

@required
/**
 *  返回饼状图中块的数量
 *
 *  @return 数量
 */
- (NSUInteger)numberOfItemInPieChartView;

/**
 *  初始化EWPieChartViewCell
 *
 *  @param pieChartView 当前饼图
 *  @param itemIndex    item索引
 *
 *  @return 返回初始化后的EWPieChartViewCell
 */
- (EWPieChartViewCell *)pieChartView:(EWPieChartView *)pieChartView pieChartViewCellForItemIndex:(NSUInteger)itemIndex;

@end

@protocol EWPieChartViewDelegate <NSObject>

@optional

/**
 *  选择item
 *
 *  @param pieChartView 当前饼图
 *  @param itemIndex    item索引
 */
- (void)pieChartView:(EWPieChartView *)pieChartView didSelectItemAtIndex:(NSUInteger)itemIndex;

/**
 *  取消选择
 *
 *  @param pieChartView 当前饼图
 */
//- (void)pieChartView:(EWPieChartView *)pieChartView didDeselectItemInPieChartView:(EWPieChartView *)pieChartView;

/**
 *  显示标题类型 （实现这个代理方法就不需要设置showTitleType属性，设置了也无效）
 *
 *  @param pieChartView 当前饼图
 *  @param itemIndex    item索引
 *
 *  @return 显示标题的类型
 */
- (EWPieChartShowTitleType)pieChartView:(EWPieChartView *)pieChartView showItemTitleTypeAtItemIndex:(NSUInteger)itemIndex;

/**
 *  显示百分比 （实现这个代理方法就不需要设置showItemPercent属性，设置了也无效）
 *
 *  @param pieChartView 当前饼图
 *  @param itemIndex    item索引
 *
 *  @return 每个item的百分比
 */
- (BOOL)pieChartView:(EWPieChartView *)pieChartView showItemPercentAtItemIndex:(NSUInteger)itemIndex;

@end

@interface EWPieChartView : UIView

@property (nonatomic, weak) id<EWPieChartViewDataSource> dataSource;
@property (nonatomic, weak) id<EWPieChartViewDelegate> delegate;


@property (nonatomic, assign) float maxRadius;   //default 100
@property (nonatomic, assign) float minRadius;   //default 0
@property (nonatomic, assign) float startAngle;  //default 0
@property (nonatomic, assign) float endAngle;    //default 360 
//@property (nonatomic, assign) float animationDuration;   //default 0.6s

/** 标题的样式*/
@property (nonatomic, strong) NSDictionary *titleAttributes;
/** 百分比的样式*/
@property (nonatomic, strong) NSDictionary *percentAttributes;

@property (nonatomic, assign) EWPieChartShowTitleType showTitleType;   //default not show
@property (nonatomic, assign) BOOL showItemPercent;   //default NO


-(void)reloadData;

@end