//
//  TYAddressBook.h
//  mix
//
//  Created by Tony on 16/1/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYAddressBook : NSObject

@property(retain,nonatomic)NSString *string;
@property (nonatomic,copy) NSString *pinYin;

/**
 *  返回联系人排序后的数组
 *
 *  @param stringArr 原来没有排序的联系人数组
 *
 *  @return 排序后的联系人数组
 */
+(NSMutableArray*)addressBookSortArray:(NSArray*)stringArr;

/**
 *  获取索引数组
 *
 *  @param stringArr 通讯录数组
 *
 *  @return 返回索引的数组
 */
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

/**
 *  读手机的联系人
 *
 *  @return 读取完后手机联系人的数组
 */
+ (void)loadAddressBookByHttp;

/**
 *  获取拼音首字母(传入汉字字符串, 返回拼音首字母)
 *
 */
+ (NSString *)firstCharactor:(NSString *)string;
@end
