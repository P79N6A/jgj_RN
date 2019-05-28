//
//  JGJRPWelfareTableViewCell.m
//  mix
//
//  Created by Tony on 16/4/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJRPWelfareTableViewCell.h"
#import "TYFMDB.h"
#import "NSString+Extend.h"
static const NSInteger JGJBaseTag = 20;
static const CGFloat JGJWorkTypeLineWitdh = 0.2;
static const CGFloat JGJRPWelfareMarginValue = 10;

@implementation JGJRPWelfareModel : TYModel
@end

//定义按钮的类
@interface JGJWelfareTypeButton : UIButton
@end
@implementation JGJWelfareTypeButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self setTitleColor:TYColorHex(0x8b8b8b) forState:UIControlStateNormal];
    [self setTitleColor:JGJMainColor forState:UIControlStateSelected];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIColor *borderColor = self.selected?JGJMainColor:TYColorHex(0x8b8b8b);
    [self.layer setLayerBorderWithColor:borderColor width:JGJWorkTypeLineWitdh ration:0.1];
}

- (CGSize)sizeForButton {
    //宽度加 marginValue 为了两边圆角。
    CGSize labelSize = CGSizeMake([self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + JGJRPWelfareMarginValue, 3*JGJRPWelfareMarginValue);
    return labelSize;
}
@end

@interface JGJRPWelfareTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextField *WelfareTF;
@property (weak, nonatomic) IBOutlet UILabel *welfareTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addWelfareButton;

@end

@implementation JGJRPWelfareTableViewCell
@synthesize WelfaresArray = _WelfaresArray;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addWelfareButton.backgroundColor = JGJMainColor;
    [self.addWelfareButton.layer setLayerCornerRadiusWithRatio:0.05];
    [self.addWelfareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (IBAction)addWelfareBtnClick:(UIButton *)sender {
    if (!self.WelfareTF.text || [NSString isEmpty:self.WelfareTF.text]) {
        [TYShowMessage showPlaint:@"请输入你需要的福利"];
        return ;
    }
    
    //判断是否添加过
    __block BOOL isSame = NO;
    [self.WelfaresArray enumerateObjectsUsingBlock:^(JGJRPWelfareModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:self.WelfareTF.text]) {
            [TYShowMessage showPlaint:@"已经添加过该标签"];
            *stop = YES;
            isSame = YES;
        }
    }];
    if (isSame) {//是相同的标签
        return ;
    }
    
    JGJRPWelfareModel *lastJGJRPwelfare = [self.WelfaresArray lastObject];
    JGJRPWelfareModel *jgjRPwelfare = [[JGJRPWelfareModel alloc] init];
    jgjRPwelfare.id = lastJGJRPwelfare.id + 1;
    jgjRPwelfare.name = self.WelfareTF.text;
    jgjRPwelfare.selected = YES;
    [self.WelfaresArray addObject:jgjRPwelfare];
    
    self.WelfareTF.text = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJAddWelfareBtnClick:)]) {
        [self.delegate JGJAddWelfareBtnClick:self];
    }
}

- (void)setWelfaresArray:(NSMutableArray *)WelfaresArray{
    _WelfaresArray = WelfaresArray;
    if (WelfaresArray.count != 0) {
        [self addSubWelfaresButton];
    }
}

- (void)addSubWelfaresButton{
    //获取之前的按钮的x,y，如果没有就从最开始计算
    __block JGJWelfareTypeButton *oldWelfareTypeButton;
    [self.contentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JGJWelfareTypeButton class]]) {
            oldWelfareTypeButton = obj;
            *stop = YES;
        }
    }];
    
    CGFloat labelx = JGJRPWelfareMarginValue + (oldWelfareTypeButton?TYGetMaxX(oldWelfareTypeButton):0);
    CGFloat labely = oldWelfareTypeButton?TYGetMinY(oldWelfareTypeButton):(TYGetMaxY(self.welfareTitleLabel) + JGJRPWelfareMarginValue);
    
    self.viewH = 0;
    CGSize labelSize;

    JGJWelfareTypeButton *lastedWelfareTypeButton;
    for (NSInteger index = oldWelfareTypeButton?(oldWelfareTypeButton.tag - JGJBaseTag + 1):0; index < self.WelfaresArray.count; index++) {
        JGJRPWelfareModel *jgjRPWelfareModel = self.WelfaresArray[index];
        NSString *labelStr = jgjRPWelfareModel.name;
        

        //计算宽高
        JGJWelfareTypeButton *jgjWelfareTypeButton = [[JGJWelfareTypeButton alloc] init];
        jgjWelfareTypeButton.tag = JGJBaseTag + index;
        [jgjWelfareTypeButton setTitle:labelStr forState:UIControlStateNormal];
        labelSize = [jgjWelfareTypeButton sizeForButton];
        if ((labelx + labelSize.width + JGJRPWelfareMarginValue) > TYGetUIScreenWidth) {
            labelx = JGJRPWelfareMarginValue;
            labely += JGJRPWelfareMarginValue + labelSize.height;
        }
        
        jgjWelfareTypeButton.frame = CGRectMake(labelx, labely, labelSize.width,labelSize.height);
        
        [self.contentView addSubview:jgjWelfareTypeButton];
        
        if ((labelx + labelSize.width + JGJRPWelfareMarginValue) <= TYGetUIScreenWidth) {
            labelx += JGJRPWelfareMarginValue + labelSize.width;
        }
        
        jgjWelfareTypeButton.selected = jgjRPWelfareModel.selected;
        [jgjWelfareTypeButton addTarget:self action:@selector(jgjWelfareTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (index + 1 == self.WelfaresArray.count) {
            lastedWelfareTypeButton  = jgjWelfareTypeButton;
        }
    }
    

    self.viewH = TYGetMaxY(lastedWelfareTypeButton) + 50;
}

- (void)jgjWelfareTypeBtnClick:(JGJWelfareTypeButton *)sender{
    sender.selected = !sender.selected;
    JGJRPWelfareModel *jgjRPWelfare = (JGJRPWelfareModel *)self.WelfaresArray[sender.tag - JGJBaseTag];
    jgjRPWelfare.selected = sender.selected;
    if ([self.delegate respondsToSelector:@selector(JGJWelfareTypeBtnClick:)]) {
        [self.delegate JGJWelfareTypeBtnClick:self];
    }
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    

    
    if (textField.tag==3)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 8) {
            textField.text = [toBeString substringToIndex:8];
            return NO;
        }
    }
    
    return YES;
    
}
@end
