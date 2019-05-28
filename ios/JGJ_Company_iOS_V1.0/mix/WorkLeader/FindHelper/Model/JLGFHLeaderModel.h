//
//  JLGFHLeaderModel.h
//  mix
//
//  Created by jizhi on 15/12/1.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYModel.h"

typedef enum : NSUInteger {
    FindHelperType = 1,
    FindJodType
} CurrentPageType;

@class FHLeaderWorktype;
@interface JLGFHLeaderModel : TYModel


@property (nonatomic, strong) NSArray *location;

@property (nonatomic, copy) NSString *headpic;

@property (nonatomic, copy) NSString *workyear;

@property (nonatomic, assign) NSInteger friendcount;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, assign) NSInteger overall;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, assign) NSInteger pros;

@property (nonatomic, strong) NSArray<FHLeaderWorktype *> *worktype;

@property (nonatomic, assign) NSInteger wkmatecount;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSArray *main_filed;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, assign) NSInteger verified;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger scale;

@property (nonatomic, copy)  NSString* hometown;

@property (nonatomic, assign) CGFloat worktypeViewH;//类型View的高度

@property (nonatomic, assign) CGFloat lineMaxWidth;//换行最大宽度

//V1.4新接口模型变动
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSArray *work_type;//存储工种类型模型
@property (nonatomic, strong) NSString *work_year;
@property (nonatomic, copy) NSString *current_addr;
@property (nonatomic, copy) NSString *find_work_num;

@end

@interface FHLeaderWorktype : TYModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

//V1.4新接口模型变动
@property (nonatomic, copy) NSString *type_name;

@property (nonatomic, assign) NSInteger type_id;

@property (nonatomic, assign) BOOL isSelected;//是否选中该类型

@property (nonatomic, assign) CGFloat workTypeHeight;

@property (nonatomic, assign) CurrentPageType currentPageType; //根据当前页面是找工作 还是找帮手确定是否添加我的工种

@end

