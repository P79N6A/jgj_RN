//
//  JGJContactsDetailCallCell.m
//  mix
//
//  Created by yj on 16/6/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJContactsDetailCallCell.h"
#import "TYPhone.h"
@interface JGJContactsDetailCallCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telPhone;
@property (weak, nonatomic) IBOutlet UIView *containInfoView;

@end
@implementation JGJContactsDetailCallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.containInfoView.layer setLayerBorderWithColor:[UIColor whiteColor] width:1 radius:3.0];
    self.containInfoView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = AppFontf7f7f7Color;
    self.name.textColor = AppFont333333Color;
    self.telPhone.textColor = AppFont333333Color;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJContactsDetailCallCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        return [[[NSBundle mainBundle] loadNibNamed:@"JGJContactsDetailCallCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setFindResultModel:(FindResultModel *)findResultModel {
    _findResultModel = findResultModel;
    self.name.text = findResultModel.fmname;
    self.telPhone.text = findResultModel.telph;
}

- (IBAction)callButtonPressed:(UIButton *)sender {
    
}

@end
