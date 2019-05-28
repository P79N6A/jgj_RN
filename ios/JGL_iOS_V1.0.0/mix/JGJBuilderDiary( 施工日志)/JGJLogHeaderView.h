//
//  JGJLogHeaderView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , logClickType) {
    allLogtype,
    meLogTYpe,
    otherType,

};
@protocol clickLogTopButtondelegate <NSObject>
- (void)clickLogTopButtonWithType:(logClickType)type;
@end
@interface JGJLogHeaderView : UIView
@property(nonatomic,strong)UIButton *allButton;
@property(nonatomic,strong)UIButton *meButton;
@property(nonatomic,strong)UIButton *filtrateButton;
@property(nonatomic,strong)UIView *departLable;
@property(nonatomic,strong)UIView *SecondDepartLable;
@property(nonatomic,strong)id <clickLogTopButtondelegate>delegate;
@property(nonatomic,assign)logClickType logClickTypes;
@property(nonatomic,strong)UIView *bottomLine;
@property (nonatomic, strong)JGJNodataDefultModel *defultModel;

-(void)setMeLOgNumWithStr:(NSString *)num;

@end
