//
//  JGJPersonWageListTitleView.h
//  mix
//
//  Created by Tony on 2016/7/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJPersonWageListModel.h"

@interface JGJPersonWageListTitleView : UIView
@property (nonatomic, strong) JGJPersonWageListModel *jgjPersonWageListModel;
@property (strong, nonatomic) IBOutlet UIView *moneyView;
@end
