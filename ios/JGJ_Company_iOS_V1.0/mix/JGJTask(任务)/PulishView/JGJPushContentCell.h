//
//  JGJPushContentCell.h
//  mix
//
//  Created by yj on 2017/5/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYTextView.h"

typedef void(^PushContentCellBlock)(YYTextView *);

@interface JGJPushContentCell : UITableViewCell

@property (nonatomic, copy) PushContentCellBlock pushContentCellBlock;

@property (nonatomic, copy) NSString *placeholderText; //默认文字

@property (nonatomic, assign) NSUInteger maxContentWords;

//检查记录默认文字。检查大项小项检查结果
@property (nonatomic, copy) NSString *checkRecordDefaultText;

@end
