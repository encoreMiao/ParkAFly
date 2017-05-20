////
////  JLAdvertisingScrollView.m
////  JLAdvertisingScrollView
////
////  Created by 刘靖 on 2017/3/16.
////  Copyright © 2017年 刘靖. All rights reserved.
////
//
//#import "JLAdvertisingScrollView.h"
////#import <JLExtension/JLExtension.h>
//#import <AFNetworking/UIButton+AFNetworking.h>
//
//@interface JLAdvertisingScrollView () <UIScrollViewDelegate>
//
//@property (strong, nonatomic) UIScrollView *scrollView;
//@property (strong, nonatomic) UIPageControl *pageControl;
//@property (strong, nonatomic) NSMutableArray <UIButton *> *buttons;
//@property (strong, nonatomic) NSTimer *timer;
//@property (assign, nonatomic) NSTimeInterval timeInterval;
//@end
//
//@implementation JLAdvertisingScrollView
//
//- (void)touchUpInside:(UIButton *)button {
//    if (_delegate) {
//        if ([_delegate respondsToSelector:@selector(advertisingScrollView:clickEventAtIndex:)]) {
//            [_delegate advertisingScrollView:self clickEventAtIndex:[button tag]];
//        }
//    }
//}
//
//- (void)timerFired:(NSTimer *)timer {
//    NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
//    if ((int)currentDate % (int)_timeInterval == 0) {
//        //NSLog(@"%d",(int)currentDate);
//        NSUInteger count =  [_buttons count];
//        if (count > 0) {
//            [_scrollView setUserInteractionEnabled:NO];
//            NSInteger page = _pageControl.currentPage;
//            if (page == count-2-1) {
//                [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(page+2), 0, self.frame.size.width, self.frame.size.height) animated:YES];
//                [_pageControl setCurrentPage:0];
//                
//                double delayInSeconds = 1.0;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
//                });
//            }else {
//                [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(page+2), 0, self.frame.size.width, self.frame.size.height) animated:YES];
//                [_pageControl setCurrentPage:page+1];
//            }
//            [_scrollView setUserInteractionEnabled:YES];
//        }
//    }
//}
//
//- (void)setup {
//    _timeInterval = 3;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
//    [_timer fire];
//    _autoLoop = YES;
//    
//    _buttons = [[NSMutableArray alloc] init];
//    
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
//    _scrollView.delegate = self;
//    _scrollView.pagingEnabled = YES;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    [self addSubview:_scrollView];
//    
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width-100.0)/2.0, self.frame.size.height-30, 100, 30)];
//    [_pageControl setPageIndicatorTintColor:RGB(204, 204, 204)];
//    [_pageControl setCurrentPageIndicatorTintColor:RGB(229, 89, 89)];
//    //[_pageControl setValue:[UIImage imageNamed:@""] forKeyPath:@"pageImage"];
//    //[_pageControl setValue:[UIImage imageNamed:@""] forKeyPath:@"currentPageImage"];
//    [self addSubview:_pageControl];
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)dealloc {
//    if (_timer) {
//        [_timer invalidate];
//    }
//}
//
//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    
//    if (_scrollView) {
//        [_scrollView setFrame:frame];
//    }
//    if (_pageControl) {
//        [_pageControl setFrame:CGRectMake((frame.size.width-100.0)/2.0, frame.size.height-30, 100, 30)];
//    }
//    
//    NSUInteger count =  [_buttons count];
//    if (count > 0) {// 至少需要有一个元素
//        for (NSUInteger i = 0; i < count+2; i++) {
//            [_buttons[0] setFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
//        }
//    }
//}
//
//- (void)setImages:(NSArray<UIImage *> *)images {
//    if (images) {
//        NSUInteger count =  [images count];
//        if (count > 0) {// 至少需要有一个元素
//            [_buttons removeAllObjects];
//            for (NSUInteger i = 0; i < count+2; i++) {
//                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
//                [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//                if (i == 0) {
//                    [button setTag:count-1];
//                    [button setBackgroundImage:images.lastObject forState:UIControlStateNormal];
//                }else if (i == count+1) {
//                    [button setTag:0];
//                    [button setBackgroundImage:images.firstObject forState:UIControlStateNormal];
//                }else {
//                    [button setTag:i-1];
//                    [button setBackgroundImage:images[i-1] forState:UIControlStateNormal];
//                }
//                //[button setBackgroundColor:[UIColor randomColor]];
//                [_scrollView addSubview:button];
//                [_buttons addObject:button];
//            }
//            [_scrollView setContentSize:CGSizeMake(self.frame.size.width*(count+2), self.frame.size.height)];
//            [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
//            [_pageControl setNumberOfPages:count];
//            [_pageControl setCurrentPage:0];
//            
//            if (count == 1) {
//                [_pageControl setHidden:YES];
//                [_scrollView setScrollEnabled:NO];
//                [_timer setFireDate:[NSDate distantFuture]];
//            }else {
//                [_pageControl setHidden:NO];
//                [_scrollView setScrollEnabled:YES];
//                [_timer setFireDate:[NSDate distantPast]];
//            }
//        }
//    }
//}
//
//- (void)setImageNames:(NSArray<NSString *> *)imageNames {
//    if (imageNames) {
//        NSUInteger count =  [imageNames count];
//        if (count > 0) {// 至少需要有一个元素
//            [_buttons removeAllObjects];
//            for (NSUInteger i = 0; i < count+2; i++) {
//                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
//                [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//                if (i == 0) {
//                    [button setTag:count-1];
//                    [button setBackgroundImage:[UIImage imageNamed:imageNames.lastObject] forState:UIControlStateNormal];
//                }else if (i == count+1) {
//                    [button setTag:0];
//                    [button setBackgroundImage:[UIImage imageNamed:imageNames.firstObject] forState:UIControlStateNormal];
//                }else {
//                    [button setTag:i-1];
//                    [button setBackgroundImage:[UIImage imageNamed:imageNames[i-1]] forState:UIControlStateNormal];
//                }
//                
//                [_scrollView addSubview:button];
//                [_buttons addObject:button];
//            }
//            [_scrollView setContentSize:CGSizeMake(self.frame.size.width*(count+2), self.frame.size.height)];
//            [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
//            [_pageControl setNumberOfPages:count];
//            [_pageControl setCurrentPage:0];
//            
//            if (count == 1) {
//                [_pageControl setHidden:YES];
//                [_scrollView setScrollEnabled:NO];
//                [_timer setFireDate:[NSDate distantFuture]];
//            }else {
//                [_pageControl setHidden:NO];
//                [_scrollView setScrollEnabled:YES];
//                [_timer setFireDate:[NSDate distantPast]];
//            }
//        }
//    }
//}
//
//- (void)setImageUrls:(NSArray<NSString *> *)imageUrls {
//    if (imageUrls) {
//        NSUInteger count =  [imageUrls count];
//        if (count > 0) {// 至少需要有一个元素
//            [_buttons removeAllObjects];
//            for (NSUInteger i = 0; i < count+2; i++) {
//                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
//                [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//                if (i == 0) {
//                    [button setTag:count-1];
//                    [button setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageUrls.lastObject] placeholderImage:_placeholderImage];
//                }else if (i == count+1) {
//                    [button setTag:0];
//                    [button setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageUrls.firstObject] placeholderImage:_placeholderImage];
//                }else {
//                    [button setTag:i-1];
//                    [button setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageUrls[i-1]] placeholderImage:_placeholderImage];
//                }
//
//                [_scrollView addSubview:button];
//                [_buttons addObject:button];
//            }
//            [_scrollView setContentSize:CGSizeMake(self.frame.size.width*(count+2), self.frame.size.height)];
//            [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
//            [_pageControl setNumberOfPages:count];
//            [_pageControl setCurrentPage:0];
//            
//            if (count == 1) {
//                [_pageControl setHidden:YES];
//                [_scrollView setScrollEnabled:NO];
//                [_timer setFireDate:[NSDate distantFuture]];
//            }else {
//                [_pageControl setHidden:NO];
//                [_scrollView setScrollEnabled:YES];
//                [_timer setFireDate:[NSDate distantPast]];
//            }
//        }
//    }
//}
//
//- (void)setAutoLoop:(BOOL)autoLoop {
//    if (autoLoop) {
//        [_timer setFireDate:[NSDate distantPast]];
//    }else {
//        [_timer setFireDate:[NSDate distantFuture]];
//    }
//}
//
//- (void)setAutoLoopInterval:(NSTimeInterval)autoLoopInterval {
//    if (autoLoopInterval > 1) {
//        _timeInterval = autoLoopInterval;
//    }else {
//        _timeInterval = 1;
//    }
//}
//
//- (void)setShowPageControl:(BOOL)showPageControl {
//    [_pageControl setHidden:!_showPageControl];
//}
//
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSUInteger page = _scrollView.contentOffset.x/self.frame.size.width;
//    NSUInteger count =  [_buttons count];
//    if (page == 0) {
//        [_scrollView setContentOffset:CGPointMake(self.frame.size.width*(count-2), 0) animated:NO];
//        [_pageControl setCurrentPage:count-2];
//        return;
//    }
//    if (page == count-1) {
//        [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
//        [_pageControl setCurrentPage:0];
//        return;
//    }
//    [_pageControl setCurrentPage:page-1];
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end
