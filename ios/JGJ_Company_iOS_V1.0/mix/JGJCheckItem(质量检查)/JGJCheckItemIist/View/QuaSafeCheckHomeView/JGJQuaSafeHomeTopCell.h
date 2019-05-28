//
//  JGJQuaSafeHomeTopCell.h
//  JGJCompany
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJQuaSafeHomeTopCellBlock)(NSInteger indx);

@interface JGJQuaSafeHomeTopCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *topInfos;

@property (nonatomic, copy) JGJQuaSafeHomeTopCellBlock quaSafeHomeTopCellBlock;

+(CGFloat)JGJQuaSafeHomeTopCellHeight;
@end
