//
//  YZGSelectedRoleViewController.m
//  mix
//
//  Created by Tony on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGSelectedRoleViewController.h"
#import "JLGAppDelegate.h"
#import "CAShapeLayer+Cycle.h"
#import "UINavigationBar+Awesome.h"

#import "UILabel+GNUtil.h"

@interface YZGSelectedRoleViewController ()

@property (nonatomic, strong) YZGPieLoopProgressView *yzgPieLoopProgressView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *mateButton;

@property (weak, nonatomic) IBOutlet UIButton *leaderButton;

@property (weak, nonatomic) IBOutlet UILabel *selRoleDes;

@property (weak, nonatomic) IBOutlet UILabel *workDesLable;

@property (weak, nonatomic) IBOutlet UILabel *workLeaderDes;

@property (weak, nonatomic) IBOutlet UIButton *workerFlagBtn;

@property (weak, nonatomic) IBOutlet UIButton *leaderFlagBtn;

@end

@implementation YZGSelectedRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *mateFirstView = [self.view viewWithTag:10];
    [mateFirstView.layer setLayerCornerRadius:TYGetViewW(mateFirstView)/2];
    UIView *mateSecondView = [self.view viewWithTag:11];
    [mateSecondView.layer setLayerCornerRadius:TYGetViewW(mateSecondView)/2];
    
    UIView *leaderFirstView = [self.view viewWithTag:20];
    [leaderFirstView.layer setLayerCornerRadius:TYGetViewW(leaderFirstView)/2];
    UIView *leaderSecondView = [self.view viewWithTag:21];
    [leaderSecondView.layer setLayerCornerRadius:TYGetViewW(leaderSecondView)/2];
    
    self.yzgPieLoopProgressView = [[YZGPieLoopProgressView alloc] initWithFrame:mateFirstView.bounds runRollSpeed:0.03 progressColor:JLGBlueColor];
    
    if (![NSString isEmpty:self.selRoleDes.text]) {
        
        [self.selRoleDes setAttributedStringText:self.selRoleDes.text lineSapcing:7.0];
    }

    self.workDesLable.text = @"记工\n查看自己账单\n找工作";

    self.workLeaderDes.text = @"对工人记工\n查看工人账单\n招工人\n找项目";
    
    if (![NSString isEmpty:self.workDesLable.text]) {
        
        [self.workDesLable setAttributedStringText:self.workDesLable.text lineSapcing:10.0];
    }
    
    if (![NSString isEmpty:self.workLeaderDes.text]) {
        
        [self.workLeaderDes setAttributedStringText:self.workLeaderDes.text lineSapcing:10.0];
    }
    
    self.workDesLable.textColor = AppFont333333Color;
    
    self.workLeaderDes.textColor = AppFont333333Color;
    
    self.workerFlagBtn.hidden = YES;
    
    self.leaderFlagBtn.hidden = YES;
}

- (IBAction)cancelBtnClick:(id)sender {
//    [self goBackVc:NO];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.navigationBarHidden == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.view.tag == 1) {
        self.navigationController.navigationBarHidden = YES;
    }
    
//    self.cancelButton.hidden = self.view.tag != 1;
    
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
    keyAnim.duration = 3.0;
    keyAnim.repeatCount = MAXFLOAT;
    keyAnim.keyPath = @"transform.scale";
    keyAnim.values = @[@(0.9),@(1.1),@(0.9)];
    
    UIView *mateFirstView = [self.view viewWithTag:10];
    UIView *mateSecondView = [self.view viewWithTag:11];
    [mateFirstView.layer addAnimation:keyAnim forKey:@"mateFirstView"];
    [mateSecondView.layer addAnimation:keyAnim forKey:@"mateSecondView"];
    
    UIView *leaderFirstView = [self.view viewWithTag:20];
    UIView *leaderSecondView = [self.view viewWithTag:21];
    [leaderFirstView.layer addAnimation:keyAnim forKey:@"leaderFirstView"];
    [leaderSecondView.layer addAnimation:keyAnim forKey:@"leaderSecondView"];
    
    //没选角色的时候不显示
    
    self.workerFlagBtn.hidden = !JLGisMateBool || !JGJIsSelRoleBool;
    
    self.leaderFlagBtn.hidden = !self.workerFlagBtn.hidden || !JGJIsSelRoleBool;
}

- (IBAction)mateRoleBtnClick:(UIButton *)sender {
    if (JLGisLeaderBool) {
        
        [TYUserDefaults setBool:NO forKey:JGJHomeVCIsNotChangeRoleId];
        
    }
    [self changadRole:sender];
}

- (IBAction)leaderRoleBtnClick:(UIButton *)sender {
    
    if (JLGisMateBool) {
        
        [TYUserDefaults setBool:NO forKey:JGJHomeVCIsNotChangeRoleId];
        
    }
    [self changadRole:sender];
}

