//
//  JGJTableviewHeaderView.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordBillDetailContractorHeaderTypeView.h"
@interface JGJTableviewHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)  UIImageView *leftImageView;
@property (strong, nonatomic)  UIImageView *rightmageView;
@property (strong, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *titleTopLable;
@property (strong, nonatomic) IBOutlet UILabel *amountLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;

@property (nonatomic, assign) NSInteger contractorType;
- (void)addHeaderView;
@property (nonatomic, strong) JGJRecordBillDetailContractorHeaderTypeView *contractorHeader;

@end
