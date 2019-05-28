//
//  JLGFHLeaderDetailModel.h
//  mix
//
//  Created by jizhi on 15/12/26.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGFHLeaderModel.h"

@interface JLGFHLeaderDetailModel : JLGFHLeaderModel

@property (nonatomic,copy) NSArray *findresult;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,copy) NSString *regionName;

//为不影响之前的数据单独添加联系人数据
@property (nonatomic, strong) NSArray *contacts;

@property (nonatomic, copy) NSString *roleType;
@end

//联系人模型
@interface FindResultModel : NSObject
@property (nonatomic,copy) NSString *telph;
@property (nonatomic,copy) NSString *headpic;
@property (nonatomic,copy) NSString *friendname;
@property (nonatomic, copy) NSString *firstLetteter;
@property (nonatomic, copy) NSString *fmname;
@property (assign, nonatomic) BOOL isHiddenIndexView;//是否显示右边的索引
@end

