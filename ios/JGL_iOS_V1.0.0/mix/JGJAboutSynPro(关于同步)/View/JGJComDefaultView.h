//
//  JGJComDefaultView.h
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJComDefaultViewModel : NSObject

@property (nonatomic, copy) NSString *des;

@property (nonatomic, copy) NSString *defaultImageStr;

@property (nonatomic, assign) BOOL isHiddenButton;

@property (nonatomic, assign) CGFloat lineSpace;

@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, assign) CGFloat offsetCenterY;

@end

typedef void(^JGJComDefaultViewBlock)();

@interface JGJComDefaultView : UIView

@property (nonatomic, strong) JGJComDefaultViewModel *defaultViewModel;

@property (nonatomic, copy) JGJComDefaultViewBlock comDefaultViewBlock;

@end
