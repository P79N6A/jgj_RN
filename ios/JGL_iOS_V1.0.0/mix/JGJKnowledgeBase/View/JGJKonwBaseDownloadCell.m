//
//  JGJKonwBaseDownloadCell.m
//  mix
//
//  Created by yj on 2018/7/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJKonwBaseDownloadCell.h"

#import "UILabel+GNUtil.h"

#import "NSDate+Extend.h"

@interface JGJKonwBaseDownloadCell()

@property (weak, nonatomic) IBOutlet UIImageView *fileIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLable;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

@implementation JGJKonwBaseDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.fileNameLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 103;
    
    self.delBtn.hidden = YES;
}

- (void)setKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {
    
    _knowBaseModel = knowBaseModel;
    
    NSString *fileIcon = ![knowBaseModel.file_type isEqualToString:@"dir"] ? @"knowBase_file_icon" : @"knowBase_dir_icon";
    
    self.fileIconImageView.image = [UIImage imageNamed:fileIcon];
    
    self.fileNameLable.text = _knowBaseModel.file_name;
    
    NSString *date = [NSDate dateTimesTampToString:knowBaseModel.downloaddate format:@"yyyy-MM-dd"];
    
    self.time.text = date;
    
    [self.delBtn setImage:[UIImage imageNamed:knowBaseModel.isSelected ? @"MultiSelected" : @"EllipseIcon"] forState:UIControlStateNormal];
    
    [self.fileNameLable markText:self.searchValue withColor:AppFontEB4E4EColor];
    
}

- (void)setIsBatchDel:(BOOL)isBatchDel {
    
    _isBatchDel = isBatchDel;
    
    self.delBtn.hidden = !isBatchDel;
    
    CGFloat w = isBatchDel ? 40 : 0;
    
    [self.delBtn mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(w);
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
