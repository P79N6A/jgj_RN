//
//  JGJFindJobAndProTableViewCell.h
//  mix
//
//  Created by Tony on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJLabel.h"
#import "JLGFindProjectModel.h"

@interface JGJFindJobAndProTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *prepayLabel;
@property (nonatomic,strong) JLGFindProjectModel *jlgFindProjectModel;

//cell高度使用
@property (nonatomic,assign) CGFloat excludeContentH;//除了中间需要根据内容变化的高度
@property (assign,nonatomic) CGFloat contentLabelH;//外部计算出的contentLabel的高度

/**
 *  通过Model设置cell内容
 *
 *  @param jlgFindProjectModel 传入的model
 */
- (void)setSubViewBy:(JLGFindProjectModel *)jlgFindProjectModel;
@end
