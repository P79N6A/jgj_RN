//
//  JLGDefaultTableViewCell.m
//  mix
//
//  Created by jizhi on 15/12/28.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGDefaultTableViewCell.h"
@interface JLGDefaultTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UILabel *defautTitle;
@property (weak, nonatomic) IBOutlet UILabel *defaultDetailTitle;
@end
@implementation JLGDefaultTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDefaultImage:(UIImage *)defaultImage defautTitle:(NSString *)defautTitle defaultDetailTitle:(NSString *)defaultDetailTitle {
    if (defaultImage == nil) {
        self.defaultImageView.hidden = YES;
    } else {
        self.defaultImageView.hidden = NO;
        self.defaultImageView.image = defaultImage;
    }
    if ((defautTitle == nil || defautTitle.length == 0)) {
        self.defautTitle.hidden = YES;
    } else {
        self.defautTitle.hidden = NO;
        self.defautTitle.text = defautTitle;
    }
    
    if ((defaultDetailTitle == nil || defaultDetailTitle.length == 0)) {
        self.defaultDetailTitle.hidden = YES;
    } else {
        self.defaultDetailTitle.hidden = NO;
        self.defaultDetailTitle.text = defautTitle;
    }
}

@end
