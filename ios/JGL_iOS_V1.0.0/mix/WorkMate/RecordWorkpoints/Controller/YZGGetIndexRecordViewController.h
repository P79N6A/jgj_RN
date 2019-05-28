//
//  YZGGetIndexRecordViewController.h
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGGetIndexRecordViewController : UIViewController
@property (nonatomic,strong) NSDate *date;
- (void)JLGHttpRequest;
@property (nonatomic, assign) BOOL sendType;
/*
 *从一天几多人跳转到这里 然后点击返回 直接回到首页
 */

@property (nonatomic, assign) BOOL backMainVC;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstances;

@end
