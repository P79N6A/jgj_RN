//
//  YZGRecordWorkInputInfoTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkInputInfoTableViewCell.h"

@interface YZGRecordWorkInputInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (strong,nonatomic) UIColor *detailColor;
@property (strong,nonatomic) UIColor *placeholderColor;

@end

@implementation YZGRecordWorkInputInfoTableViewCell

- (void)setUnitLabel:(NSString *)unit color:(UIColor *)unitColor{
    if (unit) self.unitLabel.text = unit;
    if (unitColor) self.unitLabel.textColor = unitColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor setDetailColor:(UIColor *)detailColor{
    if (placeholderColor) self.placeholderColor = placeholderColor;
    if (detailColor) self.detailColor = detailColor;
}

- (void)setDetailColor:(UIColor *)detailColor{
    if (detailColor) self.detailTF.textColor = detailColor;
}
@end
