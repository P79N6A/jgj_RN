//
//  JGJChatListSignVc.h
//  JGJCompany
//
//  Created by Tony on 16/9/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseVc.h"
#import "JGJChatSignVc.h"
#import "JGJChatSignModel.h"
#import "JGJChatSignHeaderCell.h"
#import "JGJChatSignMemberCell.h"

#import "JGJSignRequestModel.h"

@interface JGJChatListSignVc : JGJChatListBaseVc

@property (nonatomic,strong) JGJChatSignModel *chatSignModel;

@property (nonatomic,strong) NSMutableDictionary *parameters;

@property (nonatomic,assign) SignHeaderType signHeaderType;

@property (strong, nonatomic, readonly) JGJSignRequestModel *signRequest;

- (void)dataInit;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SignConstance;


- (void)subClassWillAppear;

@end
