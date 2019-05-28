//
//  JGJAddCheckItemContensViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJAddCheckItemContensViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;

@property (strong, nonatomic) JGJCheckContentDetailModel *checkModel;

@property (strong, nonatomic) NSMutableArray <JGJCheckItemPubDetailListModel *> *hadMutlArr;//应景被选中了的内容需要被选中标记

@property (strong, nonatomic)JGJCheckItemPubDetailListModel *createNextModel;//新建时检查内容返回默认的选中的

@end
