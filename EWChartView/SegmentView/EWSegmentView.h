//
//  EWSegmentView.h
//  EWSegmentView
//
//  Created by wansy on 15/7/8.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWSegmentHeadView;

@interface EWSegmentView : UIView

/**
 *  用来存放需要所有的控制器
 */
@property (strong, nonatomic)NSMutableArray *subViewControllers;

@property (weak, nonatomic) EWSegmentHeadView *headView;

@end
