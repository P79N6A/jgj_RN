//
//  YZGMateShowpoorTableViewCell.m
//  mix
//
//  Created by Tony on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateShowpoorTableViewCell.h"
#import "CustomView.h"

@interface YZGMateShowpoorTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet LineView *bottomLineView;

//constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLabelLayoutXRation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelLayoutRation;

@end

@implementation YZGMateShowpoorTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

#pragma markk - getter
- (CGFloat )centerXRation{
    return self.centerLabelLayoutXRation.multiplier;
}

- (CGFloat)rightXRation{
    return self.rightLabelLayoutRation.multiplier;
}

- (void)setIsLastCell:(BOOL)isLastCell{
    _isLastCell = isLastCell;
    self.bottomLineView.hidden = _isLastCell;
    
}
#pragma mark - setter 设置三个label的内容
- (void)setFirstTitle:(id )firstTitle secondTitle:(id )secondTitle thirdTitle:(id)thirdTitle{
    if ([firstTitle isKindOfClass:[NSString class]]) {
        self.firstLabel.text  = firstTitle;
    }else{
        self.firstLabel.attributedText = firstTitle;
    }

    if ([secondTitle isKindOfClass:[NSString class]]) {
        self.secondLabel.text  = secondTitle;
    }else{
        self.secondLabel.attributedText = secondTitle;
    }
    
    
    if ([thirdTitle isKindOfClass:[NSString class]]) {
        self.thirdLabel.text  = thirdTitle;
    }else{
        self.thirdLabel.attributedText = thirdTitle;
    }
}

@end
