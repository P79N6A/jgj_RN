//
//  TYAddressBook.m
//  mix
//
//  Created by Tony on 16/1/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYAddressBook.h"
#import "NSString+JSON.h"
#import "NSString+Extend.h"
#import <AddressBook/AddressBook.h>
#import "TYPermission.h"
#import "TYPredicate.h"
@implementation TYAddressBook

#pragma mark - 返回索引
+(NSMutableArray*)IndexArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray *A_Result=[NSMutableArray array];
    NSString *tempString ;
    
    for (TYAddressBook* object in tempArray)
    {
        NSString *pinyin;
        if ([NSString isEmpty:object.pinYin]) {
            pinyin = @"";
        }else{
            pinyin = [object.pinYin substringToIndex:1];
        }
        
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            // NSLog(@"IndexArray----->%@",pinyin);
            [A_Result addObject:pinyin];
            tempString = pinyin;
        }
    }
    return A_Result;
}

#pragma mark - 返回联系人
+(NSMutableArray*)addressBookSortArray:(NSArray*)stringArr
{
    NSMutableArray *tempArray = [TYAddressBook ReturnSortChineseArrar:stringArr];
    NSMutableArray *addressBookResult=[NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (TYAddressBook* object in tempArray) {
        NSString *pinyin;
        if ([NSString isEmpty:object.pinYin]) {
            pinyin = @"";
        }else{
            pinyin = [object.pinYin substringToIndex:1];
        }
        
        NSString *string = ((TYAddressBook *)object).string;
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            [item  addObject:string];
            [addressBookResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            [item  addObject:string];
        }
    }
    return addressBookResult;
}


//返回通讯录的汉字对应的拼音
+(NSMutableArray*)ReturnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    
    for(int i=0;i<[stringArr count];i++)
    {
        TYAddressBook *addressBookString = [[TYAddressBook alloc]init];

        addressBookString.string=[NSString stringWithString:[stringArr objectAtIndex:i]];
        
        if(addressBookString.string==nil){
            addressBookString.string=@"";
        }
        
        if (addressBookString.string.length > 1) {
            //去除两端空格和回车
            addressBookString.string  = [addressBookString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }

        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        NSString *initialStr = [addressBookString.string length]?[addressBookString.string substringToIndex:1]:@"";
        if ([predicate evaluateWithObject:initialStr])
        {
            //首字母大写
            addressBookString.pinYin = [addressBookString.string capitalizedString] ;
        }else{
            if(![addressBookString.string isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j = 0;j < addressBookString.string.length;j++){
                    NSString *shorString = [addressBookString.string substringWithRange:NSMakeRange(j, 1)];
                    NSString *singlePinyinLetter = [self firstCharactor:shorString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                addressBookString.pinYin = pinYinResult;
            }else{
                addressBookString.pinYin=@"";
            }
        }
        [chineseStringsArray addObject:addressBookString];
    }
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
    
}

//获取拼音首字母(传入汉字字符串, 返回拼音首字母)
+ (NSString *)firstCharactor:(NSString *)string
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:string];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+ (NSArray *)loadAddressBook
{
    //1.1.0打补丁审核版本---开始
    BOOL isJspatch = [self isJSpatchLoadAddressBook];
    if (isJspatch) {
        return nil;
    }
    //1.1.0打补丁审核版本---结束

    if (![TYPermission isCanReadAddressBookWithStr:nil]) {
        return nil;
    }
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block NSArray *addressBookArray = [NSArray array];
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            addressBookArray =  [self getAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        addressBookArray = [self getAddressBook:addressBook];
    }
    else {
        // 更新界面
        TYLog(@"没有获取通讯录权限");
        addressBookArray = nil;
    }

    return addressBookArray;
}

#pragma mark - 是否打补丁之后加载通信录
+ (BOOL)isJSpatchLoadAddressBook {
    
    return NO;
}

//然后循环获取每个联系人的信息，建议自己建个model存起来。
+(NSArray *)getAddressBook:(ABAddressBookRef)addressBook{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray *addressBookArray = [NSMutableArray array];
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        //获取名字
        NSMutableString *allName = [NSMutableString string];
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        [allName appendString:lastName?:@""];
        NSString *nameFirst = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        [allName appendString:nameFirst?:@""];
        //读取电话
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSMutableArray * phoneArray = [[NSMutableArray alloc]init];
        for (NSInteger j=0; j<ABMultiValueGetCount(phone); j++) {
            NSString *phoneNumStr = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, j));
            phoneNumStr = [phoneNumStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if (phoneNumStr.length >=3 && [phoneNumStr hasPrefix:@"+86"]) {
                phoneNumStr = [phoneNumStr stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                phoneNumStr = [phoneNumStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+@? "];
            phoneNumStr = [[phoneNumStr componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
            [phoneArray addObject:phoneNumStr];

        }
        //转换数据
        for (NSString *phoneNum in phoneArray) {
            
            NSString *replacphoneNum = [[phoneNum componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
            
            BOOL isPhone = [TYPredicate isRightPhoneNumer:replacphoneNum]; //匹配电话才上传
            if (!allName || !phoneNum || !isPhone) {
                continue;
            }else{
                NSDictionary *parameter = @{@"name":allName,@"telph":replacphoneNum};
                [addressBookArray addObject:parameter];
            }
        }
    }

    return addressBookArray;
}


+ (void)loadAddressBookByHttp{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSArray *addressBookArray = [TYAddressBook loadAddressBook];
            
            if (addressBookArray.count > 0) {
                
                NSString *parametersString = [NSString getJsonByData:addressBookArray];
                [JLGHttpRequest_AFN PostWithApi:@"jlsys/addressbook" parameters:@{@"contacts":parametersString} success:nil];
                
            }
            
        });
    });
}

#pragma mark - 解析数据的时候需要的，一般没有用
//防止解析不出数据崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    TYLog(@"没有定义的变量:%@ = %@",key,value);
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if (!value) {
        TYLog(@"空变量:%@ = %@",key,value);
    }else{
        [super setValue:value forKey:key];
    }
}

+(void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error)
                                                         {
                                                             TYLog(@"Error: %@", (__bridge NSError *)error);
                                                         }
                                                         else if (!granted)
                                                         {
                                                             
                                                             block(NO);
                                                         }
                                                         else
                                                         {
                                                             block(YES);
                                                         }
                                                     });
                                                 });
    }
    else
    {
        block(YES);
    }
    
}

@end
