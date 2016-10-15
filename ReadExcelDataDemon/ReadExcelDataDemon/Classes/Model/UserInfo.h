//
//  UserInfo.h
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/** 外文 */
@property (nonatomic ,copy) NSString *ForeignLanguage;
/** 中文 */
@property (nonatomic ,copy) NSString *ChineseLanguage;

@end
