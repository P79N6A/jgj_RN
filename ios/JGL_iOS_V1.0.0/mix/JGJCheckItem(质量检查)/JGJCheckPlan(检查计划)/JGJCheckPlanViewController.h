//
//  JGJCheckPlanViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/11/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,JGJCheckPlanState) {
    JGJNorMalCheckPlanType,
    JGJEditeCheckPlanType,

};

@interface JGJCheckPlanViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tabelView;

@property (nonatomic, strong) JGJMyWorkCircleProListModel *WorkproListModel;

@property (strong, nonatomic)NSMutableArray <JGJCheckContentListModel *>*selectArr;//选中的

@property (strong, nonatomic) IBOutlet UIView *bootmBaseView;
@property (nonatomic, assign) BOOL editePlan;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;

@property (nonatomic, strong) JGJInspectListDetailModel *inspectListDetailModel;

@property (nonatomic, assign) JGJCheckPlanState CheckPlanType;

@end
