//
//  JGJCustomBottomCell.h
//  JGJCompany
//
//  Created by yj on 2017/5/2.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJCustomBottomCell;

@protocol JGJCustomBottomCellDelegate <NSObject>

@optional

- (void)customBottomCellButtonPressed:(JGJCustomBottomCell *)cell;

@end

@interface JGJCustomBottomCell : UITableViewCell

@property (nonatomic, weak) id <JGJCustomBottomCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end
