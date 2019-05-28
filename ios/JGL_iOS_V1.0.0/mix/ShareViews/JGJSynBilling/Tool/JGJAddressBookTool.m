//
//  JGJAddressBookTool.m
//  mix
//
//  Created by YJ on 16/8/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//
// 联系人存储路径

#import "JGJAddressBookTool.h"
#import "NSString+Extend.h"
#import "TYAddressBook.h"
static JGJAddressBookTool *_addressBookTool;
@interface JGJAddressBookTool ()
@property (nonatomic, strong) NSMutableArray *sortContacts ;//排序后的联系人
@property (nonatomic, strong) NSMutableArray *selectedSynBillingModels;//选中的同步联系人
@property (nonatomic, strong) NSMutableArray *contactsLetters;//包含首字母
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;//存储排序后信息
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JGJAddressBookTool
#pragma mark - 得到所有联系人的首字母
+ (NSMutableArray *)getContactsFirstletter:(NSMutableArray *)contacts {
    NSMutableArray *contactsLetters = [NSMutableArray array];
    for (JGJSynBillingModel *result in contacts) {
        if ([NSString isEmpty:result.real_name]) { //姓名为空的情况将姓名赋值为电话号码
            result.real_name = result.telephone;
        }
        if (![NSString isEmpty:result.real_name]) {
             result.firstLetteter = [NSString firstCharactor:result.real_name];
        }
        if (result.real_name.length >=2 && ![NSString isEmpty:result.real_name]) {
            result.secLetteter = [NSString firstCharactor:[result.real_name substringFromIndex:1]];
        }
        [contactsLetters addObject:result.firstLetteter.uppercaseString];
    }
    //    contactsLetters包含没有重复的字母
    NSSet *set = [NSSet setWithArray:contactsLetters];
    contactsLetters = [set allObjects].mutableCopy;
    contactsLetters = [NSMutableArray arrayWithArray: [contactsLetters sortedArrayUsingSelector:@selector(compare:)]];
    return contactsLetters;
}

#pragma mark - 对联系人进行排序
+ (NSMutableArray *)sortContacts:(NSArray *)contacts {
    
    // 创建contactLetters,存放分组首字母
    NSMutableArray *contactLetters = [NSMutableArray array];
    // 遍历联系人
    for (JGJSynBillingModel *contact in contacts) {
        //姓名为空的情况将姓名赋值为电话号码
        if ([NSString isEmpty:contact.real_name]) {
            contact.real_name = contact.telephone;
        }
        contact.nameHeadPinyin = [NSString toHeadPinyinWithChinese:contact.real_name];
        contact.firstLetteter = [contact.nameHeadPinyin substringToIndex:1];
        if (![contact.firstLetteter match:@"^[A-Z]$"]) {
            contact.firstLetteter = @"~";
        }
        [contactLetters addObject:contact.firstLetteter];
    }
    // 去重处理
    NSSet *lettersSet = [NSSet setWithArray:contactLetters];
    contactLetters = [[lettersSet allObjects] mutableCopy];
   
    // contactLetters排序
    [contactLetters sortUsingSelector:@selector(compare:)];
    
    // 将"~"分组放到最后
    if ([contactLetters containsObject:@"~"]) {
        [contactLetters removeObject:@"~"];
        [contactLetters addObject:@"~"];
    }
    // 创建SortFindResultModel数组
    NSMutableArray *sortedContacts = [NSMutableArray array];
    
    // 分组操作
    for (NSString *firstLetter in contactLetters) {
        SortFindResultModel *result = [[SortFindResultModel alloc] init];
        result.firstLetter = firstLetter;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstLetteter=%@",firstLetter?:@""];
        NSArray *filteredContacts = [contacts filteredArrayUsingPredicate:predicate];
        filteredContacts = [filteredContacts sortedArrayUsingComparator:^NSComparisonResult(JGJSynBillingModel * _Nonnull contact1, JGJSynBillingModel *  _Nonnull contact2) {
            return [contact1.nameHeadPinyin compare:contact2.nameHeadPinyin];
        }];
        result.findResult = filteredContacts;
        [sortedContacts addObject:result];
    }
    
    _addressBookTool.contactsLetters = contactLetters;
    _addressBookTool.sortContacts = sortedContacts;
    
    return sortedContacts;
}


#pragma mark - 处理读取已选中情况
- (void)handleReadAddressBookSelected:(SortFindResultModel *)sortFindResult selectedSynBillingModel:(JGJSynBillingModel *)synBillingModel {
    if ([NSString isEmpty:synBillingModel.real_name]) { //姓名为空的情况，将电话号码赋值为姓名异常处理
        synBillingModel.real_name = synBillingModel.telephone;
    }
    NSString *firstLetter = [NSString firstCharactor:synBillingModel.real_name].uppercaseString;
    SortFindResultModel *sortSlelctedFindResult = self.sortContacts[0];//判断第一个是不是已选中
    if (![self.selectedSynBillingModels containsObject:synBillingModel]) {
        [self.selectedSynBillingModels addObject:synBillingModel];
    }
    if (![sortSlelctedFindResult.firstLetter isEqualToString:@"0"]) { //首次添加已选中
        NSDictionary *contactDic = @{@"firstLetter" : @"0",
                                     @"findResult" : self.selectedSynBillingModels
                                     };
        SortFindResultModel *sortFindResultModel = [SortFindResultModel mj_objectWithKeyValues:contactDic];
        [self.sortContacts insertObject:sortFindResultModel atIndex:0];
        [self.contactsLetters insertObject:@"0" atIndex:0];
        
    } else {
        sortSlelctedFindResult.findResult = self.selectedSynBillingModels; //添加已选中到数据库
    }
    
    NSMutableArray *sortContacts = sortFindResult.findResult.mutableCopy;
    [sortContacts removeObject:synBillingModel];
    sortFindResult.findResult = sortContacts;
    if (sortFindResult.findResult.count == 0) { //已选中组被全选中,整组数据移除
        [self.sortContacts removeObject:sortFindResult];
        __block NSInteger indx = 0;
        [self.contactsLetters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:firstLetter]) {
                indx = idx;
                *stop = YES;
            }
        }];
        [self.contactsLetters removeObjectAtIndex:indx];
    }
}

