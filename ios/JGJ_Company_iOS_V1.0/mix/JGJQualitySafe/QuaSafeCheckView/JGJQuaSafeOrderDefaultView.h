//
//  JGJQuaSafeOrderDefaultView.h
//  JGJCompany
//
//  Created by yj on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJQuaSafeOrderDefaultViewModel : NSObject

@property (nonatomic, copy) NSString *imageViewStr;

@property (nonatomic, copy) NSString *desButtonTitle;

@property (nonatomic, assign) CGFloat desButtonFontSize;

@property (nonatomic, strong) UIColor * desButtonFontColor;

@property (nonatomic, copy) NSString *desInfo;

@property (nonatomic, assign) CGFloat desInfoFontSize;

@property (nonatomic, strong) UIColor *desInfoFontColor;

@property (nonatomic, copy) NSString *actionButtonTitle;

@property (nonatomic, strong) UIColor *actionButtonFontColor;

@property (nonatomic, assign) BOOL isHiddenActionButton;

@property (nonatomic, assign) BOOL isHiddenlineView;

@property (nonatomic, copy) NSString *changeColorDes;

@property (nonatomic, assign) BOOL isCenter;

@end

typedef enum : NSUInteger {
    QuaSafeOrderDefaultViewDesButtonType, //点击了解该功能
    
    QuaSafeOrderDefaultViewActionButtonType, //(立即订购)申请按钮
    
    QuaSafeOrderDefaultViewTryUseActionButtonType, //免费试用黄金服务版
    
} JGJQuaSafeOrderDefaultViewButtonType;

@class JGJQuaSafeOrderDefaultView;

typedef void(^HandleQuaSafeOrderDefaultViewBlock)(JGJQuaSafeOrderDefaultViewButtonType, JGJQuaSafeOrderDefaultView *);

@interface JGJQuaSafeOrderDefaultView : UIView

@property (nonatomic, strong) JGJQuaSafeOrderDefaultViewModel *infoModel;

//项目信息
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic, copy) HandleQuaSafeOrderDefaultViewBlock handleQuaSafeOrderDefaultViewBlock;

@end
