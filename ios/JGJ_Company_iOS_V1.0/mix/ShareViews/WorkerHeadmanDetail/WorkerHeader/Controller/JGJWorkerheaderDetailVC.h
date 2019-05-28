//
//  JGJWorkerheaderDetailVC.h
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFHLeaderModel.h"
#import "JLGFHLeaderDetailModel.h"

@interface JGJWorkerheaderDetailVC : UIViewController

@property (nonatomic,copy) NSString *roletype;
@property (strong,nonatomic) JLGFHLeaderDetailModel *jlgFHLeaderDetailModel;
@property (nonatomic,strong) JLGFHLeaderModel *jlgFHLeaderModel;
@end
