//
//  JGJRecordDateSelTitleView.h
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJRecordDateSelTitleViewBlock)(NSString *date);

@interface JGJRecordDateSelTitleView : UIView

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) JGJRecordDateSelTitleViewBlock recordDateSelTitleViewBlock;

//是否是记工变更进入
@property (nonatomic, assign) BOOL is_change_date;

@end
