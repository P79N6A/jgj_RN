//
//  JGJSignRemarkCell.h
//  mix
//
//  Created by yj on 17/3/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYTextView.h"

#import "JGJAddSignModel.h"



@class JGJSignRemarkCell;

@protocol JGJSignRemarkCellDelegate <NSObject>

- (void)textViewCell:(JGJSignRemarkCell *)cell didChangeText:(YYTextView *)textView;

@end

@interface JGJSignRemarkCell : UITableViewCell

@property (nonatomic,weak) id <JGJSignRemarkCellDelegate>delegate;

//签到输入的信息
@property (nonatomic,strong) JGJAddSignModel *addSignModel;

/**
 *  签到类型
 */
@property (nonatomic, assign) BOOL isCheckSignInfo;

@property (weak, nonatomic) IBOutlet UILabel *remarkLable;


@end
