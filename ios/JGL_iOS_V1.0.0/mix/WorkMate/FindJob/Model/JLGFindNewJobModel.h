//
//  JLGFindNewJobModel.h
//  mix
//
//  Created by jizhi on 15/11/27.
//  Copyright © 2015年 JiZhi. All rights reserved.
//
//JLGFindProjectModel
#import "TYModel.h"

@class Friends,Share;
@interface JLGFindNewJobModel : TYModel

@property (nonatomic, copy) NSString *worklevel;

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, assign) NSInteger review_cnt;

@property (nonatomic, copy) NSString *proaddress;

@property (nonatomic, copy) NSString *balanceway;

@property (nonatomic, copy) NSString *proname;

@property (nonatomic, copy) NSString *protitle;

@property (nonatomic, strong) NSArray<NSString *> *welfares;

@property (nonatomic, copy) NSArray *prolocation;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *ctime;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *telph;

@property (nonatomic, strong) NSArray<Friends *> *friends;

@property (nonatomic, copy) NSString *prodescrip;

@property (nonatomic, assign) NSInteger friendcount;

@property (nonatomic, copy) NSString *fmname;

@property (nonatomic, assign) CGFloat total_area;

@property (nonatomic,copy) NSDictionary *share;

@end
@interface Friends : NSObject

@property (nonatomic, copy) NSString *headpic;

@property (nonatomic, copy) NSString *telph;

@property (nonatomic, copy) NSString *friendname;

@end
