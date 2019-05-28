//
//  JGJMakeAccountChoiceSubentryTemplateController.h
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJSubentryListModel.h"
typedef void(^SubentryNameWithTag)(NSInteger cellTag,NSString *subentryName);
typedef void(^ChoiceSubentryListModel)(NSInteger cellTag,JGJSubentryListModel *subentryModel);

@interface JGJMakeAccountChoiceSubentryTemplateController : UIViewController

@property (nonatomic, copy) SubentryNameWithTag sureSubenTryInput;
@property (nonatomic, copy) ChoiceSubentryListModel selectedSubentryModel;
@property (nonatomic, assign) NSInteger cellTag;
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@end
