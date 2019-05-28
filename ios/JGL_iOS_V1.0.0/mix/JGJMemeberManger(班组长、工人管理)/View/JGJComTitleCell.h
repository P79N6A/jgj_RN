//
//  JGJComTitleCell.h
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJComTitleCellDesModel : NSObject

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *des;

@property (copy, nonatomic) NSString *changeColorStr;

//多个数据颜色改变

@property (strong, nonatomic) NSArray *changeColors;

@end

@interface JGJComTitleCell : UITableViewCell

@property (nonatomic, strong) JGJComTitleCellDesModel *desModel;
@end
