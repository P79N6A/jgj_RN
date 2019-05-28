//
//  JGJSyncProlistCell.m
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSyncProlistCell.h"

@interface JGJSyncProlistCell()
@property (weak, nonatomic) IBOutlet UILabel *proname;
@property (weak, nonatomic) IBOutlet UIButton *closeProlistBtn;

@end

@implementation JGJSyncProlistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.proname.textColor = AppFont333333Color;
    self.proname.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    [self.closeProlistBtn.layer setLayerCornerRadius:2.5];
    [self.closeProlistBtn.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:2.5];
    self.closeProlistBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    [self.closeProlistBtn setTitle:@"关闭同步" forState:UIControlStateNormal];
}
+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSyncProlistCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSyncProlistCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSyncProlistModel:(JGJSyncProlistModel *)syncProlistModel {
    _syncProlistModel = syncProlistModel;
    self.proname.text = syncProlistModel.pro_name;
}

- (IBAction)closeProlistButtonPressed:(UIButton *)sender {
    
    if (self.prolistSynCloseBlock) {
        self.prolistSynCloseBlock(self.syncProlistModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
