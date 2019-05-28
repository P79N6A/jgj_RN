//
//  JGJCoreTextLable+Category.h
//  JGJCompany
//
//  Created by yj on 2017/11/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCoreTextLable.h"

typedef void(^JGJCoreTextCopyActionBlock)();

@interface JGJCoreTextLable (Category)

@property (nonatomic, copy) JGJCoreTextCopyActionBlock copyActionBlock;

//copy功能
- (void)canCopy;
@end
