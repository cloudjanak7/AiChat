//
//  ZHBEmotionListView.m
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#import "ZHBEmotionListView.h"
#import "ZHBEmotionGridView.h"
#import "UIImage+Helper.h"
#import "UIView+Frame.h"

@interface ZHBEmotionListView ()<UIScrollViewDelegate>

/*! 显示所有表情的UIScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/*! 显示页码的UIPageControl */
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ZHBEmotionListView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.UIPageControl的frame
    self.pageControl.width  = self.width;
    self.pageControl.height = 35;
    self.pageControl.y      = self.height - self.pageControl.height;
    
    // 2.UIScrollView的frame
    self.scrollView.width  = self.width;
    self.scrollView.height = self.pageControl.y;
    
    // 3.设置UIScrollView内部控件的尺寸
    NSInteger count = self.pageControl.numberOfPages;
    CGFloat gridW   = self.scrollView.width;
    CGFloat gridH   = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(count * gridW, 0);
    for (NSInteger index = 0; index < count; index ++) {
        ZHBEmotionGridView *gridView = self.scrollView.subviews[index];
        gridView.width  = gridW;
        gridView.height = gridH;
        gridView.x      = index * gridW;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.width + 0.5);
}

#pragma mark -
#pragma mark Getters

- (UIScrollView *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (nil == _pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    }
    return _pageControl;
}

#pragma mark Setters
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 设置总页数
    NSInteger totalPages = (emotions.count + kEmotionMaxCountPerPage - 1) / kEmotionMaxCountPerPage;
    NSInteger currentGridViewCount = self.scrollView.subviews.count;
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    
    // 决定scrollView显示多少页表情
    for (NSInteger index = 0; index < totalPages; index ++) {
        ZHBEmotionGridView *gridView = nil;
        if (index >= currentGridViewCount) {
            gridView = [[ZHBEmotionGridView alloc] init];
            [self.scrollView addSubview:gridView];
        } else {
            gridView = self.scrollView.subviews[index];
        }
        
        NSInteger loc = index * kEmotionMaxCountPerPage;
        NSInteger len = kEmotionMaxCountPerPage;
        if (loc + len > emotions.count) { // 对越界进行判断处理
            len = emotions.count - loc;
        }
        NSRange gridViewEmotionsRange = NSMakeRange(loc, len);
        NSArray *gridViewEmotions = [emotions subarrayWithRange:gridViewEmotionsRange];
        gridView.emotions = gridViewEmotions;
        gridView.hidden = NO;
    }
    
    // 隐藏后面的不需要用到的gridView
    for (NSInteger index = totalPages; index < currentGridViewCount; index ++) {
        ZHBEmotionGridView *gridView = self.scrollView.subviews[index];
        gridView.hidden = YES;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
    
    // 表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
}


@end
