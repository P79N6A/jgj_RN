//
//  TYInputView.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYInputView.h"
#import "NSString+Extend.h"

#import "JGJChatListBaseCell.h"

#import "HWEmotion.h"

#import "HWEmotionAttachment.h"


@interface TYInputView ()
<
    UITextViewDelegate
>

/**
 *  占位文字View: 为什么使用UITextView，这样直接让占位文字View = 当前textView,文字就会重叠显示
 */
@property (nonatomic, weak) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

/**
 *  文字的长度用于判断是否是删除状态
 */
@property (nonatomic, assign) NSInteger lastTextLength;

@end

@implementation TYInputView

//- (UIResponder *)nextResponder {
//    if (_inputNextResponder != nil)
//        return _inputNextResponder;
//    else
//        return [super nextResponder];
//}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //
    if (self.targetCell) {
        NSArray<NSString *> *menuActionNames = self.menuItemActionNames;
        
        for (NSInteger i = 0; i < menuActionNames.count; i++) {
            
            if (action == NSSelectorFromString(menuActionNames[i])) {
                
                return YES;
                
            }
        }
        
        return NO;//隐藏系统默认的菜单项
        
    }
    
    else {
        
        return [super canPerformAction:action withSender:sender];
    }
    
    
}

- (NSArray<NSString *> *)menuItemNames {
    
    return @[@"复制", @"删除", @"重发", @"撤回",@"转发"];
}

- (NSArray<NSString *> *)menuItemActionNames {
    return @[@"copyClick:", @"deleteClicked:", @"resendClick:", @"revocationClicked:",@"forwardClick:"];
}

//撤回
-(void)revocationClicked:(id)sender {
    
    JGJChatListBaseCell *basecell = (JGJChatListBaseCell *)self.targetCell;
    
    [basecell revocationClicked:sender];
    
}

//删除
-(void)deleteClicked:(id)sender {
    
    JGJChatListBaseCell *basecell = (JGJChatListBaseCell *)self.targetCell;
    
    [basecell deleteClicked:sender];
    
}

//重发
-(void)resendClick:(id)sender {
    
    JGJChatListBaseCell *basecell = (JGJChatListBaseCell *)self.targetCell;
    
    [basecell resendClick:sender];
    
}

//复制
-(void)copyClick:(id)sender {
    
    JGJChatListBaseCell *basecell = (JGJChatListBaseCell *)self.targetCell;
    
    [basecell copyClick:sender];
    
}

/** 转发 */
- (void)forwardClick:(id)sender {
    
    JGJChatListBaseCell *basecell = (JGJChatListBaseCell *)self.targetCell;
    
    [basecell forwardClick:sender];
}


- (UITextView *)placeholderView
{
    if (_placeholderView == nil) {
        UITextView *placeholderView = [[UITextView alloc] init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeholderView];
        [_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(5);
        }];
    }
    return _placeholderView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}
