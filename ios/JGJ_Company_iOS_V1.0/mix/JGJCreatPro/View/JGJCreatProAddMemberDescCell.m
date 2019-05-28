//
//  JGJCreatProAddMemberDescCell.m
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCreatProAddMemberDescCell.h"
#import "UILabel+GNUtil.h"
@interface JGJCreatProAddMemberDescCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation JGJCreatProAddMemberDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineViewH.constant = 0.5;
    self.rightLineViewH.constant = 0.5;
}
+ (CGFloat)creatProAddMemberDescCellHeight {
    return 140;
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJCreatProAddMemberDescCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJCreatProAddMemberDescCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setProDecModel:(JGJCreatProDecModel *)proDecModel {
    _proDecModel = proDecModel;
    self.descLable.text = _proDecModel.desc;
    self.titleLable.text = _proDecModel.title;
    [self.descLable setAttributedText:self.descLable.text lineSapcing:5.0 textAlign:NSTextAlignmentLeft];
    self.titleLableCenterX.constant = -10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
