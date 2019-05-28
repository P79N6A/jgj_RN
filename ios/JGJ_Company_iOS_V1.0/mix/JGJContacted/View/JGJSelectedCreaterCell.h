//
//  JGJSelectedCreaterCell.h
//  mix
//
//  Created by yj on 16/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJSelectedCreaterCell : UITableViewCell
@property (nonatomic, strong) JGJSynBillingModel *contactModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
