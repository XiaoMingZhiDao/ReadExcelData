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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 数据源 */
@property (nonatomic ,strong) NSMutableArray *cells ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

// 写入数据
- (IBAction)writeDataClick:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@".txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray <NSString *> *dataArray = [content componentsSeparatedByString:@";"];
    FMDBManger *mgr = [FMDBManger sharedFMDBManger];
    
    for (NSInteger i = 0; i < dataArray.count - 1; i++) {
        [mgr insertUserInformationWithSql:dataArray[i]];
    }
    
    [MDJStatusBarHUD showSuccess:[NSString stringWithFormat:@"成功插入数据 %zd 条",dataArray.count]];
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


@end
