//
//  YZGRecordWorkInputInfoTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkBaseInfoTableViewCell.h"


@interface YZGRecordWorkInputInfoTableViewCell : YZGRecordWorkBaseInfoTableViewCell

- (void)setUnitLabel:(NSString *)unit color:(UIColor *)unitColor;
- (void)setPlaceholderColor:(UIColor *)placeholderColor setDetailColor:(UIColor *)detailColor;
@end
