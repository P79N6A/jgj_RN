//
//  YZGRecordWorkNextVcTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkBaseInfoTableViewCell.h"

@interface YZGRecordWorkNextVcTableViewCell : YZGRecordWorkBaseInfoTableViewCell
- (void)setRightImageView:(UIImageView *)rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTFLayoutL;
@end
