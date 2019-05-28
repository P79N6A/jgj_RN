//
//  JGJLoginFindAccountAnswerModel.h
//  mix
//
//  Created by Tony on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AnswerListModel;

@interface JGJLoginFindAccountAnswerModel : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *ques_title;
@property (nonatomic, strong) NSArray<AnswerListModel*> *answer_list;

@end

@interface AnswerListModel : NSObject

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *options;

@end
