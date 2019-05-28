//
//  JGJChatBootomView.h
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJChatBootomDefualt = 0,
    JGJChatBootomCreater,//创建者
    JGJChatBootomMember//成员
} JGJChatBootomType;

@class JGJChatBootomView;
@protocol JGJChatBootomViewDelegate <NSObject>

- (void)chatBottomBtnClick:(JGJChatBootomView *)chatBootomView button:(UIButton *)button;

@end

typedef void(^chatBootomBtnClick)(JGJChatBootomView *chatBootomView,UIButton *button);

@interface JGJChatBootomView : UIView

@property (nonatomic , strong) chatBootomBtnClick chatBootomBtnClick;

@property (nonatomic , weak) id<JGJChatBootomViewDelegate> delegate;


- (void)setDataSource:(NSArray <NSDictionary *>*)dataSourceArr;

@end