- (void)changadRole:(UIButton *)sender{
    
    NSInteger indexTag = sender.tag;
    
    //tag为1的时候，就是从主界面present上来的，不需要重新设置root
    if (self.view.tag != 1) {//引导页进入的情况
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //保存选择的情况
        indexTag != 1?[TYUserDefaults setBool:YES forKey:JLGisLeader]:[TYUserDefaults setBool:NO forKey:JLGisLeader];
        [TYUserDefaults synchronize];
        
        JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
        [jlgAppDelegate setRootViewController];
    }else if(JLGisLoginBool){//从主界面进来并且已经登录
        //添加进度条
        [self loopProgressViewLoad:sender];
        [self JLGHttpRequest:indexTag];
        
    }else{//从主界面进来并且没有登录的情况
        [self loopProgressViewLoad:sender];
        indexTag != 1?[TYUserDefaults setBool:YES forKey:JLGisLeader]:[TYUserDefaults setBool:NO forKey:JLGisLeader];
        [TYUserDefaults synchronize];

    }
    
}

- (void)JLGHttpRequest:(NSInteger )role{
    
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/changerole" parameters:@{@"role":@(role),@"os":@"I"} success:^(NSDictionary *responseObject) {
        
        NSInteger roleNum = [responseObject[@"role"] integerValue];
        if ([responseObject[@"is_info"] integerValue] == 0) {//需要填补充资料
            
            roleNum == 1?[TYUserDefaults setBool:NO forKey:JLGMateIsInfo]:[TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
            [TYUserDefaults synchronize];
            
        }else{//有权限，保存权限
            roleNum == 1?[TYUserDefaults setBool:YES forKey:JLGMateIsInfo]:[TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
            [TYUserDefaults synchronize];
        }
        
        //保存状态,1为工人，2为班组长/工头
        roleNum != 1?[TYUserDefaults setBool:YES forKey:JLGisLeader]:[TYUserDefaults setBool:NO forKey:JLGisLeader];
        [TYUserDefaults synchronize];
        
        [TYUserDefaults setBool:YES forKey:JGJSelRole];
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        
        infoVer += 1;
        
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        
        [self.yzgPieLoopProgressView endTimer];
        
        [self goBackVc:NO];
        
    } failure:^(NSError *error) {
    
        [self.yzgPieLoopProgressView endTimer];

        [TYShowMessage showPlaint:@"请检查网络"];
        
//        [self goBackVc:YES];
    }];
}

- (void)loopProgressViewLoad:(UIButton *)sender{
    [self.yzgPieLoopProgressView endTimer];
    if (![self.view.subviews containsObject:self.yzgPieLoopProgressView]) {
        [self.view insertSubview:self.yzgPieLoopProgressView belowSubview:sender];
    }
    self.yzgPieLoopProgressView.shadeColor = sender.tag == 1?TYColorHex(0xD5E5FD):TYColorHex(0xE7E1FF);
    self.yzgPieLoopProgressView.center = sender.center;
    [self.yzgPieLoopProgressView startTimer];
}

//needpop 是否使用Pop
- (void)goBackVc:(BOOL )needPop{
    
    if (self.view.tag == 1) {
        
        if (needPop) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            //因为项目结构，需要登陆切换控制器
            if (JGJLoginFirstChangeRoleBool) {
                
                JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
                
                [jlgAppDelegate setRootViewController];
                
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    //选择成功回调dismiss登录页面
    
    if (self.selRoleSuccessBlock) {
        
        self.selRoleSuccessBlock();
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSString *changeDes = @"切换身份成功！";
        
        if (JLGisLeaderBool) {
            
            changeDes = @"切换身份成功！";
        }
        
        [TYShowMessage showSuccess:changeDes];

    });
    
}

- (void)setIsHiddenCancelButton:(BOOL)isHiddenCancelButton {
    
    _isHiddenCancelButton = isHiddenCancelButton;
    
    self.cancelButton.hidden = _isHiddenCancelButton;
    
}

@end


@implementation YZGPieLoopProgressView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id )initWithFrame:(CGRect)frame runRollSpeed:(CGFloat )runRollSpeed progressColor:(UIColor *)progressColor{
    self = [self initWithFrame:frame];
    if (self) {
        self.runRollSpeed = runRollSpeed;
        self.progressColor = progressColor;
    }
    return self;
}

- (void)startTimer{
    // 模拟下载进度
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:self.runRollSpeed target:self selector:@selector(progressSimulation) userInfo:self repeats:YES];
}

- (void)endTimer{
    //取消定时器
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    self.progress = 0;

    [self removeFromSuperview];
}

- (void)progressSimulation
{
    if (self.progress < 1.0) {
        self.progress += 0.01;
    
        if (self.progress >= 1.0) self.progress = 0;
    }
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    if (progress >= 1.0) {
        progress = 0.0;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5);

    // 进度环
    [self.progressColor?:JLGBlueColor set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 弧度值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    // 遮罩
    [self.shadeColor set];
    CGFloat maskW = (radius - 7) * 2;
    CGFloat maskH = maskW;
    CGFloat maskX = (rect.size.width - maskW) * 0.5;
    CGFloat maskY = (rect.size.height - maskH) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(maskX, maskY, maskW, maskH));
    CGContextFillPath(ctx);
}
@end
