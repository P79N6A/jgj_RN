//
//  TYPhone.h
//  mix
//
//  Created by jizhi on 15/12/15.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYPhone : NSObject
/**
 *  无提示
 */
+ (void)callPhoneByNum:(NSString *)phoneNum;
+ (void)callPhoneByNum:(NSString *)phoneNum view:(UIView *)contentView;

/**
 *  有提示
 */
+ (void)callPhoneHubByNum:(NSString *)phoneNum view:(UIView *)contentView;
@end
