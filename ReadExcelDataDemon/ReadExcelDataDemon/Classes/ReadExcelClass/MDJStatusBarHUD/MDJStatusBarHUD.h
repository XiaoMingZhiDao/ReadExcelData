//
//  MDJStatusBarHUD.h
//  StatusBarHUD
//
//  Created by MDJ on 16/9/20.
//  Copyright © 2016年 MDJ. All rights reserved.
//  1.0.0

#import <UIKit/UIKit.h>

@interface MDJStatusBarHUD : NSObject

/**
 *  显示普通文字
 *  @parm   msg 文字
 *  @parm   image 图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image;
/**
 *  显示普通文字
 *  @parm   msg 文字
 */
+ (void)showMessage:(NSString *)msg;

/**
 *  显示成功信息
 */
+ (void)showSuccess:(NSString *)msg;

/**
 *  显示失败信息
 */
+ (void)showError:(NSString *)msg;

/**
 *  显示正在加载信息
 */
+ (void)showLoading:(NSString *)msg;

/**
 *  隐藏控件
 */
+ (void)hide;

@end
