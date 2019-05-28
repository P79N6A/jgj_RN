//
//  JGJModifyUserTelVc.m
//  mix
//
//  Created by yj on 2019/2/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJModifyUserTelVc.h"

#import "JGJModifyUserTelSecVc.h"

@interface JGJModifyUserTelVc ()

@property (weak, nonatomic) IBOutlet UIButton *modifyTelBtn;

@property (weak, nonatomic) IBOutlet UILabel *telDes;

@end

@implementation JGJModifyUserTelVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"更换手机号";
    
    [self.modifyTelBtn.layer setLayerCornerRadius:5];
    
    _modifyTelBtn.layer.shadowColor = AppFontEFB8B8Color.CGColor;
    
    _modifyTelBtn.layer.cornerRadius = 4;
    
    _modifyTelBtn.layer.shadowOffset = CGSizeMake(0, 4);
    
    _modifyTelBtn.layer.shadowOpacity = 0.8;
    
    NSString *tel = [TYUserDefaults objectForKey:JLGPhone];
    
    self.telDes.text = [NSString stringWithFormat:@"你的手机号：%@", tel];
    
    self.telDes.font = [UIFont boldSystemFontOfSize:AppFont34Size];
    
}

- (IBAction)modifyTelBtnPressed:(UIButton *)sender {
    
    JGJModifyUserTelSecVc *modifyUserTelSecVc = [[JGJModifyUserTelSecVc alloc] init];
    
    [self.navigationController pushViewController:modifyUserTelSecVc animated:YES];
    
}

@end
