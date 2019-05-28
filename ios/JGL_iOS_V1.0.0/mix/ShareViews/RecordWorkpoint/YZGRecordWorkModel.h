//
//  YZGRecordWorkModel.h
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

typedef NS_ENUM(NSUInteger, YZGRecordWorkRedPointType) {
    YZGRecordWorkRedPointDefault = 0,
    YZGRecordWorkRedPointRedPoint,
    YZGRecordWorkRedPointLabelNum
};

@interface YZGRecordWorkModel : TYModel

@property (nonatomic, copy)     NSString *titleString;
@property (nonatomic, copy)     id detailString;
@property (nonatomic, assign)   YZGRecordWorkRedPointType redPointType;//红点显示的类型
@property (nonatomic, copy)     NSString *labelNum;//需要显示的数字的值
@property (nonatomic, strong)   UIColor *backgroundColor;//需要显示的颜色

@end
