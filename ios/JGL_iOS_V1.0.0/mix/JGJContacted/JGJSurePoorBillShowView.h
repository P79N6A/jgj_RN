//
//  JGJSurePoorBillShowView.h
//  mix
//
//  Created by Tony on 2017/10/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGMateShowpoorModel.h"
#import "YZGGetBillModel.h"

@protocol JGJSurePoorBillShowViewDelegate <NSObject>

-(void)JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model;

-(void)JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:(NSIndexPath *)indexpath andTPLmodel:(YZGGetBillModel *)model;

@end
@interface JGJSurePoorBillShowView : UIView
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toptitleConstance;

@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) IBOutlet UIImageView *poorImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) IBOutlet UILabel *datelable;

@property (strong, nonatomic) IBOutlet UILabel *recorderLable;

@property (strong, nonatomic) IBOutlet UILabel *recordedLable;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UIButton *modifyButton;

@property (strong, nonatomic) IBOutlet UIButton *agreeButton;

@property (strong, nonatomic)  JGJPoorBillListDetailModel *mateWorkitemsItems;
@property (strong, nonatomic) IBOutlet UILabel *accountTypeLable;

@property (strong, nonatomic)  NSArray *titleArr;
/*
*是否显示我记的
*/
@property (assign, nonatomic)  BOOL ismine;


@property (strong, nonatomic)  UIButton *placeView;

@property (strong, nonatomic)  NSIndexPath *indexpath;

@property (strong, nonatomic) YZGGetBillModel *yzgGetBillModel;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topCenterConcetance;

@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic)  YZGMateShowpoorModel *yzgMateShowpoorModel;

@property (strong, nonatomic)  id <JGJSurePoorBillShowViewDelegate> delegate;


+ (void)showPoorBillAndModel:(JGJPoorBillListDetailModel*)model AndDelegate:(id)delegate andindexPath:(NSIndexPath *)indextpath andHidenismine:(BOOL)ismine;

- (void)initTableView;

+ (void)removeView;
@end
