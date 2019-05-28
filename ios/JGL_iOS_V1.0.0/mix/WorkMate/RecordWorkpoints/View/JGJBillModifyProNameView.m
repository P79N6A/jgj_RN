//
//  JGJBillModifyProNameView.m
//  mix
//
//  Created by yj on 16/7/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBillModifyProNameView.h"
#import "TYTextField.h"
#import "NSString+Extend.h"
#import "CALayer+SetLayer.h"

@interface JGJBillModifyProNameView ()
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *proName;

@end
@implementation JGJBillModifyProNameView

static JGJBillModifyProNameView *containView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.containView.backgroundColor = [UIColor whiteColor];
    self.containView.layer.cornerRadius = 6;
    self.containView.layer.masksToBounds = YES;
    self.messageLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.messageLable.textColor = AppFont666666Color;
    self.proName.maxLength = 15;
    [self.proName.layer setLayerBorderWithColor:TYColorHex(0xdbdbdb) width:0.5 radius:4.0];
    [TYNotificationCenter addObserver:self selector:@selector(AddContactsKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

// 3.1.0增加的项目名称带入
- (void)setTheModifyProjectName:(NSString *)theModifyProjectName {
    
    _theModifyProjectName = theModifyProjectName;
    self.proName.text = _theModifyProjectName;
    [self.proName becomeFirstResponder];
}
#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)AddContactsKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat distance =  beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        if (distance > 0) {
            self.containView.transform = CGAffineTransformMakeTranslation(0, -40);
        } else {
            self.containView.transform = CGAffineTransformIdentity;
        }
    }];
}

+ (JGJBillModifyProNameView *)JGJBillModifyProNameViewShowWithMessage:(NSString *)message {
    
    if(containView && containView.superview) [containView removeFromSuperview];
    containView = [[[NSBundle mainBundle] loadNibNamed:@"JGJBillModifyProNameView" owner:self options:nil] lastObject];
    containView.messageLable.text = message;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    containView.frame = window.bounds;
    [window addSubview:containView];
    return containView;
}
- (IBAction)didClickedButtonPressed:(UIButton *)sender {
    if ([NSString isEmpty:self.proName.text]) {
        [TYShowMessage showError:@"请输入项目名称"];
        return;
    }
    if (self.onClickedBlock) {
        self.onClickedBlock(self.proName.text);
    }
    [self dismiss];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _containView.transform = CGAffineTransformScale(_containView.transform,0.9,0.9);
        
    } completion:^(BOOL finished) { 
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismiss];
}

@end
