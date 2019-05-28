//
//  JGJRecordBillWaterHeaderView.h
//  mix
//
//  Created by Tony on 2017/10/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRecordBillWaterHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *incomLable;
@property (strong, nonatomic) IBOutlet UILabel *expendLable;
@property (strong, nonatomic) IBOutlet UILabel *billTotalNumLable;
@property (strong, nonatomic) IBOutlet UILabel *amountLable;
-(void)setAmount:(CGFloat)amount income:(CGFloat)income expend:(CGFloat)expend andcloseAnAccount:(CGFloat)Account;

@end
