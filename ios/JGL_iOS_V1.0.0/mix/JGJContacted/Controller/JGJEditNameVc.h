//
//  JGJEditNameVc.h
//  mix
//
//  Created by yj on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJEditContactedNameVcType,
    JGJEditGroupNameVcType,
    JGJEditUpgradeGroupNameVcType
} JGJEditNameVcType;

@class JGJEditNameVc;
@protocol JGJEditNameVcDelegate <NSObject>
- (void)editNameVc:(JGJEditNameVc *)editNameVc nameString:(NSString *)nameTF;
@end
@interface JGJEditNameVc : UIViewController
@property (weak, nonatomic) id <JGJEditNameVcDelegate> delegate;
@property (assign, nonatomic) JGJEditNameVcType editNameVcType;
@property (copy, nonatomic) NSString *name;//传入修改的名字
@property (copy, nonatomic) NSString *namePlaceholder; //默认灰色文字
@property (copy, nonatomic) NSString *defaultName; //默认文字
@end
