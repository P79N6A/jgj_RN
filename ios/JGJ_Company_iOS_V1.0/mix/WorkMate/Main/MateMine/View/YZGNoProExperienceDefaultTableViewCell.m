//
//  YZGNoProExperienceDefaultTableViewCell.m
//  mix
//
//  Created by Tony on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGNoProExperienceDefaultTableViewCell.h"

@interface YZGNoProExperienceDefaultTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *ProExperienceLabel;

@end

@implementation YZGNoProExperienceDefaultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    NSMutableAttributedString *contentStr = [self.ProExperienceLabel.attributedText mutableCopy];
    [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2, 6)];
    [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(2, 6)];

    self.ProExperienceLabel.attributedText = contentStr;
}

- (IBAction)addProExperienceBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(NoProExperienceAddProExperience:)]) {
        [self.delegate NoProExperienceAddProExperience:self];
    }
}

@end
