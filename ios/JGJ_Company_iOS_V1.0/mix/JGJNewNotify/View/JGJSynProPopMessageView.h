//
//  JGJSynProPopMessageView.h
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JGJSynProPopMessageViewBlock)();
@interface JGJSynProPopMessageView : UIView
- (instancetype)initWithFrame:(CGRect)frame mergecheckModels:(NSArray *)mergecheckModels;//测试模型
@property (nonatomic, copy) JGJSynProPopMessageViewBlock messageViewBlock;
@property (strong, nonatomic) NSArray *mergecheckModels;//同步项目班组 项目组合并提示模型数组
@end
