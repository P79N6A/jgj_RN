//
//  JGJSynRecordVc.h
//  mix
//
//  Created by yj on 2018/4/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSynRecordVc : UIViewController

@property (nonatomic, copy) SynSuccessBlock synSuccessBlock;

- (void)freshTable;

@end
