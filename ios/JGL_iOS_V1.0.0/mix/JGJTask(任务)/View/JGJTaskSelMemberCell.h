//
//  JGJTaskSelMemberCell.h
//  JGJCompany
//
//  Created by yj on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@interface JGJTaskSelMemberCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *contactModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;

//是否偏移不是平台人员
@property (assign, nonatomic) BOOL isOffset;

@property (copy, nonatomic) NSString *searchValue;
@end
