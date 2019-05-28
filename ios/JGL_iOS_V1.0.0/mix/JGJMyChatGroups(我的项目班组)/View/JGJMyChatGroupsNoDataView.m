//
//  JGJMyChatGroupsNoDataView.m
//  mix
//
//  Created by yj on 2019/3/7.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMyChatGroupsNoDataView.h"

@interface JGJMyChatGroupsNoDataView ()

@property (weak, nonatomic) IBOutlet UIButton *creatGroupBtn;

@property (weak, nonatomic) IBOutlet UIButton *sweepBtn;

@end

@implementation JGJMyChatGroupsNoDataView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSString *creatDes = @"”按钮即可 新建班组";
    
    NSString *changeColorDes = @"新建班组";
    
    [self.creatGroupBtn setTitle:creatDes forState:UIControlStateNormal];
    
    NSMutableAttributedString *creatstr = [[NSMutableAttributedString alloc] initWithString:creatDes];
    
    NSRange creatRange = [creatDes rangeOfString:changeColorDes];
    
    [creatstr addAttribute:NSForegroundColorAttributeName value:AppFontEB4E4EColor range:creatRange];
    
    [self.creatGroupBtn setAttributedTitle:creatstr forState:UIControlStateNormal];
    
    NSString *sweepDes = @"或者 扫描二维码 加入已有班组";
    
    NSString *sweepColorDes = @"扫描二维码";
    
    [self.sweepBtn setTitle:sweepDes forState:UIControlStateNormal];
    
    NSMutableAttributedString *sweepstr = [[NSMutableAttributedString alloc] initWithString:sweepDes];
    
    NSRange sweepRange = [sweepDes rangeOfString:sweepColorDes];
    
    [sweepstr addAttribute:NSForegroundColorAttributeName value:AppFontEB4E4EColor range:sweepRange];
    
    [self.sweepBtn setAttributedTitle:sweepstr forState:UIControlStateNormal];
    
}

- (IBAction)creatGroupBtnPressed:(UIButton *)sender {
    
    if (self.creatGroupActionBlock) {
        
        self.creatGroupActionBlock();
        
    }
    
}

- (IBAction)sweepBtnPressed:(UIButton *)sender {
    
    if (self.sweepActionBlock) {
        
        self.sweepActionBlock();
        
    }
    
}

@end
