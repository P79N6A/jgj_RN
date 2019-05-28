//
//  JGJMemberAppraiseTagVc.h
//  mix
//
//  Created by yj on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJMemberImpressTagViewModel;

typedef void(^JGJMemberAppraiseTagVcBlock)(JGJMemberImpressTagViewModel *tagModel);

@interface JGJMemberAppraiseTagVc : UIViewController

@property (copy, nonatomic) JGJMemberAppraiseTagVcBlock tagVcBlock;

@end
