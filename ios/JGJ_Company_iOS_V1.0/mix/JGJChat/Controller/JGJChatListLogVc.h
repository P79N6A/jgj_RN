//
//  JGJChatListLogVc.h
//  JGJCompany
//
//  Created by Tony on 16/9/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatOhterListBaseVc.h"

@interface JGJChatListLogVc : JGJChatOhterListBaseVc
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong , nonatomic) JGJGetLogTemplateModel *model;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottmConstance;
@end
