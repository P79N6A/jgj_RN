//
//  JGJNewAddProlistCell.m
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewAddProlistCell.h"

@interface JGJNewAddProlistCell ()
@property (weak, nonatomic) IBOutlet UIButton *multiSelectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *proName;

@end

@implementation JGJNewAddProlistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.multiSelectedBtn.layer setLayerCornerRadius:TYGetViewW(self.multiSelectedBtn) / 2.0];
    self.proName.textColor = AppFont333333Color;
    self.proName.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    [self.multiSelectedBtn setImage:PNGIMAGE(@"MultiSelected") forState:UIControlStateSelected];
    [self.multiSelectedBtn setImage:PNGIMAGE(@"EllipseIcon") forState:UIControlStateNormal];

}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJNewAddProlistCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJNewAddProlistCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSyncProlistModel:(JGJSyncProlistModel *)syncProlistModel {
    _syncProlistModel = syncProlistModel;
    self.proName.text = syncProlistModel.pro_name;
    self.multiSelectedBtn.selected = syncProlistModel.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
