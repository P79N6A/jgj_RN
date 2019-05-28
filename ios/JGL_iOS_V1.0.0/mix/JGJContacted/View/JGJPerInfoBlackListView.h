//
//  JGJPerInfoBlackListView.h
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJPerInfoBlackListViewJoinBlackButtonType,
    JGJPerInfoBlackListViewJoinCancelButtonType
} JGJPerInfoBlackListViewButtonType;

@class JGJPerInfoBlackListView;
@protocol JGJPerInfoBlackListViewDelegate <NSObject>

@optional
- (void)perInfoBlackListView:(JGJPerInfoBlackListView *)blackListView perInfoBlackListViewButtonType:(JGJPerInfoBlackListViewButtonType)buttonType;
@end
@interface JGJPerInfoBlackListView : UIView
+ (JGJPerInfoBlackListView *)perInfoBlackListView;
@property (weak, nonatomic) id <JGJPerInfoBlackListViewDelegate> delegate;
@end
