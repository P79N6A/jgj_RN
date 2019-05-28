//
//  JGJQuaSafeCommonSysMsgCell.h
//  JGJCompany
//
//  Created by yj on 2017/12/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJQuaSafeCommonSysMsgCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSString *changeColorStr;

@end


@interface JGJQuaSafeCommonSysMsgCell : UITableViewCell

@property (nonatomic, strong) JGJQuaSafeCommonSysMsgCellModel *commonSysMsgCellModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
