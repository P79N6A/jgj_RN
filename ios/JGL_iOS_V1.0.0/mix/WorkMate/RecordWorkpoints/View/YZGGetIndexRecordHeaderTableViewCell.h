//
//  YZGGetIndexRecordHeaderTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGGetIndexRecordHeaderTableViewCell : UITableViewCell
/**
 *  设置标题的内容
 *
 *  @param text 内容
 */
- (void)setTitleLabelText:(NSString *)text;

- (void)setDayLableText:(NSString *)Dtext andSubDayLableText:(NSString *)subText;

@end
