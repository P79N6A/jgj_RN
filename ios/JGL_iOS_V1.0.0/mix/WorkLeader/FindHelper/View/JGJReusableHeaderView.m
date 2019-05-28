//
//  JGJReusableHeaderView.m
//  mix
//
//  Created by yj on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJReusableHeaderView.h"

@interface JGJReusableHeaderView ()

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *okButton;
@end
@implementation JGJReusableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {

    self.backgroundColor = AppFontd7252cColor;
//    UIButton *cancelButton = [[UIButton alloc] init];
//    cancelButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
//    self.cancelButton = cancelButton;
//    cancelButton.tag = 100;
//    [cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cancelButton];
//    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self).offset(0);
//        make.size.mas_equalTo(CGSizeMake(65, 40));
//    }];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.titleLable = titleLable;
    titleLable.text = @"请选择上班时长";
    titleLable.textColor = [UIColor whiteColor];
    [self addSubview:titleLable];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    UIButton *okButton = [[UIButton alloc] init];
    okButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.okButton = okButton;
    okButton.tag = 101;
    [okButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okButton];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitle:@"关闭" forState:UIControlStateNormal];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(65, 40));
    }];
}

- (void)buttonPressed:(UIButton *)sender {

    switch (sender.tag) {
        case 100: {
            TYLog(@"取消按钮按下");
            if (self.cancelBlock) {
                self.cancelBlock();
            }
            
        }
            break;
        case 101: {
            TYLog(@"确认按钮按下");
            if (self.okBlock) {
                self.okBlock();
            }
        }
            break;
        default:
            break;
    }

}

@end
