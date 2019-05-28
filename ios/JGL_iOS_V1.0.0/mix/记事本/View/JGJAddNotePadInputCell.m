//
//  JGJAddNotePadInputCell.m
//  mix
//
//  Created by Tony on 2019/3/11.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJAddNotePadInputCell.h"

@interface JGJAddNotePadInputCell ()<YYTextViewDelegate>

@end
@implementation JGJAddNotePadInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.inputContentView];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_inputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
        
    }];
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    //其实你可以加在这个代理方法中。当你将要编辑的时候。先执行这个代理方法的时候就可以改变间距了。这样之后输入的内容也就有了行间距。
    
    if (textView.text.length < 1) {
        textView.text = @"间距";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:AppFont32Size],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    if ([textView.text isEqualToString:@"间距"]) {           //之所以加这个判断是因为再次编辑的时候还会进入这个代理方法，如果不加，会把你之前输入的内容清空。你也可以取消看看效果。
        textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];//主要是把“间距”两个字给去了。
    }
    return YES;
}

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    
    // 这里有个坑,如果直接更新整个attributedText(在前面设置行高是更新了整个attributedText)，可能会导致选中范围的改变。这可以重新设置一下 inputContentView.selectedRange 来修改选中区域
    self.inputContentView.selectedRange = NSMakeRange(textView.text.length, 0);
}

//- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if ([self.delegate respondsToSelector:@selector(inputContentViewInputWithText:)]) {
//        
//        [self.delegate inputContentViewInputWithText:textView.text];
//    }
//    return YES;
//}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(inputContentViewInputWithText:)]) {
        
        [self.delegate inputContentViewInputWithText:textView.text];
    }
}

- (YYTextView *)inputContentView {
    
    if (!_inputContentView) {
        
        _inputContentView = [[YYTextView alloc] init];
        _inputContentView.placeholderText = @"马上记事...";
        _inputContentView.textAlignment = NSTextAlignmentLeft;
        _inputContentView.placeholderFont = FONT(AppFont32Size);
        _inputContentView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _inputContentView.backgroundColor = [UIColor whiteColor];
        _inputContentView.showsVerticalScrollIndicator = NO;
        _inputContentView.font = FONT(AppFont32Size);
        _inputContentView.delegate = self;
        [_inputContentView becomeFirstResponder];
        
    }
    return _inputContentView;
}


@end
