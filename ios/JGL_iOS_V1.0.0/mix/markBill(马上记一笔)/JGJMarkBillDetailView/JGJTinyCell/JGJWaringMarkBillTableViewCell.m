//
//  JGJWaringMarkBillTableViewCell.m
//  mix
//
//  Created by Tony on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWaringMarkBillTableViewCell.h"

@implementation JGJWaringMarkBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseView.layer.masksToBounds = YES;
    self.baseView.layer.cornerRadius = 15;
    [self loadView];
}
-(void)loadView{
    
    self.imageViews = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 53, 8.5, 8, 13)];
    self.imageViews.image = [UIImage imageNamed:@"mainRecodrrow"];
    [self.baseView addSubview:self.imageViews];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(aniaml) userInfo:nil repeats:YES];

}
- (void)aniaml{
    [UIView animateWithDuration:0.8 animations:^{
        self.imageViews.transform = CGAffineTransformMakeTranslation(-15, 0);
        self.imageViews.alpha = .3;
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.8 animations:^{
            self.imageViews.transform = CGAffineTransformMakeTranslation(0, 0);
            self.imageViews.alpha = 1;
        }];
        
    }];
    
}
@end
