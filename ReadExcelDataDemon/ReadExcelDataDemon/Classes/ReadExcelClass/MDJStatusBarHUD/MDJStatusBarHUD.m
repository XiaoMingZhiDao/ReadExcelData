//
//  MDJStatusBarHUD.m
//  StatusBarHUD
//
//  Created by MDJ on 16/9/20.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "MDJStatusBarHUD.h"
#define MDJMessageFont [UIFont systemFontOfSize:12]

@implementation MDJStatusBarHUD

/** 消息停留时间 */
static CGFloat const MDJMessageDuration = 2.0 ;

/** 消息显示、隐藏时间 */
static CGFloat const MDJAnimationDuration = 0.25 ;

/** 全局窗口 */
static  UIWindow *window_;

/** 定时器 */
static NSTimer *timer_;

// 显示窗口
+ (void)showWindow
{
    // frame 数据
    CGFloat windowH = 20;
    CGRect frame = CGRectMake(0, -windowH, [UIScreen mainScreen].bounds.size.width, windowH);
    
    // 显示窗口
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.backgroundColor = [UIColor blackColor];
     window_.frame = frame;
    window_.hidden = NO;
    
    // 动画
    frame.origin.y = 0;
    [UIView animateWithDuration:MDJAnimationDuration animations:^{
        window_.frame = frame;
    }];
}

/**
 *  显示成功信息
 *  @parm   msg 文字
 *  @parm   image 图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image;
{
    [timer_ invalidate];
    
    // 显示窗口
    [self showWindow];
    
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = MDJMessageFont;
    [button setTitle:msg forState:UIControlStateNormal];
    if (image) {// 如果有图片
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button setImage:image forState:UIControlStateNormal];
    }
    
    button.frame = window_.bounds;
    [window_ addSubview:button];
    
    // 定时器
    timer_ = [NSTimer scheduledTimerWithTimeInterval:MDJMessageDuration target:self selector:@selector(hide) userInfo:nil repeats:nil];
}

/**
 *  显示成功信息
 */
+ (void)showSuccess:(NSString *)msg{
    [self showMessage:msg image:[UIImage imageNamed:@"MDJStatusBarHUD.bundle/success"]];
}

/**
 *  显示失败信息
 */
+ (void)showError:(NSString *)msg{
    [self showMessage:msg image:[UIImage imageNamed:@"MDJStatusBarHUD.bundle/error"]];
}


/**
 *  显示正在加载信息
 */
+ (void)showLoading:(NSString *)msg{
    // 停止定时器
    [timer_ invalidate];
    timer_ = nil;
    
    // 显示窗口
    [self showWindow];
    
    // 添加文字
    UILabel *label = [[UILabel alloc] init];
    label.font = MDJMessageFont;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = window_.bounds;
    
    [window_ addSubview:label];
    
    // 添加圆圈
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating];
    
    // 文字宽度
    CGFloat msgW = [msg sizeWithAttributes:@{NSFontAttributeName : MDJMessageFont}].width;
    CGFloat centerX = (window_.frame.size.width - msgW) * 0.5 - 20;
    CGFloat centerY = window_.frame.size.height * 0.5;
    indicatorView.center = CGPointMake(centerX, centerY);
    
    [window_ addSubview:indicatorView];
}

/**
 *  显示普通文字
 */
+ (void)showMessage:(NSString *)msg
{
    [self showLoading:msg];
}

/**
 *  隐藏控件
 */
+ (void)hide{
    
    [UIView animateWithDuration:MDJAnimationDuration animations:^{
        CGRect frame = window_.frame;
        frame.origin.y = - frame.size.height;
        window_.frame = frame;
    } completion:^(BOOL finished) {
        window_ = nil;
        timer_ = nil;
    }];
}









@end
