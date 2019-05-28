//
//  JGJPoorBillTableViewCell.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJPoorBillTopInfoView.h"
@class JGJPoorBillTableViewCell;

typedef void(^JGJPoorBillTableViewCellBlock)(JGJPoorBillTableViewCell *cell);

@protocol JGJPoorBillTableViewCellDelegate <NSObject>
-(void)ClickPoorBillLookForBtnAndIndex:(NSIndexPath *)indexpath;
-(void)ClickPoorBillSureBtnAndIndex:(NSIndexPath *)indexpath cell:(JGJPoorBillTableViewCell *)cell;

@end;
@interface JGJPoorBillTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lineLable;
@property (strong, nonatomic) IBOutlet UILabel *proLable;
@property (strong, nonatomic) IBOutlet UIButton *lookfoorButton;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;//被记账人
@property (strong, nonatomic) IBOutlet UILabel *recordPeople;//记账人
@property (strong, nonatomic) IBOutlet UILabel *worktimeLable;
@property (strong, nonatomic) IBOutlet UILabel *overTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *salaryTitleLable;
@property (strong, nonatomic) IBOutlet UILabel *manHourTPL;
@property (strong, nonatomic) IBOutlet UILabel *overTPL;
@property (nonatomic, strong) JGJPoorBillListDetailModel *PoorBillModel;
@property (strong, nonatomic) id<JGJPoorBillTableViewCellDelegate> delegate;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *workCenterConstance;
@property (nonatomic, assign) BOOL showWork;

@property (copy, nonatomic) JGJPoorBillTableViewCellBlock poorBillTableViewCellBlock;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageCenterY;
@property (weak, nonatomic) IBOutlet UIImageView *remarkImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkImageCenterY;

//显示类型
@property (nonatomic, assign) NSInteger showType;
@property (weak, nonatomic) IBOutlet JGJPoorBillTopInfoView *topInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineViewConstain;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@end
