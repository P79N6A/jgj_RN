//
//  PopBox_NormalView.m
//  HuDuoDuoCustomer
//
//  Created by Tony on 15/8/26.
//  Copyright (c) 2015年 celion. All rights reserved.
//

#import "PopBox_NormalView.h"
#import "Masonry.h"

@interface PopBox_NormalView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
@implementation PopBox_NormalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        // Initialization code
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:@"PopBox_NormalView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.backgroundColor = [UIColor clearColor];

    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
}

-(void)setButton:(UIButton *)button Color:(UIColor *)color{
    button.layer.borderColor = color.CGColor;

    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 3;
}

//绘画
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.contentView.frame = self.bounds;
}

- (void)setPopBoxNormalMessage:(id)message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString{
    if ([message isKindOfClass:[NSString class]]) {
        self.messageLabel.text = message;
        
        //如果有换行符就设置行间距
        if ([message rangeOfString:@"\n"].location !=NSNotFound) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:6];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
            self.messageLabel.attributedText = attributedString;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
        }
    }else{
        self.messageLabel.attributedText = message;
    }
    
    cancelString?[self.leftButton setTitle:cancelString forState:UIControlStateNormal]:@"";
    destructiveString?[self.rightButton setTitle:destructiveString forState:UIControlStateNormal]:@"";
}

- (IBAction)cancelBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(PopBoxNormalViewCancel)]) {
        [self.delegate PopBoxNormalViewCancel];
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(PopBoxNormalViewConfirm)]) {
        [self.delegate PopBoxNormalViewConfirm];
    }
}

@end

