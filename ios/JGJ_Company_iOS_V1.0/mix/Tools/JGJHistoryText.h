//
//  JGJHistoryText.h
//  JGJCompany
//
//  Created by Tony on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJHistoryText : NSObject
+ (void)saveWithKey:(NSString *)saveKey andContent:(NSString *)content;
+ (NSString *)readWithkey:(NSString *)readKey;
+ (void)clean;

@end
