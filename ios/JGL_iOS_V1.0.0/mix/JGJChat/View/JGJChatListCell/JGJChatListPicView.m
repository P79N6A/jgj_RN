//
//  JGJChatListPicView.m
//  JGJCompany
//
//  Created by Tony on 2016/12/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListPicView.h"
#import "UIImage+Color.h"
#import "UIImageView+WebCache.h"
#import "JGJImage.h"
#define kChatListPicViewMaxW (TYGetUIScreenWidth*0.6)
#define kChatListPicViewMaxH (kChatListPicViewMaxW*0.6)

@interface JGJChatListPicView ()

@property (strong, nonatomic)  UIView *containerView;

@property (strong, nonatomic)  UIImageView *picImageView;

@property (strong, nonatomic)  UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic)  UILabel *progressLabel;

@property (strong, nonatomic)  UIView *maskBackView;
@property (strong, nonatomic)  UIImageView *SendTypeView;


@end


@implementation JGJChatListPicView


- (instancetype )initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    if (!self.containerView) {
        self.containerView = [UIView new];
        [self addSubview:self.containerView];
    }
//        if (!self.SendTypeView) {
//            
//            self.SendTypeView = [UIImageView new];
//            
//            self.SendTypeView.contentMode = UIViewContentModeRight;
//            
//            [self addSubview:self.SendTypeView];
//            
//            self.SendTypeView.image = [UIImage imageNamed:@"Chat_sendFail"];
//            
//            self.SendTypeView.hidden = YES;
//            
//        }
    
    if (!self.picImageView) {
        self.picImageView = [UIImageView new];
        self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.containerView addSubview:self.picImageView];
        
        [self.picImageView.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:3];
        
        self.picImageView.layer.masksToBounds = YES;
    }
    
    if (!self.maskBackView) {
        self.maskBackView = [UIView new];
        [self.containerView addSubview:self.maskBackView];
        
        self.maskBackView.hidden = YES;
    }
    
    if (!self.progressLabel) {
        self.progressLabel = [UILabel new];
        self.progressLabel.hidden = YES;
        [self.containerView addSubview:self.progressLabel];
        
        self.progressLabel.hidden = YES;
        self.progressLabel.font = [UIFont systemFontOfSize:12.0];
        self.progressLabel.textColor = [UIColor whiteColor];
    }
    
    if (!self.indicatorView) {
        self.indicatorView = [UIActivityIndicatorView new];
        [self.containerView addSubview:self.indicatorView];
        self.indicatorView.hidden = YES;
        [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        
        self.indicatorView.hidesWhenStopped = YES;
        
        self.indicatorView.backgroundColor = TYColorHexAlpha(0x999999, 0.5);
    }
    
    self.maskBackView.backgroundColor = TYColorHexAlpha(0x999999, 0.5);
    
    //设置其他控件
    [self setLayoutWidget:CGSizeZero];
    
}

//设置picImage的layout
- (void)setLayoutPicImageFailButton:(CGSize )fitSize{
    
    //    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.mas_top).offset(2);
    //        make.bottom.equalTo(self.mas_bottom).offset(-2);
    //
    //        make.width.mas_equalTo(fitSize.width);
    //        make.height.mas_equalTo(fitSize.height);
    //
    //        if (_jgjChatListModel.belongType == JGJChatListBelongMine) {//自己的
    //            make.right.equalTo(self.mas_right);
    //        }else{//别人的
    //            make.left.equalTo(self.mas_left);
    //        }
    //    }];
}

//设置其他控件
- (void)setLayoutWidget:(CGSize )fitSize{
    //    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.bottom.left.right.mas_equalTo(self.containerView);
    //    }];
    
    [self.maskBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.picImageView);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picImageView);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.picImageView);
        make.top.equalTo(self.indicatorView.mas_bottom).offset(2);
    }];
}

- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    _jgjChatListModel = jgjChatListModel;
    
    self.sendType = _jgjChatListModel.sendType;
    self.progress = _jgjChatListModel.progress;
    
    
    CGSize fitSize = jgjChatListModel.imageSize;
    
    if (_jgjChatListModel.belongType == JGJChatListBelongMine) {
        
        if (![NSString isEmpty:_jgjChatListModel.assetlocalIdentifier]) {
            
            //没有加载图片，和图片路径是空的情况加载相册图片
            
            if (!_jgjChatListModel.picImage && _jgjChatListModel.msg_src.count == 0) {
                
                UIImage *image = [JGJImage getImageFromPHAssetLocalIdentifier:_jgjChatListModel.assetlocalIdentifier];
                
                if (image) {
                    
                    _jgjChatListModel.picImage = image;
                    
                }
                
            }
            
        }
        
        CGFloat containViewW = TYGetViewW(self);
        
        self.picImageView.frame = CGRectMake(containViewW - _jgjChatListModel.imageSize.width, 0, _jgjChatListModel.imageSize.width, _jgjChatListModel.imageSize.height - 5);
        
    }else {
        
        self.picImageView.frame = CGRectMake(0, 0, _jgjChatListModel.imageSize.width, _jgjChatListModel.imageSize.height - 5);
    }
    
    if (_jgjChatListModel.picImage) {
        
        self.picImageView.image = jgjChatListModel.picImage;
        
        [self makeMaskView:self.picImageView];
        
    }else {
        
        NSURL *picUrl = nil;
        
        if (_jgjChatListModel.msg_src.count > 0) {
            
            picUrl = [NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:[_jgjChatListModel.msg_src firstObject]]];
        }
        
        
//这个大小没有修改到
        UIImage *placeholdImage = [UIImage imageFromContextWithColor:TYColorHex(0xcccccc) size:CGSizeMake(fitSize.width,fitSize.height)];
        
//        UIImage *image = [JGJImage getImageFromPHAssetLocalIdentifier:_jgjChatListModel.assetlocalIdentifier];
//
//        _jgjChatListModel.picImage = image;
//
//        if (image) {
//
//            placeholdImage = image;
//        }
        
        [self startAnimating];
        TYWeakSelf(self);
        [self.picImageView sd_setImageWithURL:picUrl placeholderImage:placeholdImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            TYStrongSelf(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                strongself.progress = (CGFloat )receivedSize/(CGFloat )expectedSize;
                
                strongself.progressLabel.hidden = NO;
                
                strongself.indicatorView.hidden = NO;
                
            });
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            TYStrongSelf(self);
            
            //下载失败
            if (error) {
                [strongself stopAnimating:JGJChatListSendFail];
            }else{
                [strongself stopAnimating:JGJChatListSendSuccess];
            }
            
            _jgjChatListModel.sendType = JGJChatListSendSuccess;
            
            [strongself makeMaskView:self.picImageView];
        }];
    }
//    图片发送失败
    
//     self.SendTypeView.hidden = self.sendType != JGJChatListSendFail;
    
    //设置picImage和failButton的layout
    [self setLayoutPicImageFailButton:fitSize];
    
}

- (void)setSendType:(JGJChatListSendType)sendType{
    _sendType = sendType;
    
    if (sendType == JGJChatListSending || sendType == JGJChatListSendStart) {
        [self startAnimating];
    }else{
        [self stopAnimating:sendType];
    }
}

- (void)startAnimating{
    //去掉进度显示
//    self.progressLabel.hidden = NO;
    self.progressLabel.hidden = YES;
    self.maskBackView.hidden = self.progressLabel.hidden;
    
    [self.indicatorView startAnimating];
}

- (void)stopAnimating:(JGJChatListSendType)sendType{
    self.progressLabel.hidden = YES;
    self.maskBackView.hidden = self.progressLabel.hidden;
    
    if (![NSString isEmpty:_jgjChatListModel.msg_id]) {
        
        [self.indicatorView stopAnimating];
        
    }
}

- (void)setProgress:(CGFloat )progress{
    progress = fabs(progress);
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = [NSString stringWithFormat:@"%.f%%",progress*100];
    });
}

- (CGSize )getFitImageSize:(NSArray *)pic_w_h maxImageSize:(CGSize )maxImageSize{
    
    return [JGJImage getFitImageSize:pic_w_h maxImageSize:maxImageSize];
    
}

- (void)makeMaskView:(UIImageView *)picImageView
{
    
    
}

@end
