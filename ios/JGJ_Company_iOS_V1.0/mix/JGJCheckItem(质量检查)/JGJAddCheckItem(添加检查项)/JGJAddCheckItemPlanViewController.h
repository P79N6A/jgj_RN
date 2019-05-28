//
//  JGJAddCheckItemPlanViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJAddCheckItemPlanViewController : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;

@property (strong, nonatomic) IBOutlet UITableView *tabelview;

@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) JGJAddCheckItemModel *CheckModel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *waringLableConstance;
@property (strong, nonatomic) NSMutableArray <JGJCheckContentListModel *>*hadMutlArr;

@property (strong ,nonatomic)JGJCheckItemListDetailModel *mainCheckListModel;

@property (strong, nonatomic)JGJCheckContentListModel *defultModel;//新建的默认选中的model

@end
