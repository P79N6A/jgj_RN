//
//  JGJDetailModel.h
//  mix
//
//  Created by Tony on 2016/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJDetailModel : NSObject
@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *msg_text;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, strong) UIColor *user_nameColor;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *head_pic;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *msg_type;

@property (nonatomic, copy) NSArray <NSString *>*msg_src;

@end
