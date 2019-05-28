//
//  JGJVideoListRequestModel.h
//  mix
//
//  Created by yj on 2018/3/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJVideoListRequestCommonModel : NSObject

@property (nonatomic, assign) NSInteger pg;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface JGJVideoListRequestModel : JGJVideoListRequestCommonModel

@property (nonatomic, copy) NSString *postId;

@end


