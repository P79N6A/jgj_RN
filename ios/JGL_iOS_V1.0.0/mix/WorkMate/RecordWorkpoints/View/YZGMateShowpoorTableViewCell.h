//
//  YZGMateShowpoorTableViewCell.h
//  mix
//
//  Created by Tony on 16/2/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGMateShowpoorTableViewCell : UITableViewCell

@property (nonatomic,assign,readonly) CGFloat centerXRation;
@property (nonatomic,assign,readonly) CGFloat rightXRation;
@property (nonatomic,assign) BOOL isLastCell;
/**
 *  设置三个label的内容
 *
 *  @param firstTitle  第一个label的内容
 *  @param secondTitle 第二个label的内容
 *  @param thirdTitle  第三个label的内容
 */
- (void)setFirstTitle:(id )firstTitle secondTitle:(id )secondTitle thirdTitle:(id)thirdTitle;
@end
