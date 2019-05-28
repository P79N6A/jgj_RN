//
//  JGJHistoryText.m
//  JGJCompany
//
//  Created by Tony on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHistoryText.h"
#import "NSString+Extend.h"
@implementation JGJHistoryText
+(void)saveWithKey:(NSString *)saveKey andContent:(NSString *)content
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
////    NSDictionary *textDic = [NSDictionary dictionary];
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [path objectAtIndex:0];
//    NSString *plistPath = [filePath stringByAppendingPathComponent:@"HistoryText.plist"];
//////    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
//// NSMutableDictionary  *textDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
//////    [textDic setValue:content forKey:saveKey];
////    [textDic setObject:content forKey:saveKey];
////    [textDic writeToFile:plistPath atomically:YES];
////
////    NSString *path = NSHomeDirectory();
////    
////     NSString *plistPath = [path stringByAppendingPathComponent:@"HistoryTexts.plist"];
////    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HistoryText" ofType:@"plist"];
//    NSMutableDictionary *textDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    [textDic setObject:content forKey:saveKey];
//     [textDic writeToFile:plistPath atomically:YES];
//    
    
    
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    if ([NSString isEmpty:cachePath]) {
        
        return;
    }
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"historyContent.plist"];
    NSMutableDictionary*dict = [[NSMutableDictionary alloc]init];
    dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePathName];
    [dict setObject:content?:@"" forKey:saveKey];
    [dict writeToFile:filePathName atomically:YES];
    


}
+(NSString *)readWithkey:(NSString *)readKey
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    
//    NSDictionary *textDic = [NSDictionary dictionary];
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [path objectAtIndex:0];
//    //把TestPlist文件加入
//    NSString *plistPath = [filePath stringByAppendingPathComponent:@"HistoryText.plist"];
//    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
//    textDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"historyContent.plist"];
    NSMutableDictionary*dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePathName];
    NSString *content = [dict objectForKey:readKey];
    if (![NSString isEmpty:content]) {
        return [@"  " stringByAppendingString:content];
    }else{
        return @"";
    }
}
+(void)clean
{
    NSArray*array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString*cachePath = array[0];
    NSString*filePathName = [cachePath stringByAppendingPathComponent:@"historyContent.plist"];
    
    NSMutableDictionary*dict = [[NSMutableDictionary alloc]init];
    [dict writeToFile:filePathName atomically:YES];


}
@end
