//
//  JGJCheckAllMemberCell.m
//  mix
//
//  Created by yj on 2018/3/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckAllMemberCell.h"

@interface JGJCheckAllMemberCell ()

@property (weak, nonatomic) IBOutlet UIButton *desButton;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@end

@implementation JGJCheckAllMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setOffset:(CGFloat)offset {
    
    _offset = offset;
    
    self.desButton.imageEdgeInsets = UIEdgeInsetsMake(offset+2, 192, 2, -20);
    
    self.desButton.titleEdgeInsets = UIEdgeInsetsMake(offset, 0, 0, 0);
    
}

- (void)setDes:(NSString *)des {
    
    _des = des;
        
    self.desLable.text = _des;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
