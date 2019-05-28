//
//  JGJComTitleDesCell.h
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJComTitleDesCell : UITableViewCell

@property (strong, nonatomic) JGJComTitleDesInfoModel *infoModel;

//是否显示农历
@property (assign, nonatomic) BOOL is_show_lunar;

@end
