//
//  JGJTaskTracerCell.h
//  JGJCompany
//
//  Created by yj on 2017/6/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJTaskTracerCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *contactModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (nonatomic, copy)   NSString *searchValue;

@end
