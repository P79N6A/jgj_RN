//
//  JGJLoadStatusViewCell.m
//  mix
//
//  Created by yj on 2018/11/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLoadStatusViewCell.h"

@interface JGJLoadStatusViewCell ()

@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic) IBOutlet UIView *contentFailureView;

@end

@implementation JGJLoadStatusViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.loadingView.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againLoad)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.contentFailureView addGestureRecognizer:tap];
}

- (void)setStatus:(NSInteger)status {
    
    _status = status;
    
    switch (status) {

        case 1:{
            
            [self startLoading]; //加载中
        }
            
            break;
            
        case 2:{
            
            [self loadingFailure];//记载失败
        }
            
            break;
            
        default:{
            
            [self loadingSuccess];//加载成功
            
        }
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 开始加载

- (void)startLoading {
    
    self.loadingView.hidden = NO;
    
    [self.loadingIndicator startAnimating];
    
    self.contentFailureView.hidden = YES;
    
}

#pragma mark - 加载失败

- (void)loadingFailure {
    
    self.contentFailureView.hidden = NO;
    
    self.loadingIndicator.hidden = YES;
    
    self.loadingView.hidden = NO;
    
}

#pragma mark - 加载成功

- (void)loadingSuccess {
    
    [self.loadingIndicator stopAnimating];
    
    self.loadingView.hidden = YES;
    
    self.contentFailureView.hidden = YES;
}

#pragma makr - 点击再次加载

- (void)againLoad {
    
    //加载失败点击重新加载首页数据
    
    if (_status == 2) {
        
        if ([self.delegate respondsToSelector:@selector(loadStatusViewCell:)]) {
            
            [self.delegate loadStatusViewCell:self];
            
        }
    }
    
}

@end