/**
 *  存储手机联系人
 *
 */
+ (void)saveAddressBookContacts
{   _addressBookTool = [[self alloc] init];
    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^{

        NSMutableArray *contacts = [TYAddressBook loadAddressBook].mutableCopy;
        contacts = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:contacts];
        _addressBookTool.sortContactsModel.contactsLetters = [self getContactsFirstletter:contacts];
        _addressBookTool.sortContactsModel.sortContacts = [self sortContacts:contacts];
        _addressBookTool.sortContactsModel.isCacheSuccess = YES;
        [NSKeyedArchiver archiveRootObject:_addressBookTool.sortContactsModel toFile:JGJAddressBookToolPath];

    });
}

+ (void)archiveSortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel contactsPath:(NSString *)contactsPath{
    sortContactsModel.isCacheSuccess = YES;
    [NSKeyedArchiver archiveRootObject:sortContactsModel toFile:contactsPath];
}

/**
 *  获取手机联系人
 *
 */
+ (JGJAddressBookSortContactsModel *)addressBookContacts
{
    JGJAddressBookSortContactsModel *sortContactsModel = [NSKeyedUnarchiver unarchiveObjectWithFile:JGJAddressBookToolPath];
    return sortContactsModel;
}

- (JGJAddressBookSortContactsModel *)sortContactsModel {
    if (!_sortContactsModel) {
        _sortContactsModel = [[JGJAddressBookSortContactsModel alloc] init];
    }
    return _sortContactsModel;
}

#pragma mark - 搜索姓名
+ (NSMutableArray *)searchMemberName:(UITextField *)textField sortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel{
    _addressBookTool.sortContacts = sortContactsModel.sortContacts;
   __block NSMutableArray *searchContacts = [NSMutableArray array];
    if ([NSString isEmpty:textField.text]) {
        return nil;
    }
    NSString *firstLetter = nil;
    if (textField.text.length >= 1) {
        firstLetter = [NSString firstCharactor:[textField.text substringToIndex:1]].uppercaseString;
    }
    if (textField.text.length > 0 && textField.text != nil) {
        NSString *lowerSearchText = textField.text.lowercaseString;
        NSMutableArray *searchSortContacts = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (SortFindResultModel *sortContactModel in _addressBookTool.sortContacts) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or telephone contains %@ or name_pinyin contains %@  or firstLetteter contains %@", textField.text, lowerSearchText, lowerSearchText, lowerSearchText];
                NSMutableArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate].mutableCopy;
                NSDictionary *contactDic = @{@"firstLetter" : contacts.count > 0 ? sortContactModel.firstLetter : @"",
                                             @"findResult" : contacts
                                             };
                SortFindResultModel *sortResultModel = [SortFindResultModel mj_objectWithKeyValues:contactDic];
                if (contacts.count > 0) {
                    [searchSortContacts addObject:sortResultModel];
                }
            }
            searchContacts = searchSortContacts;
        });
    } else {
        searchContacts = sortContactsModel.sortContacts;
    }
    return searchContacts;
}

#pragma mark - 电话号码搜索
+ (NSMutableArray *)searchMemberTelephone:(UITextField *)textField sortContactsModel:(JGJAddressBookSortContactsModel *)sortContactsModel {
    _addressBookTool.sortContacts = sortContactsModel.sortContacts;
    __block NSMutableArray *searchContacts = nil;
    if (textField.text.length <= 3) {
        return nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (textField.text.length > 0 && textField.text != nil) {
            NSString *lowerSearchText = textField.text.uppercaseString;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains %@",lowerSearchText];
            NSMutableArray *searchContacts = [NSMutableArray array];
            for (SortFindResultModel *sortContactModel in _addressBookTool.sortContacts) {
                NSArray *contacts = [sortContactModel.findResult filteredArrayUsingPredicate:predicate];
                if (contacts.count > 0) {
                    [searchContacts addObjectsFromArray:contacts];
                }
            }
            _addressBookTool.sortContactsModel.contactsLetters = [self getContactsFirstletter:searchContacts];
            searchContacts = [self sortContacts:searchContacts];
        } else {
            searchContacts = sortContactsModel.sortContacts;
        }
    });
    return searchContacts;
}

/**
 *  联系人排序
 *
 */
+ (JGJAddressBookSortContactsModel *)addressBookToolSortContcts:(NSArray *)contacts {
    _addressBookTool = [[self alloc] init];
    JGJAddressBookSortContactsModel *sortContactsModel = [[JGJAddressBookSortContactsModel alloc] init];
    //    sortContactsModel.contactsLetters = [self getContactsFirstletter:contacts.mutableCopy];
    sortContactsModel.sortContacts = [self sortContacts:contacts.mutableCopy];
    
    sortContactsModel.contactsLetters = _addressBookTool.contactsLetters;
    return sortContactsModel;
}

/**
 *  获取网络手机联系人
 *
 */
+ (JGJAddressBookSortContactsModel *)addFriendSortContacts
{
    JGJAddressBookSortContactsModel *sortContactsModel = [NSKeyedUnarchiver unarchiveObjectWithFile:JGJAddFreiendAddressBookPath];
    return sortContactsModel;
}


@end
