//
//  YZGGetIndexRecordFirstTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGGetIndexRecordFirstTableViewCell : UITableViewCell
- (void)setAmount:(CGFloat)amount income:(CGFloat )income expend:(CGFloat )expend;
//新加结算总和
- (void)setAmount:(CGFloat)amount income:(CGFloat )income expend:(CGFloat )expend andcloseAnAccount:(CGFloat)Account;
@property (strong, nonatomic) IBOutlet UILabel *billTotalNumLable;

@end
