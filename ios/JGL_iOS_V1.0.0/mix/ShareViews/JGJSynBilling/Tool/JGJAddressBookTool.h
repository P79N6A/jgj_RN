//
//  JGJAddressBookTool.h
//  mix
//
//  Created by YJ on 16/8/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

// 联系人存储路径
#define JGJAddressBookToolPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"addressBookContacts.archive"]

//获取网络的手机联系人
#define JGJAddFreiendAddressBookPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"JGJAddFreiendAddressBook.archive"]

@interface JGJAddressBookTool : NSObject
/**
 *  存储手机联系人
 *
 */
+ (void)saveAddressBookContacts;
/**
 *  获取手机联系人
 *
 */
+ (JGJAddressBookSortContactsModel *)addressBookContacts;

/**
 *  电话号码搜索
 *
 */
+ (NSMutableArray *)searchMemberTelephone:(UITextField *)textField sortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel;

/**
 *  姓名搜索
 *
 */
+ (NSMutableArray *)searchMemberName:(UITextField *)textField sortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel;

/**
 *  联系人排序
 *
 */
+ (JGJAddressBookSortContactsModel *)addressBookToolSortContcts:(NSArray *)contacts;

/**
 *  存储通信录联系人
 *
 */
+ (void)archiveSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel contactsPath:(NSString *)contactsPath;

/**
 *  获取网络通信录联系人
 *
 */
+ (JGJAddressBookSortContactsModel *)addFriendSortContacts;

/**
 *  联系人排序
 *
 */
+ (NSMutableArray *)sortContacts:(NSArray *)contacts;

@end