- (void)setup
{
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = NO;
    self.delegate = self;
    
    self.maxNumberOfLines = 100;
    
    self.maxNumberOfWords = MAXFLOAT;
    
//    self.maxTextLineHeight = TYIS_IPHONE_5 ? 190.0 : 400.0;
    
    self.maxTextLineHeight = 110;
    
//    self.maxTextLineHeight = self.font.lineHeight * 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    //调整光标初始位置
    self.textContainerInset = UIEdgeInsetsMake(12, 0, 0, 0);
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setTy_textHeightChangeBlock:(void (^)(NSString *, CGFloat))ty_textChangeBlock
{
    _ty_textHeightChangeBlock = ty_textChangeBlock;
    
    [self textDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = _placeholderColor;
    self.tintColor = _placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
}

- (void)setPlaceholderFontSize:(CGFloat)placeholderFontSize{
    _placeholderFontSize = placeholderFontSize;
    
    self.placeholderView.font = [UIFont systemFontOfSize:placeholderFontSize];
}

- (void)textDidChange
{
    //当前是删除状态，用于@人员使用。解决删除信息时遇见@符号的时候不跳转到@人员列表

    self.isDelStatus = self.lastTextLength > self.text.length;
    
    self.lastTextLength = self.text.length;
        
    if (_ty_textReturn && [self textIsReturn:self]) {
        //没有数据直接返回
        if ([NSString isEmpty:self.text]) {
            return;
        }
        
        //有block并且，是回车才继续
        _ty_textReturn(self);
        return;
    }

    // 占位文字是否显示
    self.placeholderView.hidden = self.text.length > 0;
    
    if (self.text.length > self.maxNumberOfWords)
    {
        self.text = [self.text substringToIndex:self.maxNumberOfWords];
        return;
    }
    
    if (self.text.length > self.maxNumberOfWords) {
        return;
    }
    
    if (_ty_textChange) {
        NSString *lastStr = self.text.length > 1?[self.text substringFromIndex:self.text.length - 1]:self.text;
        _ty_textChange(self,self.text,lastStr);
    }
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height) + 1.0;
    
    //大于最大高度不变滚动
    if (height > self.maxTextLineHeight) {
        
        self.scrollEnabled = YES;
        
        height = self.maxTextLineHeight;
        
        _textH = height;
        
        if (_ty_textHeightChangeBlock) {
            
            _ty_textHeightChangeBlock(self.text,_textH);
            
            [self.superview layoutIfNeeded];
            
        }
        
        return;
    }
 
#pragma mark - 设置光标跟随移动和无线增长高度
    if (_textH != height) { // 高度不一样，就改变了高度
#pragma mark - 此处以前为yes  但是改为了输入框自适应后可以设置为no 避免粘贴过多字符串时显示文本空白

        // 最大高度，可以滚动
        if (self.canScorll) {
            self.scrollEnabled = YES;
            
        }else{
            self.scrollEnabled = NO;
        }
        
        _textH = height;
        
        if (_ty_textHeightChangeBlock) {
            _ty_textHeightChangeBlock(self.text,_textH);
            [self.superview layoutIfNeeded];
        }else if(self.canScorll){
            [self.superview layoutIfNeeded];
        }
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    if (text.length == 1) {
       
        self.isDelStatus = NO;
        
    }else {
    
        self.isDelStatus = YES;
    }
    
    //这个判断相当于是textfield中的点击return的代理方法
    if ([text isEqualToString:@"\n"]) {
        
        if (_ty_textReturn) {
            //有block并且，是回车才继续
            _ty_textReturn(self);
        }
        return self.canReturn;
    }

    return YES;
}

- (void)deleteBackward{
    [super deleteBackward];
    if (_ty_textDelete) {
        //有block并且，是回车才继续
        _ty_textDelete(self);
    }
    
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (BOOL)textIsReturn:(UITextView *)textView
{

    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)insertEmotion:(HWEmotion *)emotion
{
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 加载图片
        HWEmotionAttachment *attch = [[HWEmotionAttachment alloc] init];
        
        // 传递模型
        attch.emotion = emotion;
        
        // 设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
}

- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        HWEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}

- (void)setIsShowDraft:(BOOL)isShowDraft {
    
    _isShowDraft = isShowDraft;
    
    NSInteger height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 142 content:self.text?:@"" font:AppFont32Size lineSpace:1.8];
    
    if (_isShowDraft) {
        
        //        if (!self.isFirstResponder) {
        //
        //            [self becomeFirstResponder];
        //        }
        
        
        //大于最大高度不变滚动
        if (height > self.maxTextLineHeight) {
            
            self.scrollEnabled = YES;
            
            if (_ty_textHeightChangeBlock) {
                
                _ty_textHeightChangeBlock(self.text,self.maxTextLineHeight);
                
            }
            
        }else {
            
            if (_ty_textHeightChangeBlock) {
                
                _ty_textHeightChangeBlock(self.text,height);
                
            }
        }
        
        //延时的目的是设置contentSize
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self scrollRangeToVisible:NSMakeRange(self.text.length, 1)];
            
            self.layoutManager.allowsNonContiguousLayout = NO;
            
            self.contentSize = CGSizeMake(TYGetUIScreenWidth - 141, height + 46);
            
            self.scrollEnabled = YES;
            
        });
        
        [self.superview layoutIfNeeded];
        
        TYLog(@"height =======%@", @(height));
    }
    
}

@end
