//
//  JGJTextViewTool.m
//  mix
//
//  Created by YJ on 16/12/4.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTextViewTool.h"
#import "NSString+Extend.h"
@interface JGJTextViewTool ()
/**
 * @文字范围
 */
@property (nonatomic, strong) NSMutableArray *inputViewInfoArray;
@end

@implementation JGJTextViewTool

static JGJTextViewTool *_textViewTool;
+ (void)initialize {
    if (!_textViewTool) {
         _textViewTool = [[self alloc] init];
    }
}
+ (void)inputTextView:(UITextView *)inputTextView insertTextView:(NSString *)insertText {
    NSString *mergeStr = [NSString stringWithFormat:@"%@ ", insertText];
    NSUInteger inputViewlocation = inputTextView.selectedRange.location;
    NSMutableAttributedString *mergeInputText = [[NSMutableAttributedString alloc] init];
    NSAttributedString *inputText = [[NSAttributedString alloc] initWithString:mergeStr attributes:@{NSFontAttributeName:inputTextView.font}];
    [mergeInputText appendAttributedString:inputTextView.attributedText];
    //插入文字到当前光标位置
    [mergeInputText insertAttributedString:inputText atIndex:inputViewlocation];
    //获取当前光标位置
    NSUInteger currentlocation = inputTextView.selectedRange.location;
    //获取当前插入文字的长度
    NSUInteger length = mergeStr.length;
    JGJChatInputViewInfoModel *infoModel = [[JGJChatInputViewInfoModel alloc] init];
    //取得当前文字的范围
    infoModel.selectedRange = NSMakeRange(currentlocation - 1,  length );
    infoModel.inputStr = [[NSMutableAttributedString alloc] initWithString:mergeStr];;
    [_textViewTool.inputViewInfoArray addObject:infoModel];
    
    inputTextView.text = mergeInputText.string;
    inputTextView.attributedText = mergeInputText;
    //设置光标到当前位置
    inputTextView.selectedRange = NSMakeRange(currentlocation + length, 0);
}

+ (NSString *)inputView:(UITextView *)inputView handleAtMesage:(NSString *)atMesage {
    NSUInteger selectedLoc = inputView.selectedRange.location;
    //获取光标前一个文字
    NSString *changeStr = [inputView.text substringWithRange:NSMakeRange(selectedLoc - 1, 1)];
    NSMutableAttributedString *mergeInputText = [[NSMutableAttributedString alloc] init];
    [mergeInputText appendAttributedString:inputView.attributedText];
//    NSUInteger inputViewlocation = inputView.selectedRange.location;
//    NSArray *selelctedInputArrays = _textViewTool.inputViewInfoArray.copy;
//    for (JGJChatInputViewInfoModel *infoModel in selelctedInputArrays) {
//        NSUInteger length = infoModel .inputStr.length;
//        NSUInteger lessLoc = infoModel.selectedRange.location;
//        NSUInteger greatLoc = infoModel.selectedRange.location + length;
//        //在光标范围内删除@信息
//        if (lessLoc <= inputViewlocation && greatLoc >= inputViewlocation && ![NSString isEmpty:mergeInputText.string]) {
//            infoModel.inputStr = [[NSMutableAttributedString alloc] initWithString:@""];
//            if (mergeInputText.string.length >= infoModel.selectedRange.location + infoModel.selectedRange.length) {
//                 [mergeInputText replaceCharactersInRange:infoModel.selectedRange withString:@""];
//            }
//            inputView.attributedText = mergeInputText;
//            [_textViewTool.inputViewInfoArray removeObject:infoModel];
//            if (lessLoc != 0) {
//                 inputView.selectedRange = NSMakeRange(lessLoc, 0);
//            }
//            if ([changeStr isEqualToString:@"@"]) {
//                changeStr = nil; //在光标范围内遇见@返回nil
//            }
//        }
//    }
    return changeStr;
}

- (NSMutableArray *)inputViewInfoArray {
    if (!_inputViewInfoArray) {
        _inputViewInfoArray = [NSMutableArray array];
    }
    return _inputViewInfoArray;
}

@end
