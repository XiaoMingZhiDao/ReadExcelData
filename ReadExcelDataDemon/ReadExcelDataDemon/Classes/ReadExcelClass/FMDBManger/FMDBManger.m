//
//  FMDBManger.m
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//  QQ:3465863957，如果你有好的建议，或者工程有bug，欢迎你反馈到本QQ,本人将尽快解决

#import "FMDBManger.h"

#import "UserInfo.h"

@interface FMDBManger ()
@property (nonatomic ,strong) NSMutableArray *failsArr;
@end

@implementation FMDBManger
- (NSMutableArray *)failsArr
{
    if (!_failsArr) {
        _failsArr = [NSMutableArray array];
    }
    return _failsArr;
}
MDJSingletonM(FMDBManger);

static FMDatabase *_sharedFMDB = nil;
/** “库”名 */
static NSString *const DB_NAME = @"ReadExcel.sqlite";
/** “表”名 */
static NSString *const DB_table1 = @"ExcelTable";
/** “字段1”名 */
static NSString *const DB_table_property1 = @"ForeignLanguage";
/** “字段2”名 */
static NSString *const DB_table_property2 = @"ChineseLanguage";
// ForeignLanguage ChineseLanguage   UserName UserSex
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
            sql = [NSString stringWithFormat:@"CREATE TABLE %@(id INTEGER PRIMARY KEY, %@ VARCHAR,%@ VARCHAR)",name,DB_table_property1,DB_table_property2];
        }
        
        BOOL flag = [_sharedFMDB executeUpdate:sql];
        MDJLog(@"database running...创建表:%@,result:%zd",name,flag);
    }
//    [_sharedFMDB close];
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
- (BOOL)insertUserInformationWithForeignLanguage:(NSString *)ForeignLanguage chineseLanguage:(NSNumber *)ChineseLanguage
{
    [_sharedFMDB open];
    
    [_sharedFMDB setShouldCacheStatements:YES];
    
    NSString *sql =[NSString stringWithFormat:@"INSERT INTO ExcelTable (%@,%@) VALUES(?,?);",DB_table_property1,DB_table_property2];
    BOOL flag = [_sharedFMDB executeUpdate:sql,ForeignLanguage,ChineseLanguage];
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
    
//    [_sharedFMDB close];
    return flag;
}

// 查询用户词典所有信息
-(NSArray *)getUserInfo
{
    [_sharedFMDB open];
    [_sharedFMDB setShouldCacheStatements:YES];
    
    FMResultSet *rs = [_sharedFMDB executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",DB_table1]];
    
    NSMutableArray *infos = [NSMutableArray array];
    while ([rs next]) {
       
        UserInfo *info = [[UserInfo alloc] init];
        NSString *ForeignLanguage = [rs stringForColumn:DB_table_property1];
        info.ForeignLanguage = ForeignLanguage;
        
        NSString *ChineseLanguage = [rs stringForColumn:DB_table_property2];
        info.ChineseLanguage = ChineseLanguage;
        
        [infos addObject:info];
    }
    [_sharedFMDB close];
    return infos;
}

    - (NSArray *)findDicWithKey:(NSString *)key
    {
        [_sharedFMDB open];
        [_sharedFMDB setShouldCacheStatements:YES];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT rowid, * FROM ExcelTable WHERE ForeignLanguage = '%@';",key];
        MDJLog(@"sql:%@",sql);
        
        FMResultSet *rs = [_sharedFMDB executeQuery:sql];
        
        NSMutableArray *infos = [NSMutableArray array];
        while ([rs next]) {
            UserInfo *info = [[UserInfo alloc] init];
            NSString *ForeignLanguage = [rs stringForColumn:DB_table_property1];
            info.ForeignLanguage = ForeignLanguage;
            
            NSString *ChineseLanguage = [rs stringForColumn:DB_table_property2];
            info.ChineseLanguage = ChineseLanguage;
            
            [infos addObject:info];

        }
        [_sharedFMDB close];
        return infos;
        
    }
@end
