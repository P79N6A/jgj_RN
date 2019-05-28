//
//  JGJSystemNoticeTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJSystemNoticeTableViewCellDelegate <NSObject>

- (void)clickHedPickBtn:(NSInteger)indexpath;

- (void)clickreplyUserNameLable:(NSInteger)indepath;

@end
@interface JGJSystemNoticeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *departLine;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property(strong ,nonatomic)JGJAllNoticeModel *model;
@property (strong, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UILabel *namelable;
@property (strong, nonatomic) IBOutlet UILabel *replylable;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIView *subContent;
@property (strong, nonatomic) IBOutlet UIImageView *contenImage;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstance;

@property (strong, nonatomic) id <JGJSystemNoticeTableViewCellDelegate>delegate;
@end
