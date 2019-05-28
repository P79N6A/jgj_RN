//
//  JGJBillEditProNameTableViewCell.m
//  mix
//
//  Created by yj on 16/7/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBillEditProNameTableViewCell.h"
#import "UIView+GNUtil.h"
#import "UIButton+JGJUIButton.h"
@interface JGJBillEditProNameTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteIconW;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modifyButtonW;

@end
@implementation JGJBillEditProNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.modifyButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:2.5];
    self.modifyButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    self.proName.textColor = AppFont333333Color;
    self.proName.font = [UIFont systemFontOfSize:AppFont28Size];
    [self.modifyButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.deleteButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
}

- (void)setProNameModel:(JGJBillEditProNameModel *)proNameModel {
    _proNameModel = proNameModel;
    self.proName.text = proNameModel.name;
    if (proNameModel.isDelete) {
        self.modifyButton.hidden = YES;
        self.deleteButton.hidden = NO;
        self.deleteIconW.constant = 33.0;

        self.modifyButtonW.constant = 0;
        
    } else {
        
        self.modifyButton.hidden = NO;
        self.deleteButton.hidden = YES;
        self.deleteIconW.constant = 0.0;

        self.modifyButtonW.constant = 40;
        
    }
    
    if ([_proNameModel.proId isEqualToString:@"0"]) {
        
        self.modifyButton.hidden = YES;
    }else {
        
        self.modifyButton.hidden = NO;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ProNameCell";
    JGJBillEditProNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJBillEditProNameTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//修改项目名按下
- (IBAction)editProNameButtonPressed:(UIButton *)sender {
    if (self.editProNameBlock) {
        self.editProNameBlock(self.proNameModel);
    }
}

@end
