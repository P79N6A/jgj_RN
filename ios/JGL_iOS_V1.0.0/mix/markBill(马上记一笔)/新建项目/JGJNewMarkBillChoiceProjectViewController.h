//
//  JGJNewMarkBillChoiceProjectViewController.h
//  mix
//
//  Created by Tony on 2018/6/1.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJNewMarkBillProjectModel.h"
#import "YZGGetBillModel.h"
@protocol JGJNewMarkBillChoiceProjectViewControllerDelgate <NSObject>

@optional
- (void)selectedProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel;
- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel;
@end
@interface JGJNewMarkBillChoiceProjectViewController : UIViewController

@property (nonatomic, weak) id<JGJNewMarkBillChoiceProjectViewControllerDelgate> projectListVCDelegate;

@property (nonatomic, strong) YZGGetBillModel *billModel;

@property (nonatomic, assign) BOOL isMarkSingleBillComeIn;
@end
