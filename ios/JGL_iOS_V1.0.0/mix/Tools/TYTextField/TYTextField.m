//
//  TYTextField.m
//  mix
//
//  Created by Tony on 15/12/31.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYTextField.h"
#import "UIView+GNUtil.h"

@implementation TYTextField

+ (void)textFieldDidBeginEditingColor:(UITextField *)textField color:(UIColor *)color{
    textField.layer.cornerRadius  = 4.0f;
    textField.layer.borderWidth   = 0.5f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor   = color.CGColor;
}

+ (void)textFieldDidEndEditing:(UITextField *)textField color:(UIColor *)color{
    textField.layer.cornerRadius  = 4.0f;
    textField.layer.borderWidth   = 0.5f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor   = color.CGColor;
}

@end

@implementation BaseTextField

- (void)customInit {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        [self customInit];
    }
    
    return self;
}

- (void)markText:(NSString *)t withColor:(UIColor *)c
{
    NSString *text = self.text;
    if (t == nil || t.length == 0) {
        return;
    }
    if (text) {
        NSArray *arr = [text componentsSeparatedByString:t];
        if (arr.count < 2) return;
        
        NSRange rangeLeft = NSMakeRange(0, [arr[0] length]);
        NSRange rangeMiddle = NSMakeRange(rangeLeft.length, t.length);
        NSRange rangeRight = NSMakeRange(rangeLeft.length + rangeMiddle.length, [arr[1] length]);
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeLeft];
        [str addAttribute:NSForegroundColorAttributeName value:c range:rangeMiddle];
        [str addAttribute:NSForegroundColorAttributeName value:self.textColor range:rangeRight];
        
        [str addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
        self.attributedText = str;
    }
}

@end


@implementation NormalTextField

- (void)customInit {
    
    NSString *place = self.placeholder;
    if (place) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:place attributes:@{NSForegroundColorAttributeName: TYColorHex(0Xb8b8b8),NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    
    self.textColor = TYColorHex(0X333e4c);
    self.font = [UIFont systemFontOfSize:15];
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webViewFailure_Image"]];
    self.rightView = imgView;
    
}

@end

@implementation LengthLimitTextField

- (void)customInit {
    
    self.maxLength = NSIntegerMax;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [super customInit];
    
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self) {
        
        NSString *toBeString = textField.text;
        
        NSString *lang = [self.textInputMode primaryLanguage]; // 键盘输入模式
        
        if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if(!position) {
                if(toBeString.length > self.maxLength) {
                    textField.text = [toBeString substringToIndex:self.maxLength];
                }else{
                    if (self.valueDidChange) {
                        self.valueDidChange(textField.text);
                    }
                }
            }else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if(toBeString.length > self.maxLength) {
                textField.text= [toBeString substringToIndex:self.maxLength];
            }else{
                if (self.valueDidChange) {
                    self.valueDidChange(textField.text);
                }
            }
        }
    }
}

@end

@implementation JGJCustomSearchBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        
        [self commonInit];
    }
    
    return self;
}

- (void)setAddSearchBarItem {
    
    UIButton *cancelButton = [UIButton new];
    self.cancelButton = cancelButton;
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:AppFontd5252cColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelButton];
    
    LengthLimitTextField *searchBarTF = [LengthLimitTextField new];
    self.searchBarTF = searchBarTF;
    searchBarTF.placeholder = @"请输入文档名称进行搜索";
    [self addSubview:searchBarTF];
    
    searchBarTF.font = [UIFont systemFontOfSize:AppFont28Size];
    searchBarTF.layer.borderWidth = 0;
    searchBarTF.layer.cornerRadius = 3;
    searchBarTF.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    searchBarTF.backgroundColor = TYColorHex(0Xf3f3f3);
    searchBarTF.backgroundColor = AppFontf1f1f1Color;
    searchBarTF.maxLength = 20;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.width = 33;
    searchIcon.height = 33;
    searchBarTF.leftViewMode = UITextFieldViewModeAlways;
    searchBarTF.leftView = searchIcon;
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(0);
    }];
    
    [searchBarTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(cancelButton.mas_left).offset(-12);
        make.height.mas_equalTo(33);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = AppFontf1f1f1Color;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(self);
        make.right.mas_equalTo(cancelButton.mas_right);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setIsAddedNavbar:(BOOL)isAddedNavbar {
    
    _isAddedNavbar = isAddedNavbar;
    
    if (_isAddedNavbar) {
        
        [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(55, TYGetViewH(self) - 1));
        }];
        
        [self.searchBarTF mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(self.cancelButton.mas_left);
        }];
        
    }
    
}

- (void)setIsShowSearchBarTop:(BOOL)isShowSearchBarTop {
    
    _isShowSearchBarTop = isShowSearchBarTop;
    
    if (_isShowSearchBarTop) {
        
        [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(55, TYGetViewH(self) - 1));
            make.right.mas_equalTo(0);
        }];
        
        [self.searchBarTF mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-55);
        }];
        
        self.cancelButton.hidden = NO;
        
    }else {
        
        self.cancelButton.hidden = YES;
        
        [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(0, 0));
            
            make.right.mas_equalTo(0);
        }];
        
        [self.searchBarTF mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-12);
            
        }];
        
        
    }
    
}

- (void)cancelButtonPressed:(UIButton *)button {
    
    if (self.handleButtonPressedBlcok) {
        self.handleButtonPressedBlcok(self);
    }
}

- (void)commonInit {
    
    self.backgroundColor = [UIColor whiteColor];
    [self setAddSearchBarItem];
}


@end
