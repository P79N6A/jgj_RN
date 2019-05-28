//
//  JLGAuthorizationViewController.h
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  注册填的个人信息

#import <UIKit/UIKit.h>
//子cell
#import "JLGPickerView.h"
#import "JLGCityPickerView.h"
#import "JLGDatePickerView.h"
#import "JLGRegisterSexTableViewCell.h"
#import "JLGRegisterInfoTableViewCell.h"
#import "JLGRegisterClickTableViewCell.h"

//Controller
#import "JLGProjectTypeViewController.h"

//tool
#import "TYFMDB.h"
#import "TYShowMessage.h"
#import "CALayer+SetLayer.h"
#import "UITableViewCell+Extend.h"

#define tableViewHeadHeight 33.0
#define tableViewCellHeight 44.0
#define tableViewLableCellHeight 25.0

@interface JLGAuthorizationViewController : UIViewController
<
    JLGPickerViewDelegate,
    JLGDatePickerViewDelegate,
    JLGCityPickerViewDelegate,
    JLGProjectTypeViewControllerDelegate
>
@property (nonatomic,copy)   NSString *phone;
@property (nonatomic,copy)   NSArray *projectTypesArray;
//@property (nonatomic,copy)   NSArray *projectTypesArray;

@property (nonatomic,copy)   NSArray *workTypesArray;
@property (nonatomic,copy)   NSArray *skillTypesArray;
@property (nonatomic,copy)   NSArray *authoInfosArray;
@property (nonatomic,strong) NSMutableDictionary *mateRegisterInfo;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;
@property (nonatomic,strong) NSMutableArray *projectTypesSelectArray;
@property (nonatomic,strong) NSMutableArray *skillSelectArr;

//- (BOOL )checkBaseData;
- (void)initAutoInfoArray;
- (void)sqlDataSourceInit;
- (void)setHeaderViewLabelAlignment:(UILabel *)label;
- (NSString *)getKeyByIndexPath:(NSIndexPath *)indexPath;
- (void)blockWithCell:(JLGRegisterInfoTableViewCell *)returnCell;

//选择项目类型，工种的情况
- (void )JLGPickerViewSelect:(NSArray *)finishArray;
//城市选择
- (void )JLGCityPickerSelect:(NSDictionary *)cityDic byIndexPath:(NSIndexPath *)indexPath;
//显示完成的按钮
- (UITableViewCell *)cellAddSubView:(UITableViewCell *)cell WithRow:(NSInteger )row;
- (void)addLabel:(UITableViewCell *)cell;
- (void)addButton:(UITableViewCell *)cell;

    
- (void )setRegisterInfoCellDetailTF:(JLGRegisterInfoTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath;
- (void )setRegisterClickCellDetailTF:(JLGRegisterClickTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath;


@end
