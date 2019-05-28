//
//  JLGAddRegisterInfoViewController.h
//  mix
//
//  Created by Tony on 16/1/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAuthorizationRegisterViewController.h"
#import "TYModel.h"

@interface AddRegisterInfoModel : TYModel
@property (nonatomic,assign) NSInteger hometown;
@property (nonatomic,assign) NSInteger expectaddr;
@property (nonatomic,assign) NSInteger head_pic;
@property (nonatomic,assign) NSInteger realname;
@property (nonatomic,assign) NSInteger gender;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger workyear;
@property (nonatomic,assign) NSInteger w_worktype;
@property (nonatomic,assign) NSInteger f_worktype;
@property (nonatomic,assign) NSInteger person_count;
@end

@interface JLGAddRegisterInfoViewController : JLGAuthorizationRegisterViewController

//隐藏坐上的返回键
@property (nonatomic,assign) BOOL hiddenLeftItem;

@end
