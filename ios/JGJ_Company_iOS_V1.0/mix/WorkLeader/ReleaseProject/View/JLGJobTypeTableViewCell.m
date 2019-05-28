//
//  JLGJobTypeTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGJobTypeTableViewCell.h"
#import "CALayer+SetLayer.h"

@interface JLGJobTypeTableViewCell ()


@property (weak, nonatomic) IBOutlet UIView *poitView;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointViewLTConst;
@end

@implementation JLGJobTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.pointViewLConstFloat = 10;
    self.poitView.backgroundColor = JGJMainColor;

    self.selectedLabel.textColor = AppFont999999Color;
    [self.poitView.layer setLayerCornerRadius:TYGetViewW(self.poitView)/2];
}

- (void)setChangeStatus:(BOOL)Status{
    if (Status) {
        self.selectedImage.hidden = NO;
        self.titleLabel.textColor = JGJMainColor;
    }else{
        self.selectedImage.hidden = YES;
        self.titleLabel.textColor = TYColorHex(0x5f5f5f);
    }
    self.selectedLabel.hidden = self.selectedImage.hidden;
}

- (void)setChangeSingleStatus:(BOOL)Status{
    if (Status) {
        self.poitView.hidden = NO;
        self.titleLabel.textColor = JGJMainColor;
        self.pointViewLTConst.constant = self.pointViewLConstFloat;
    }else{
        self.poitView.hidden = YES;
        self.titleLabel.textColor = TYColorHex(0x5f5f5f);
        self.pointViewLTConst.constant = 0;
    }
}
@end
