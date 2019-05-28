//
//  JGJRecordHeader.h
//  mix
//
//  Created by yj on 2018/9/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#ifndef JGJRecordHeader_h
#define JGJRecordHeader_h

typedef enum : NSUInteger {
    
    JGJRecordStaSearchMainType, //统计首页
    
    JGJRecordStaSearchSecCheckMemberType, // 记工统计-按工人查看2级页面-按月份统计
    
    JGJRecordStaSearchSecCheckProType, // 记工统计-按项目查看2级页面-按工人统计
    
    JGJRecordStaSearchMonthType // 按月统计(可切换为按天统计）
    
} JGJRecordStaSearchType;

typedef enum : NSUInteger {
    
    JGJRecordStaMonthType = 1,//月统计
    
    JGJRecordStaProjectType, //项目统计
    
    JGJRecordStaNormalWorkerType, //普通工人统计
    
    JGJRecordStaWorkLeaderType, //工头，班组长统计
    
} JGJRecordStaType;

#import "JGJComTitleDesCell.h"

#import "JGJRecordStaSearchTool.h"

#define StartTime @"选择开始日期"

#define EndTime @"选择结束日期"

#define MemberDes (JLGisLeaderBool ? @"全部工人" : @"全部班组长")

#define MemberId @""

#define AllProName @"全部项目"

#define AllProId @"0"

#define JGJSideWidth  TYGetUIScreenWidth - 40

#endif /* JGJRecordHeader_h */
