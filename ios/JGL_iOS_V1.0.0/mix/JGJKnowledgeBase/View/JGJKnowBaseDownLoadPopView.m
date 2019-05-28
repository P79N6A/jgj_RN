//
//  JGJKnowBaseDownLoadPopView.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowBaseDownLoadPopView.h"

#import "JGJDownLoadProGressView.h"

@interface JGJKnowBaseDownLoadPopView ()


@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLable;

@property (weak, nonatomic) IBOutlet UILabel *downDesLable;


@property (weak, nonatomic) IBOutlet JGJDownLoadProGressView *downProgressView;

//@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel;

@end

@implementation JGJKnowBaseDownLoadPopView

static JGJKnowBaseDownLoadPopView *_popView;

- (void)awakeFromNib {

    [super awakeFromNib];
    
     [TYNotificationCenter addObserver:self selector:@selector(handleDownFile:) name:@"downFileNotification" object:nil];
    
    self.fileNameLable.textColor = AppFont666666Color;
    
    self.downDesLable.textColor = AppFontd7252cColor;
    
    [self.contentDetailView.layer setLayerCornerRadius:5.0];

}

+ (JGJKnowBaseDownLoadPopView *)knowBaseDownLoadPopViewWithModel:(JGJKnowBaseModel *)knowBaseModel {
    
    if(_popView && _popView.superview) [_popView removeFromSuperview];
    
    _popView = [[[NSBundle mainBundle] loadNibNamed:@"JGJKnowBaseDownLoadPopView" owner:self options:nil] lastObject];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    _popView.frame = window.bounds;
    
    _popView.fileNameLable.text = knowBaseModel.file_name;
    
    [window addSubview:_popView];

    return _popView;
}

- (void)handleDownFile:(NSNotification *)notification {
    
    JGJKnowBaseModel *downingknowBaseModel = notification.object;
    
    self.knowBaseModel = downingknowBaseModel;
    
}

- (void)setKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {

    _knowBaseModel = knowBaseModel;
    
    self.downProgressView.progressValue = [NSString stringWithFormat:@"%@", @(_knowBaseModel.progress)];
    
    TYLog(@"progressValue======%@", self.downProgressView.progressValue);
    
}

- (IBAction)handleCancelButtonPressedAction:(UIButton *)sender {
    
    [TYNotificationCenter postNotificationName:@"handleDelDownFileNotification" object:nil];
    
    if (self.handleKnowBaseCancelDownLoadBlock) {
        
        self.handleKnowBaseCancelDownLoadBlock(self.knowBaseModel);
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


- (void)dealloc {

    [TYNotificationCenter removeObserver:self];
}

@end
