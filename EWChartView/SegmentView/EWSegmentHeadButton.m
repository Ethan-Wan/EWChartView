//
//  EWSegmentHeadButton.m
//  EWSegmentView
//
//  Created by wansy on 15/7/8.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWSegmentHeadButton.h"

@implementation EWSegmentHeadButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews
{
    _button = [[UIButton alloc] init];
    [self addSubview:_button];
    
    _colorLabel = [[UILabel alloc] init];
    [self addSubview:_colorLabel];
}

-(void)layoutSubviews
{
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    self.button.frame = CGRectMake(0, 0, viewW, viewH);
    self.colorLabel.frame = CGRectMake(0.05 * viewW, viewH * 0.9, viewW * 0.9, viewH * 0.1);
}
@end
