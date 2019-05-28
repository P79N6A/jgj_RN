//
//  JGJQuaSafeCheckItemListDetailVc.h
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJQuaSafeCheckItemListDetailVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) JGJInspectListDetailCheckItemModel *checkItemModel;

//区分质量和安全检查区分 测试模型
@property (strong, nonatomic) JGJQualitySafeCommonModel *commonModel;

@end
