//
//  JGJSurePayView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickSurePayButtondelegate<NSObject>

-(void)clickSurePayButton;

@end

@interface JGJSurePayView : UIView

@property (nonatomic, strong)UILabel *privilegeLable;

@property (nonatomic, strong)UILabel *salaryLable;

@property (nonatomic, strong)UIButton *surePayButton;

@property (strong, nonatomic) id <clickSurePayButtondelegate>delegate;

@property (strong ,nonatomic)JGJOrderListModel *orderListModel;

@property (assign ,nonatomic)BOOL orderDetail;//由于后面改了需求 所以这里用来盘算是不是要隐藏优惠金额

-(void)closeSurePayButtonUserinterface;

-(void)openSurePayButtonUserinterface;

-(void)setPriVteNum:(NSString *)p_num andSalary:(NSString *)salary;

-(void)sureorderList;

@end
