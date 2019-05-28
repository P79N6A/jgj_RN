//
//  JGJReusableHeaderView.h
//  mix
//
//  Created by yj on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)();
typedef void(^OkBlock)();
@interface JGJReusableHeaderView : UICollectionReusableView
@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) OkBlock okBlock;
@end
