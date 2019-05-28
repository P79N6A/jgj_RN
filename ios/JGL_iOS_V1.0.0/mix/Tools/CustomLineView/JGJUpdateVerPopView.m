//
//  JGJUpdateVerPopView.m
//  JGJCompany
//
//  Created by yj on 16/12/7.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUpdateVerPopView.h"
#import "UILabel+GNUtil.h"
#define ContainViewH 206
#define ContainViewW 222
static JGJUpdateVerPopView *_popView;
@interface JGJUpdateVerPopView ()
@property (weak, nonatomic) IBOutlet UILabel *popTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *popDetailLable;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonH;
@property (strong, nonatomic) JGJUpdateVerInfoModel *verInfoModel;
@end

@implementation JGJUpdateVerPopView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.updateButton.backgroundColor = [UIColor whiteColor];
    self.popTitleLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.popDetailLable.font = [UIFont systemFontOfSize:AppFont26Size];
    self.popTitleLable.textColor = AppFont666666Color;
    self.popDetailLable.textAlignment = NSTextAlignmentLeft;
    self.containView.backgroundColor = [UIColor whiteColor];
    [self.containView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.popDetailLable.preferredMaxLayoutWidth = ContainViewW;
}

+ (JGJUpdateVerPopView *)updateDesViewWithDesModel:(JGJShareProDesModel *)desModel updateVerInfoModel:(JGJUpdateVerInfoModel *)verInfoModel {
    if(_popView && _popView.superview) [_popView removeFromSuperview];
    _popView = [[[NSBundle mainBundle] loadNibNamed:@"JGJUpdateVerPopView" owner:self options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _popView.frame = window.bounds;
    [window addSubview:_popView];
    _popView.popTitleLable.text = desModel.popTitle;
    _popView.popDetailLable.text = verInfoModel.upinfo;
    [_popView.popDetailLable setAttributedText:verInfoModel.upinfo lineSapcing:5.0 textAlign:NSTextAlignmentLeft];
    _popView.verInfoModel = verInfoModel;
    _popView.cancelButton.hidden = verInfoModel.forceUpdate == 2;
    _popView.cancelButtonH.constant =  verInfoModel.forceUpdate == 2 ? 0 : 50;
    
    CGFloat popDetailHeight = [NSString stringWithContentWidth:ContainViewW content:verInfoModel.upinfo font:AppFont26Size lineSpace:5];
    
    _popView.containViewH.constant = popDetailHeight + ContainViewH;
    
    return _popView;
}

- (IBAction)handleCancelButtonPressed:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)handleUpdateButtonPressed:(UIButton *)sender {
   NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/app/id1080590044"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _popView.transform = CGAffineTransformScale(_popView.transform,0.9,0.9);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (hitView==self) {
        [self dismiss];
    }
}
@end
