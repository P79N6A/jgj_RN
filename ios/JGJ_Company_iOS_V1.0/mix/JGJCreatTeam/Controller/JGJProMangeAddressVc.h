//
//  JGJProMangeAddressVc.h
//  JGJCompany
//
//  Created by yj on 2017/5/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGCityModel.h"

@protocol JGJProMangeAddressVcDelegate <NSObject>

- (void)handleProMangeSelectedCurrentCityModel:(JLGCityModel *)cityModel;

@end
@interface JGJProMangeAddressVc : UIViewController

@property (nonatomic, weak) id <JGJProMangeAddressVcDelegate> delegate;

@property (nonatomic, strong) JLGCityModel *cityModel;//显示当前选择的所在城市

@property (nonatomic ,copy) NSString *proName;//当前项目名字

@end
