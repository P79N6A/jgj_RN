//
//  JGJHomeProCell.h
//  mix
//
//  Created by yj on 2018/6/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeProCellBlock)(id);

@interface JGJHomeProCell : UITableViewCell

@property (nonatomic, strong) JGJEmployListModel *listModel;

@property (nonatomic, copy) HomeProCellBlock homeProCellBlock;

@end
