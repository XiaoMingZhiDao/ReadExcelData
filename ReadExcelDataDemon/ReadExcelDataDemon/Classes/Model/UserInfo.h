//
//  UserInfo.h
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/** 姓名 */
@property (nonatomic ,copy) NSString *name;
/** 性别 */
@property (nonatomic ,strong) NSNumber *sex;
/** 年龄 */
@property (nonatomic ,strong) NSNumber *age;

@end
