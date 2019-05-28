//
//  JGJTextViewTool.h
//  mix
//
//  Created by YJ on 16/12/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

@interface JGJTextViewTool : UITextView

/**
 *  处理插入的信息
 */
+ (void)inputTextView:(UITextView *)inputTextView insertTextView:(NSString *)insertText;
/**
 *  返回@标记
 *  删除@信息
 */
+ (NSString *)inputView:(UITextView *)inputView handleAtMesage:(NSString *)atMesage;
@end
