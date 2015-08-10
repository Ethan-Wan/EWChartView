//
//  EWSegmentHeadView.h
//  EWSegmentView
//
//  Created by wansy on 15/7/8.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EWSegmentHeadView : UIView

/**
 *  设置headView中每个按钮的标题
 *
 *  @param titles 标题
 */
-(void)setHeadTitles:(NSMutableArray *)titles;

@property (nonatomic,strong) UIColor *selectedTitleColor;

@property (nonatomic,strong) UIColor *normalTitleColor;

//@property (nonatomic,strong) UIColor *backgroundColor;

@property (nonatomic,strong) UIColor *bottomColor;

/** 定义按钮切换的block*/
@property (nonatomic,strong) void (^didClick)();

/**
 *  是否隐藏底部的颜色条
 */
@property (nonatomic,getter=isHiddenBottom) BOOL hiddenBottom;

/**
 *  选中按钮的索引
 */
@property (nonatomic,assign) NSInteger selectedButtonIndex;

@end
