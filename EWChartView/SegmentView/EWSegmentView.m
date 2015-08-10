//
//  EWSegmentView.m
//  EWSegmentView
//
//  Created by wansy on 15/7/8.
//  Copyright (c) 2015年 wansy. All rights reserved.
//

#import "EWSegmentView.h"
#import "EWSegmentHeadView.h"

@interface EWSegmentView()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation EWSegmentView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupPageView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupPageView];
    }
    return self;
}

#pragma mark - setup

-(void)setupPageView
{
    [self addSubview:self.pageViewController.view];
}

#pragma mark - private method

-(NSMutableArray *)getTitles
{
    NSMutableArray *titles = [NSMutableArray array];
    for (UIViewController *vc in self.subViewControllers) {
        [titles addObject:vc.title? vc.title:@"title"];
    }
    return [titles copy];
}

- (UIViewController *)selectedController
{
    return self.subViewControllers[[self.headView selectedButtonIndex]];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.subViewControllers indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.subViewControllers[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.subViewControllers indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.subViewControllers count])) {
        return nil;
    }
    
    return self.subViewControllers[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    //改变headView中选种的按钮
    [self.headView setSelectedButtonIndex:[self.subViewControllers indexOfObject:[viewController.viewControllers lastObject]]];
}

#pragma mark - setter and getter

-(void)setSubViewControllers:(NSMutableArray *)subViewControllers
{
    _subViewControllers = subViewControllers;
    
    if ([self.subViewControllers count]>0) {
        [self.pageViewController setViewControllers:@[self.subViewControllers[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
    
}

-(void)setHeadView:(EWSegmentHeadView *)headView
{
    _headView = headView;
    
//    _headView.delegate = self;
    
    [self.headView setHeadTitles:[self getTitles]];
    
    //利用block完成点击headview按钮事件
    _headView.didClick = ^()
    {
        UIPageViewControllerNavigationDirection direction = [self.headView selectedButtonIndex] > [self.subViewControllers indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
            [self.pageViewController setViewControllers:@[[self selectedController]]
                                              direction:direction
                                               animated:YES
                                             completion:NULL];
    };
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController)
    {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        [_pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    return _pageViewController;
}

@end
