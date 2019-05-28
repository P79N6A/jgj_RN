//
//  JGJMorePullDownView.h
//  mix
//
//  Created by jizhi on 16/5/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MorePullDownEditBlock)();
typedef void(^MorePullDownDeleteBlock)();
@interface JGJMorePullDownView : UIView


- (void)showMorePullDownView;
- (void)hiddenMorePullDownView;

- (void)MorePullDownEditBlock:(MorePullDownEditBlock )editBlock;
- (void)MorePullDownDeleteBlock:(MorePullDownDeleteBlock )deleteBlock;

- (instancetype)initWithSubViewT:(NSInteger )top right:(NSInteger )right;
@end
