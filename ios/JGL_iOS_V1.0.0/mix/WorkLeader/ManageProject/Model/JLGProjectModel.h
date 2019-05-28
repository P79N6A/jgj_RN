//
//  JLGProjectModel.h
//  mix
//
//  Created by jizhi on 15/12/9.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@interface JLGProjectModel : TYModel

@property (nonatomic, copy) NSString *ctime;

@property (nonatomic, assign) NSInteger region;

@property (nonatomic, copy) NSString *regionname;

@property (nonatomic, copy) NSArray  *imgs;

//@property (nonatomic, strong) NSMutableArray  *imgsArray;

@property (nonatomic, copy) NSString *proname;

@property (nonatomic, copy) NSString *proaddress;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, assign) NSInteger proid;//对应服务器返回的id，因为id是系统的关键字
//@property (nonatomic, assign) NSInteger picNum;
@end
