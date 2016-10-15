//
//  FMDBManger.h
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//  QQ:3465863957，如果你有好的建议，或者工程有bug，欢迎你反馈到本QQ,本人将尽快解决

#ifdef DEBUG
#define MDJLog(...) NSLog(__VA_ARGS__)
#else 
#define MDJLog(...)
#endif

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "Singleton.h"


@interface FMDBManger : NSObject
/** 单例，返回 FMDBManger */
MDJSingletonH(FMDBManger);


- (BOOL)insertUserInformationWithForeignLanguage:(NSString *)ForeignLanguage chineseLanguage:(NSNumber *)ChineseLanguage;
/**
 *  插入用户信息
 *  @pram   sql 数据库语句
 */
- (BOOL)insertUserInformationWithSql:(NSString *)sql;

/**
 *  获得用户信息
 */
-(NSArray *)getUserInfo;

/**
 *  清除数据库
 */
- (void)clearAllDataBase;
   
/**
 *  查找某个单词
 */
- (NSArray *)findDicWithKey:(NSString *)key;
@end
