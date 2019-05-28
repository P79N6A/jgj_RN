//
//  JGJSynProDefaultCell.m
//  mix
//
//  Created by yj on 16/10/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynProDefaultCell.h"

@interface JGJSynProDefaultCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *desButton;

@end

@implementation JGJSynProDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.lineView.backgroundColor = self.desButton.titleLabel.textColor;
    self.desButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
}


+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJSynProDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSynProDefaultCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)handleButtonClickedAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(handleSynProDefaultCellAction:)]) {
        [self.delegate handleSynProDefaultCellAction:self];
    }
}


@end
