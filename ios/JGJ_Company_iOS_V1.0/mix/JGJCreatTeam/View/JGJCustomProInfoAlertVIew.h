//
//  JGJCustomProInfoAlertVIew.h
//  mix
//
//  Created by yj on 16/10/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCustomProInfoAlertVIew : UIView
@property (nonatomic, copy)void (^confirmButtonBlock) (void);
@property (nonatomic, copy)void (^cancelButtonBlock) (void);
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
+ (JGJCustomProInfoAlertVIew *)alertViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel;
@end
