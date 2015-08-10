//
//  EWSegmentHeadView.m
//  EWSegmentView
//
//  Created by wansy on 15/7/8.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWSegmentHeadView.h"
#import "EWSegmentHeadButton.h"

@interface EWSegmentHeadView()

@property (nonatomic, strong) EWSegmentHeadButton *selectedHeadButton;

@end

@implementation EWSegmentHeadView

/**
 *  布局按钮
 */
-(void)layoutSubviews
{
    CGFloat viewH = self.frame.size.height;
    CGFloat headButtonW = self.frame.size.width/self.subviews.count;
    
    [self.subviews enumerateObjectsUsingBlock:^(EWSegmentHeadButton *headView, NSUInteger idx, BOOL *stop) {
        headView.frame = CGRectMake(idx * headButtonW, 0, headButtonW , viewH);
    }];
}

#pragma mark - private method

/**
 *  根据传入控制器的标题来添加按钮
 *
 *  @param title 控制器标题
 */
-(void)addHeadButton:(NSString *)title
{
    EWSegmentHeadButton *headButton = [[EWSegmentHeadButton alloc] init];
    
    //设置按钮的基本属性
    [headButton.button setTitle:title forState:UIControlStateNormal];
    [headButton.button setTitleColor:self.selectedTitleColor?self.selectedTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [headButton.button setTitleColor:self.normalTitleColor?self.normalTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headButton.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (!self.selectedHeadButton) {
        self.selectedHeadButton = headButton;
        if (!self.isHiddenBottom)
        {
            [headButton.colorLabel setBackgroundColor:self.bottomColor?self.bottomColor:[UIColor orangeColor]];
        }
        self.selectedHeadButton.button.selected = YES;
    }
    [self addSubview:headButton];
}

/**
 *  按钮的切换
 *
 *  @param button 按钮
 */
-(void)turnSelectedButton:(UIButton *)button
{
    EWSegmentHeadButton *headButton = (EWSegmentHeadButton *)[button superview];
    
    //切换选中状态
    if(self.selectedHeadButton.button != button)
    {
        
        //没隐藏底部条的时候切换颜色
        if (!self.isHiddenBottom) {
            [self.selectedHeadButton.colorLabel setBackgroundColor:[UIColor clearColor]];
            headButton.colorLabel.backgroundColor = self.bottomColor?self.bottomColor:[UIColor orangeColor];
        }
        
        self.selectedHeadButton.button.selected = NO;
        button.selected = YES;
        self.selectedHeadButton = headButton;
    }
    
}

#pragma mark - event response

-(void)buttonClick:(UIButton *)button
{
    if(self.selectedHeadButton.button == button) return;
    [self turnSelectedButton:button];

    if (self.didClick) {
        _didClick();
    }
}

#pragma mark - public method

-(void)setHeadTitles:(NSMutableArray *)titles
{
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [self addHeadButton:title];
    }];
}

-(void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex
{
    EWSegmentHeadButton *headButton = (EWSegmentHeadButton *)self.subviews[selectedButtonIndex];
    
    [self turnSelectedButton:headButton.button];
}

-(NSInteger)selectedButtonIndex
{
    return [self.subviews indexOfObject:self.selectedHeadButton];
}

@end
