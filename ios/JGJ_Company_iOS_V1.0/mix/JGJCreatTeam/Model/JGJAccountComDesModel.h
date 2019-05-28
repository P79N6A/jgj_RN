//
//  JGJAccountComDesModel.h
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    JGJCommonInfoDesNameType, //姓名
    
    JGJCommonInfoTelType, //电话

} JGJCommonInfoDesType;

@interface JGJAccountComDesModel : NSObject

@end

@interface JGJCommonInfoDesModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, assign) CGFloat lineViewH;

//是否隐藏箭头
@property (nonatomic, assign) BOOL isHidden;

@property (nonatomic, assign) CGFloat leading;

@property (nonatomic, assign) CGFloat trailing;

@property (nonatomic, copy) NSString *imageStr;

//默认文字
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) JGJCommonInfoDesType desType;

//是否能编辑
@property (nonatomic, assign) BOOL isUnCanEdit;

@end
