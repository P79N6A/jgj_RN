//
//  JGJMergeProPopView.m
//  JGJCompany
//
//  Created by yj on 16/9/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMergeProPopView.h"
#import "TYTextField.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"

#define MergeBeforeNameDefaultHeight 72.0
static JGJMergeProPopView *_mergeProPopView;
@interface JGJMergeProPopView ()
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIView *containDetailView;
@property (strong, nonatomic) JGJMergeProRequestModel *mergeProRequestModel;
@property (weak, nonatomic) IBOutlet UILabel *mergeBeforeName;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *mergeAfterNameTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containdetailViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containdetailViewCenterY;

@end

@implementation JGJMergeProPopView

- (instancetype)initWithFrame:(CGRect)frame mergeProRequestModel:(JGJMergeProRequestModel *)mergeProRequestModel {
    
    if (self = [super initWithFrame:frame]) {
        self.mergeProRequestModel = mergeProRequestModel;
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    _mergeProPopView = [[[NSBundle mainBundle] loadNibNamed:@"JGJMergeProPopView" owner:self options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _mergeProPopView.frame = window.bounds;
    [self.containDetailView.layer setLayerCornerRadius:5.0];
    [self addSubview:self.containView];
    [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[self class]]) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    [window addSubview:self];
    [TYNotificationCenter addObserver:self selector:@selector(ReportKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.mergeBeforeName.text = self.mergeProRequestModel.merge_before_name;
    CGFloat mergeBeforeNameHeight = [self.mergeBeforeName contentSizeFixWithWidth:TYGetViewW(self.containDetailView) - 24.0].height;
    self.containdetailViewH.constant = mergeBeforeNameHeight < MergeBeforeNameDefaultHeight ? TYGetViewH(self.containDetailView) + mergeBeforeNameHeight - 14 : TYGetViewH(self.containDetailView) + MergeBeforeNameDefaultHeight - 14;
}

- (IBAction)didClickedButtonPressed:(UIButton *)sender {
    [self dismiss];
    if ([NSString isEmpty:self.mergeAfterNameTextField.text]) {
        [TYShowMessage showPlaint:@"请输入合并后的名字"];
        return;
    }
    self.mergeProRequestModel.pro_name = self.mergeAfterNameTextField.text;
    if (self.onClickedBlock) {
        self.onClickedBlock(self.mergeProRequestModel);
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismiss];
}

- (void)dismiss{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.containDetailView.transform = CGAffineTransformScale(self.containDetailView.transform,0.9,0.9);
        
    } completion:^(BOOL finished) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[self class]]) {
                [obj removeFromSuperview];
                *stop = YES;
            }
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)ReportKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - CGRectGetMaxY(self.containDetailView.frame);
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        //显示
        if (yOffset < 10) {
             self.containdetailViewCenterY.constant -= 30;
        } 
        [self layoutIfNeeded];
    }];
}

- (void)dealloc {
    [TYNotificationCenter removeObserver:self];
}


@end
