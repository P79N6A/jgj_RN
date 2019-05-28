//
//  JGJCustomDefaultView.h
//  mix
//
//  Created by yj on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBtnActionBlock)();

typedef void(^RightBtnActionBlock)();


@interface JGJCustomDefaultViewModel : NSObject

@property (nonatomic, copy) NSString *leftButtonTitle;

@property (nonatomic, copy) NSString *rightButtonTitle;

@property (nonatomic, copy) NSString *des;

//变色描述
@property (nonatomic, copy) NSString *changeColorDes;

@property (nonatomic, copy) NSString *imageStr;

@property (nonatomic, assign) BOOL isOnlyShowRight;

@property (nonatomic, assign) BOOL isOnlyShowLeft;

@end

@interface JGJCustomDefaultView : UIView

@property (nonatomic, copy) LeftBtnActionBlock leftBtnActionBlock;

@property (nonatomic, copy) RightBtnActionBlock rightBtnActionBlock;

@property (nonatomic, strong) JGJCustomDefaultViewModel *desModel;

@end
