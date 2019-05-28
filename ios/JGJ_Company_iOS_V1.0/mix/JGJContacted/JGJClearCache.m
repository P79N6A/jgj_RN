//
//  JGJClearCache.m
//  mix
//
//  Created by Tony on 2016/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJClearCache.h"
#import "SDImageCache.h"
@implementation JGJClearCache
+(void)clearTmpPicsData{
    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            [fileManager removeItemAtPath:absolutePath error:nil];
//        }
//    }
    
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *audioStr = [NSString stringWithFormat:@"%@/Documents/Audio",NSHomeDirectory()];
    NSString *ChatList = [NSString stringWithFormat:@"%@/Documents/jgj_chatlist_data.sqlite",NSHomeDirectory()];
//    添加要删除的资料文本路径
    NSString *docList = [NSString stringWithFormat:@"%@/Documents/downWord",NSHomeDirectory()];
    NSString *NotiFy = [NSString stringWithFormat:@"%@/Documents/notify.sqlite",NSHomeDirectory()];
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
//    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"pin.png"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:audioStr];
    if (!blHave) {
//        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:audioStr error:nil];
        if (blDele) {
//            [TYShowMessage showSuccess:@"缓存清除成功"];
        }else {
        }
        
    }
    if (!blHave) {
//        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:docList error:nil];
        if (blDele) {
            //            [TYShowMessage showSuccess:@"缓存清除成功"];
        }else {
        }
        
    }
    
    
    
    
    
    
    NSString *path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()]; // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    
    NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
    
    
    while((path=[myDirectoryEnumerator nextObject])!=nil)
        
    {
        if ([path containsString:@"doc"] || [path containsString:@"execl"] || [path containsString:@"pdf"]) {
            NSLog(@"%@",path);
            NSString *pathStr = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
            BOOL blHaves=[[NSFileManager defaultManager] fileExistsAtPath:pathStr];
            if (!blHaves) {
//                return ;
            }else {
                BOOL blDeles= [fileManager removeItemAtPath:pathStr error:nil];
                if (blDeles) {
                    //            [TYShowMessage showSuccess:@"缓存清除成功"];
                }else {
                }
                
            }
 
        }
        
    }
    
    
    
    BOOL Have=[[NSFileManager defaultManager] fileExistsAtPath:ChatList];
    if (!Have) {
//        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:audioStr error:nil];
        if (blDele) {
//            [TYShowMessage showSuccess:@"缓存清除成功"];
        }else {
        }
        
    }
    BOOL blHav=[[NSFileManager defaultManager] fileExistsAtPath:NotiFy];
    if (!blHav) {
//        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:audioStr error:nil];
        if (blDele) {
            [TYShowMessage showSuccess:@"缓存清除成功"];
        }else {
        }
        
    }

    
    
}
- (float)checkTmpSize
{
    NSString *audioStr = [NSString stringWithFormat:@"%@/Documents/Audio",NSHomeDirectory()];
    NSString *ChatList = [NSString stringWithFormat:@"%@/Documents/jgj_chatlist_data.sqlite",NSHomeDirectory()];
    NSString *word = [NSString stringWithFormat:@"%@/Documents/downWord",NSHomeDirectory()];

    NSString *NotiFy = [NSString stringWithFormat:@"%@/Documents/notify.sqlite",NSHomeDirectory()];
    
    //遍历文档
    NSString *path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()]; // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    
    
    long pdfData = 0;
    
    while((path=[myDirectoryEnumerator nextObject])!=nil)
        
    {
        NSData *pdfDataByte;
        if ([path containsString:@"doc"] || [path containsString:@"execl"] || [path containsString:@"pdf"]) {
            NSLog(@"%@",path);
            pdfDataByte = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path]];
            pdfData = pdfData + pdfDataByte.length/1024.000000/1024.000000;
 
        }
        
    }
    
    
    NSData *data = [NSData dataWithContentsOfFile:ChatList];
    NSData *data1 = [NSData dataWithContentsOfFile:NotiFy];
    float clearNum = 0;
    float wordclearNum = 0;

    float chatNum = 0.0;
    float chatLists = 0.0;
    chatLists = data1.length/1024.000000/1024.000000;
    chatNum = data.length/1024.00000/1024.000000;
    clearNum =[self datalenthFromPath:audioStr];
    wordclearNum = [self datalenthFromPath:word];
    float Num = [[SDImageCache sharedImageCache] getSize]/1024.000/1024.000;
    return clearNum + Num + wordclearNum + pdfData;
}

+ (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
}
-(float)datalenthFromPath:(NSString *)path
{
        
    
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    return folderSize/(1024*1024);
}
- (long long)fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
