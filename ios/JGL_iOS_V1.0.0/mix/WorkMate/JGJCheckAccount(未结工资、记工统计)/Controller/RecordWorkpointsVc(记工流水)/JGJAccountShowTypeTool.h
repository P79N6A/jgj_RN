//
//  JGJAccountShowTypeTool.h
//  mix
//
//  Created by yj on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JGJShowTypes @[@"上班按工天、加班按小时", @"上班、加班按工天", @"上班、加班按小时"]

@interface JGJAccountShowTypeModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isSel;

//0.上班按工天、加班按小时 1.按工天, 2. 按小时

@property (nonatomic, assign) NSInteger type;

@end

@interface JGJAccountShowTypeTool : NSObject

+ (void)saveShowTypeModel:(id)showTypeModel;

+ (id)showTypeModel;

@end
