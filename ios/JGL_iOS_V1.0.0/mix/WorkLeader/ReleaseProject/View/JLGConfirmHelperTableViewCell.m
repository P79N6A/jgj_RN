//
//  JLGConfirmHelperTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGConfirmHelperTableViewCell.h"

@interface JLGConfirmHelperTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *findWorkMate;
@property (weak, nonatomic) IBOutlet UIButton *findWorkLeader;

@end

@implementation JLGConfirmHelperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initButtonLayer:self.findWorkMate];
    [self initButtonLayer:self.findWorkLeader];
    [self.findWorkMate addTarget:self action:@selector(selectProjectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.findWorkLeader addTarget:self action:@selector(selectProjectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self selectProjectBtnClick:self.findWorkLeader];
}

- (void )selectProjectBtnClick:(UIButton *)sender {
    for (NSInteger idx = 1; idx <= 2; idx++) {
        if (sender.tag == idx) {
            sender.selected = YES;
            [sender.layer setLayerBorderWithColor:JGJMainColor width:1.0 radius:12.0];
            self.selectButton = idx;
        }else{
            UIButton *button = [self viewWithTag:idx];
            button.selected = NO;
            [button.layer setLayerBorderWithColor:TYColorHex(0x8b8b8b) width:1.0 radius:12.0];
        }
    }
}
@end
