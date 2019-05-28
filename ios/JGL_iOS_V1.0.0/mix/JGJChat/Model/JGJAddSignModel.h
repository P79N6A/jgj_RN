//
//  JGJAddSignModel.h
//  JGJCompany
//
//  Created by Tony on 16/9/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

#import <CoreLocation/CoreLocation.h>

@interface  JGJAddSignModel:TYModel

@property (nonatomic,copy) NSString *sign_time;//时间

@property (nonatomic, copy) NSString *sign_addr;//第一行的地址

@property (nonatomic, copy) NSString *sign_addr2;//第二行的地址

@property (nonatomic, copy) NSString *sign_desc;//描述
@property (nonatomic, copy) NSString *coordinate;//描述

/**
 *  语音文件,amr的url
 */
@property (nonatomic, copy) NSString *sign_voice;

/**
 *  录音长度
 */
@property (nonatomic, copy) NSString *sign_voice_time;

@property (nonatomic, strong) NSArray<NSString *> *sign_pic;//图片

//自己添加的

/**
 *  amr的路径
 */
@property (nonatomic, copy) NSString *sign_voice_amr_file;

/**
 *  wav的路径
 */
@property (nonatomic, copy) NSString *sign_voice_wav_file;

@property (nonatomic,assign) CGFloat textViewHeight;

//2.3.0

// 省
@property (nonatomic, strong) NSString *province;
// 市
@property (nonatomic, strong) NSString *city;
///坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) CGFloat cellHeight;

@end

