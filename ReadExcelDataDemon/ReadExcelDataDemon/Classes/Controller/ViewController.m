//
//  ViewController.m
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//  QQ:3465863957，如果你有好的建议，或者工程有bug，欢迎你反馈到本QQ,本人将尽快解决

#import "ViewController.h"
#import "FMDBManger.h"
#import "MyTableViewCell.h"
#import "MDJStatusBarHUD.h"

#define DeskTop // 数据库路径写入桌面就是DeskTop ，否则写成其他

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据源 */
@property (nonatomic ,strong) NSMutableArray *cells ;
/** 展示读取的数据 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 用户搜索词 */
@property (weak, nonatomic) IBOutlet UITextField *keyField;

@end

@implementation ViewController
- (NSMutableArray *)cells
{
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    
}

static NSString *const TxtName = @"abcd";
static long long SuccessFlag = 0;
static long long FailFlag = 0;
// 写入数据
- (IBAction)writeDataClick:(UIButton *)sender {
    // 数据源
    NSString *path = [[NSBundle mainBundle] pathForResource:TxtName ofType:@".txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray <NSString *> *dataArray = [content componentsSeparatedByString:@";"];
    FMDBManger *mgr = [FMDBManger sharedFMDBManger];
    
    // 插入语句
    for (NSInteger i = 0; i < dataArray.count - 1; i++) {
        BOOL flag = [mgr insertUserInformationWithSql:dataArray[i]];
        if (flag) {
            SuccessFlag ++;
        }else{
            FailFlag ++;
        }
    }
    
    [MDJStatusBarHUD showSuccess:[NSString stringWithFormat:@"成功插入数据 %zd 条",SuccessFlag]];
    
    MDJLog(@"成功：%zd;失败:%zd",SuccessFlag,FailFlag);
}

// 读取数据
- (IBAction)readDataClick:(UIButton *)sender {
    FMDBManger *mgr = [FMDBManger sharedFMDBManger];
    NSArray *cells = [mgr getUserInfo];
    [self.cells removeAllObjects];
    [self.cells addObjectsFromArray:cells];
    NSString *msg = nil;
    if(cells.count){
        msg = [NSString stringWithFormat:@"成功加载数据%zd条",cells.count];
    }else{
        msg = [NSString stringWithFormat:@"无可加载数据，请先写入数据"];
    }
    [MDJStatusBarHUD showSuccess:msg];
    [self.tableView reloadData];
}

// 清除数据
- (IBAction)clearDataClick:(UIButton *)sender {
    // 数据库清除
    FMDBManger *mgr = [FMDBManger sharedFMDBManger];
    [mgr clearAllDataBase];
    
    // 缓存清除
    self.cells = nil;
    [MDJStatusBarHUD showSuccess:@"所有数据清除完"];
    SuccessFlag = 0;
    
    [self.tableView reloadData];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.info = self.cells[indexPath.row];
    return cell;
}
    
- (IBAction)findSmoeKey:(UIButton *)sender {
    
    FMDBManger *mgr = [FMDBManger sharedFMDBManger];
    NSString *key = (self.keyField.text.length > 0)?self.keyField.text: @"чудовище";
    NSArray *cells = [mgr findDicWithKey:key];
    [self.cells removeAllObjects];
    [self.cells addObjectsFromArray:cells];
    NSString *msg = nil;
    if(cells.count){
        msg = [NSString stringWithFormat:@"成功加载数据%zd条",cells.count];
    }else{
        msg = [NSString stringWithFormat:@"无可加载数据，请先写入数据"];
    }
    [MDJStatusBarHUD showSuccess:msg];
    [self.tableView reloadData];

    
}
@end
