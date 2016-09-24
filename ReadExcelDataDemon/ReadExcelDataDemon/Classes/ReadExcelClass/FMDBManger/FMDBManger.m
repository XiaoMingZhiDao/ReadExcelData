//
//  FMDBManger.m
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//  QQ:3465863957，如果你有好的建议，或者工程有bug，欢迎你反馈到本QQ,本人将尽快解决

#import "FMDBManger.h"

#import "UserInfo.h"

@implementation FMDBManger

MDJSingletonM(FMDBManger);

static FMDatabase *_sharedFMDB = nil;
/** “库”名 */
static NSString *const DB_NAME = @"ReadExcel.sqlite";
/** “表”名 */
static NSString *const DB_table1 = @"ExcelTable";

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _sharedFMDB = [FMDatabase databaseWithPath:[self getDataBaseFilePath]];
        [_sharedFMDB open]?MDJLog(@"数据库打开成功"):MDJLog(@"数据库打开失败");
        
        // 创建表
        [self createDataBaseTable:DB_table1];
    }
    return self;
}

// 获取路径
- (NSString *)getDataBaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:DB_NAME];
    MDJLog(@"path:%@",dbFilePath);
    
    return dbFilePath;
}

// 创建表
-(void)createDataBaseTable:(NSString *)name
{
    [_sharedFMDB open];
    [_sharedFMDB setShouldCacheStatements:YES];
    if(![_sharedFMDB tableExists:name])
    {
        NSString *sql;
        if ([name isEqualToString:DB_table1]){
            // 表1 对应的sql语句
            sql = [NSString stringWithFormat:@"CREATE TABLE %@(id INTEGER PRIMARY KEY, UserName VARCHAR,UserSex INTEGER,UserAge INTEGER default '0')",name];
        }
        
        BOOL flag = [_sharedFMDB executeUpdate:sql];
        MDJLog(@"database running...创建表:%@,result:%zd",name,flag);
    }
    [_sharedFMDB close];
}

-(void)deleteTableNamed:(NSString *)name{
    [_sharedFMDB open];
    
    if([_sharedFMDB tableExists:name])
    {
        if ([name isEqualToString:DB_table1]){
            [_sharedFMDB executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",DB_table1]];
        }
        
    }
    [_sharedFMDB close];
}

- (void)clearAllDataBase
{
    [_sharedFMDB open];
    
    [_sharedFMDB executeUpdate:[NSString stringWithFormat:@"delete from %@",DB_table1]];
    
    [_sharedFMDB close];
}

/***************************** 以下是数据库处理接口 *************************************/
// 插入用户信息
- (BOOL)insertUserInformationWithName:(NSString *)name sex:(NSNumber *)sex age:(NSNumber *)age
{
    [_sharedFMDB open];
    [_sharedFMDB setShouldCacheStatements:YES];
    
    NSString *sql =  @"INSERT INTO ExcelTable (UserName,UserSex,UserAge) VALUES(?,?,?);";
    BOOL flag = [_sharedFMDB executeUpdate:sql,name,sex,age];
    flag?MDJLog(@"用户信息插入成功"):MDJLog(@"用户信息插入失败");
    
    [_sharedFMDB close];
    return flag;
}

/**
 *  插入用户信息
 *  @pram   sql 数据库语句
 */
- (BOOL)insertUserInformationWithSql:(NSString *)sql{
    [_sharedFMDB open];
    [_sharedFMDB setShouldCacheStatements:YES];
    
    BOOL flag = [_sharedFMDB executeUpdate:sql];
    flag?MDJLog(@"用户信息插入成功"):MDJLog(@"用户信息插入失败");
    
    [_sharedFMDB close];
    return flag;
}

// 查询用户所有信息
-(NSArray *)getUserInfo
{
    [_sharedFMDB open];
    [_sharedFMDB setShouldCacheStatements:YES];
    
    FMResultSet *rs = [_sharedFMDB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",DB_table1]];
    
    NSMutableArray *infos = [NSMutableArray array];
    while ([rs next]) {
       
        UserInfo *info = [[UserInfo alloc] init];
        NSString *userName = [rs stringForColumn:@"UserName"];
        info.name = userName;
        
        NSNumber *userSex = [rs objectForColumnName:@"UserSex"];
        info.sex = userSex;
        
        NSNumber *userAge = [rs objectForColumnName:@"UserAge"];
        info.age = userAge;
        
        [infos addObject:info];
    }
    [_sharedFMDB close];
    return infos;
}

@end
