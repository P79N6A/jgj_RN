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

@property (nonatomic, copy) NSString *remarkTitle;

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

//是否能成为第一响应者
@property (nonatomic, assign) BOOL isCanFirstResponder;

//备注信息
@property (nonatomic, copy) NSString *notes_txt;

//备注图片
@property (nonatomic, copy) NSString *notes_img;

//姓名长度
@property (nonatomic, assign) NSInteger nameLength;

@end
