//
//  JGJCheckItemLookForDetailViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckItemLookForDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;
@property (strong, nonatomic) JGJCheckItemPubDetailModel *pubDetailModel;
@property(nonatomic ,strong)NSMutableArray <JGJCheckItemPubDetailListModel *>*SelectdataArr;//用来设置选中的检查内容
@property (assign, nonatomic) BOOL editeCheckItem;//是否是编辑检查项

@property (assign, nonatomic) BOOL lookForCheckItem;//是否是查看详情

@property (assign, nonatomic) BOOL hiddenEditeBar;//影藏编辑按钮

@property (strong ,nonatomic)JGJCheckItemListDetailModel *mainCheckListModel;
@end
