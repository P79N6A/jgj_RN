//
//  JGJYunFileApplicationSuccessViewController.m
//  mix
//
//  Created by Tony on 2018/10/26.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJYunFileApplicationSuccessViewController.h"
#import "JGJCusYyLable.h"
#import "NSString+Extend.h"
@interface JGJYunFileApplicationSuccessViewController ()

@property (nonatomic, strong) UIImageView *yunFileImageView;
@property (nonatomic, strong) UILabel *successLabel;

@property (nonatomic, strong) JGJCusYyLable *contentLabel;
@property (nonatomic, strong) UILabel *workTimeLabel;
@property (nonatomic, strong) JGJCusYyLable *phoneLabel;

@end

@implementation JGJYunFileApplicationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"工作消息";
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.yunFileImageView];
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.workTimeLabel];
    [self.view addSubview:self.phoneLabel];
    [self setUpLayout];
}

- (void)setProjectName:(NSString *)projectName {
    
    _projectName = projectName;
    
    if ([self.status isEqualToString:@"3"]) {
        
        self.contentLabel.text = [NSString stringWithFormat:@"%@ 的项目云盘扩容申请已经提交成功，客服将尽快与你联系",_projectName];
        
    }else {
    
        self.contentLabel.text = [NSString stringWithFormat:@"%@ 的项目云盘续期申请已经提交成功，客服将尽快与你联系",_projectName];
    }
    
    [_contentLabel changeTextColorInTextContentWithTextArray:@[projectName] textColor:AppFont2BC99EColor];
    
    [_contentLabel setContent:_contentLabel.text lineSpace:8];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setUpLayout {
    
    [self.yunFileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(98);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_yunFileImageView.mas_bottom).offset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_successLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(100);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_phoneLabel.mas_top).offset(-6);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
    }];
}

- (UIImageView *)yunFileImageView {
    
    if (!_yunFileImageView) {
        
        _yunFileImageView = [[UIImageView alloc] init];
        _yunFileImageView.image = IMAGE(@"yunFileApplicationSuccess");
    }
    return _yunFileImageView;
}

- (UILabel *)successLabel {
    
    if (!_successLabel) {
        
        _successLabel = [[UILabel alloc] init];
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.font = FONT(AppFont36Size);
        _successLabel.textColor = AppFont2BC99EColor;
        _successLabel.text = @"申请成功";
    }
    return _successLabel;
}

- (JGJCusYyLable *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[JGJCusYyLable alloc] init];
        _contentLabel.textColor = AppFont333333Color;
        _contentLabel.font = FONT(AppFont30Size);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)workTimeLabel {
    
    if (!_workTimeLabel) {
        
        _workTimeLabel = [[UILabel alloc] init];
        _workTimeLabel.text = @"咨询在线客服：(工作日09：00~18：00)";
        _workTimeLabel.textAlignment = NSTextAlignmentCenter;
        _workTimeLabel.textColor = AppFont666666Color;
        _workTimeLabel.font = FONT(AppFont26Size);
    }
    return _workTimeLabel;
}

- (JGJCusYyLable *)phoneLabel {
    
    if (!_phoneLabel) {
        
        _phoneLabel = [[JGJCusYyLable alloc] init];
        _phoneLabel.text = @"电话咨询：400-862-3818";
        _phoneLabel.textColor = AppFont666666Color;
        [_phoneLabel changeTextColorInTextContentWithTextArray:@[@"400-862-3818"] textColor:AppFont2BC99EColor];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = FONT(AppFont26Size);
        
    }
    return _phoneLabel;
}
@end
