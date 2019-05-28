//
//  JGJSelProAddressPopView.m
//  JGJCompany
//
//  Created by yj on 2017/5/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSelProAddressPopView.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

@interface JGJSelProAddressPopView ()

@property (weak, nonatomic) IBOutlet UILabel *addressTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *addressDetailLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proAddressPopViewH;
@property (weak, nonatomic) IBOutlet UIView *containDetailView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;

@end

@implementation JGJSelProAddressPopView

static JGJSelProAddressPopView *_addressPopView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.addressDetailLable.textColor = AppFont333333Color;

    [self.containDetailView.layer setLayerCornerRadius:5];
    
    self.addressDetailLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 40;
    
    self.addressTitleLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 40;
}

+ (JGJSelProAddressPopView *)selProAddressPopViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    if(_addressPopView && _addressPopView.superview) [_addressPopView removeFromSuperview];
    _addressPopView = [[[NSBundle mainBundle] loadNibNamed:@"JGJSelProAddressPopView" owner:self options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _addressPopView.frame = window.bounds;
    
    
    NSString *proVeiwTitle = [NSString stringWithFormat:@"请确认  %@  的项目地址",commonModel.headerTitle];

    _addressPopView.addressTitleLable.text = proVeiwTitle;
    
    [_addressPopView .addressTitleLable markText:commonModel.headerTitle withColor:AppFont333333Color];

     _addressPopView.addressDetailLable.text = commonModel.alertmessage;
    
    _addressPopView.addressDetailLable.textAlignment = commonModel.alignment;
    
    _addressPopView.addressTitleLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    _addressPopView.addressDetailLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    _addressPopView.addressTitleLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 40;
    
    _addressPopView.addressDetailLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 40;
    
    CGFloat titleHeight = [NSString stringWithContentWidth:TYGetUIScreenWidth - 40 content:proVeiwTitle font:AppFont28Size];
    
    _addressPopView.titleH.constant = 36;
    
    if (commonModel.alertViewHeight > 0) {
        
        _addressPopView.proAddressPopViewH.constant = commonModel.alertViewHeight;
    }else {
        
        CGFloat height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 40 content:commonModel.alertmessage font:AppFont30Size];
        
        height = height > 18 ? height : height;
        
        commonModel.alertViewHeight = height + 170 + titleHeight;
        
        _addressPopView.proAddressPopViewH.constant = commonModel.alertViewHeight;
    }
    
    
    [window addSubview:_addressPopView];
    
    return _addressPopView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (IBAction)handleCancelButtonPressed:(UIButton *)sender {
    
    [self dismiss];
}

- (IBAction)handleConfirmButtonPressed:(UIButton *)sender {
    
    if (self.handleSelProAddressPopViewBlock) {
        
        self.handleSelProAddressPopViewBlock(self);
    }
    
    [self dismiss];
    
}



- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _addressPopView.transform = CGAffineTransformScale(_addressPopView.transform,0.9,0.9);
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
