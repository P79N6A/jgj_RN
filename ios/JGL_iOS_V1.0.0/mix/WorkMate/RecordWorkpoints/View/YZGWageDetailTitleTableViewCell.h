//
//  YZGWageDetailTitleTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGWageDetailTitleTableViewCell : UITableViewCell

- (void)setLeftText:(NSString *)leftText;

- (void)setMiddleText:(NSString *)middleText;

- (void)setRightText:(NSString *)rightText;

- (void)setLeftText:(NSString *)leftText middleText:(NSString *)middleText rightText:(NSString *)rightText;

-(void)setLeftLabelLayoutLConstraint:(CGFloat )constraint;

-(void)setRighttLabelLayoutRConstraint:(CGFloat )constraint;

-(void)setMiddleLabelLayoutCenterXConstraint:(CGFloat )constraint;

- (void)setLeftConstraint:(CGFloat )leftConstraint middleConstraint:(CGFloat )middleConstraint rightConstraint:(CGFloat )rightConstraint;
@end
