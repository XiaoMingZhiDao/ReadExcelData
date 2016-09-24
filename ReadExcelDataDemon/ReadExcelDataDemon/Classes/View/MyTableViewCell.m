//
//  MyTableViewCell.m
//  ReadDataFromExcel
//
//  Created by MDJ on 16/9/23.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UserInfo.h"

@interface MyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(UserInfo *)info
{
    _info = info;
    
    self.nameLabel.text = info.name;
    self.sexLabel.text = [info.sex integerValue]==1?@"男":@"女";
    self.ageLabel.text = [NSString stringWithFormat:@"%@ 岁",info.age];
    
}
@end
