//
//  JGJAdvertisementShowView.m
//  JGJCompany
//
//  Created by Tony on 2017/6/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAdvertisementShowView.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extend.h"
#import "JGJTime.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
@interface JGJAdvertisementShowView ()
@property (nonatomic ,strong)MPMoviePlayerController *playerController;
@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic,strong) FLAnimatedImageView *gifImageView;//gif图
@property (nonatomic,strong) UILabel *lable;//gif图





@end
@implementation JGJAdvertisementShowView

+(void)showadverTiseMentWithImageUrl:(NSString *)url withImage:(UIImage *)image forType:(JGJadverTisenmentType)type andtapImageBlock:(didslectActionBlock)tapYes
{
    
        NSString * OldtimeStr = [TYUserDefaults objectForKey:JLGAdverTisement];
        NSString *todayTimeStr = [JGJTime yearAppendMonthanddayfromstamp:[NSDate date]];
        if (![NSString isEmpty:OldtimeStr] || ![TYUserDefaults objectForKey:JLGLogin]) {
            if ([OldtimeStr isEqualToString:todayTimeStr] || type == JGJadverTisenmentType_NONE) {
                return;
            }
        }
        [TYUserDefaults setObject:todayTimeStr forKey:JLGAdverTisement];
    JGJAdvertisementShowView *advretisement = [[[NSBundle mainBundle]loadNibNamed:@"JGJpublicitybanner" owner:nil options:nil]firstObject];
    advretisement.imageview.layer.masksToBounds = YES;
    advretisement.imageview.layer.cornerRadius = 5;
    advretisement.imagewidth.constant = 268*TYGetUIScreenWidth/375;
    advretisement.imageheight.constant = 357*TYGetUIScreenWidth/375;
    advretisement.buttonwidth.constant = 268*TYGetUIScreenWidth/375;
    advretisement.buttonheight.constant = 357*TYGetUIScreenWidth/375;
    [advretisement setFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication]keyWindow] addSubview:advretisement];
    [advretisement animationgifWithGifwithView:advretisement.imageview];
    
    if (type == JGJadverTisenmentType_URL) {
//                [advretisement.imageview
//                 sd_setImageWithURL:
//                 [NSURL URLWithString:
//                  url]
//                 placeholderImage:nil];
        [advretisement.imageview sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [advretisement.lable removeFromSuperview];
            [advretisement.gifImageView removeFromSuperview];
            advretisement.imageview.image = image;
            
        }];
    }else if (type == JGJadverTisenmentType_IMAGE){
        advretisement.imageview.image = image;
    }else if (type == JGJadverTisenmentType_video){
        [advretisement playVedio];
        
    }
    
    //    [advretisement gifanimationWithGIFViewWithWebview:advretisement.imageview];
    advretisement.selectActionBlock = tapYes;
}
- (IBAction)closeThisView:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)tapButtonClick:(id)sender {
    self.selectActionBlock(@"tapAdvertisement");
    [self removeFromSuperview];
}

-(void)playVedio
{
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    //    playerLayer.frame=self.imageview.frame;
    playerLayer.frame=CGRectMake(CGRectGetMidX(self.frame) -228*TYGetUIScreenWidth/375/2 ,CGRectGetMidY(self.frame) - 303*TYGetUIScreenWidth/375 / 2, 228*TYGetUIScreenWidth/375, 303*TYGetUIScreenWidth/375);
    //playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.layer addSublayer:playerLayer];
    
    [self.player play];
}
#pragma mark - 加载gif动画
-(void)gifanimationWithGIFViewWithWebview:(UIView *)imageview
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homeAdvertisement" ofType:@"gif"]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 150, 300, 26)];
    webView.scalesPageToFit = YES;
    //    webView.center = self.center;
    
    webView.backgroundColor = [UIColor blackColor];
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [imageview addSubview:webView];
}
-(void)animationgifWithGifwithView:(UIView *)view
{
    _gifImageView = [[FLAnimatedImageView alloc] init];
    //    gifImageView.frame                = CGRectMake(CGRectGetWidth(self.frame)/2 - 55, CGRectGetHeight(self.frame)/2 + 60, 110, 36);;
    _gifImageView.frame                = view.frame;
    
    [self addSubview:_gifImageView];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homeAdvertisement" ofType:@"gif"]];
    [self animatedImageView:_gifImageView data:data];
    
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)/2 - 20, view.frame.size.width, 20)];
    _lable.text = @"正在加载中";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = AppFontccccccColor;
    _lable.font = [UIFont systemFontOfSize:13];
    [view addSubview:_lable];
    view.backgroundColor = [UIColor whiteColor];
}
- (void)animatedImageView:(FLAnimatedImageView *)imageView data:(NSData *)data
{
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    imageView.frame           = CGRectMake(CGRectGetWidth(self.frame)/2 - 40, CGRectGetHeight(self.frame)/2 +5, 80, 25);
    imageView.animatedImage   = gifImage;
    imageView.alpha           = 0.f;
    
    [UIView animateWithDuration:0.5f animations:^{
        imageView.alpha = 1.f;
    }];
}
-(AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem:0];
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        //        [self addProgressObserver];
        //        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}
-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    NSString *urlStr=[NSString stringWithFormat:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}
- (MPMoviePlayerController *)playerController
{
    if (_playerController == nil) {
        // 1.获取视频的URL
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        
        // 2.创建控制器
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        // 3.设置控制器的View的位置
        _playerController.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width * 9 / 16);
        
        // 4.将View添加到控制器上
        [self addSubview:_playerController.view];
        
        // 5.设置属性
        _playerController.controlStyle = MPMovieControlStyleNone;
    }
    return _playerController;
}


- (NSArray *)animationImages
{
    NSFileManager *fielM = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Loading" ofType:@"bundle"];
    NSArray *arrays = [fielM contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *name in arrays) {
        UIImage *image = [UIImage imageNamed:[(@"Loading.bundle") stringByAppendingPathComponent:name]];
        if (image) {
            [imagesArr addObject:image];
        }
    }
    return imagesArr;
}


@end
