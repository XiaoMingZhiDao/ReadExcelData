//
//  MyTableViewCell.h
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfo;
@interface MyTableViewCell : UITableViewCell

/** cell数据 <姓名、性别、年龄> */
@property (nonatomic ,strong) UserInfo *info ;

@end
