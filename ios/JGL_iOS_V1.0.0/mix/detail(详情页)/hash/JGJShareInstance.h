//
//  JGJShareInstance.h
//  mix
//
//  Created by Tony on 2017/1/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJShareInstance : NSObject
+(JGJShareInstance *)shareInstance;
@property(nonatomic ,assign)BOOL isFirst;
@end
