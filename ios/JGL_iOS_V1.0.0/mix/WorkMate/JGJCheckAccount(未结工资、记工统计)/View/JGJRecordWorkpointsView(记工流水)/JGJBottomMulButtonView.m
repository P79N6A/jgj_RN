//
//  JGJBottomMulButtonView.m
//  mix
//
//  Created by yj on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJBottomMulButtonView.h"

@interface JGJBottomMulButtonView ()

@property (weak, nonatomic) IBOutlet UIButton *allSelButton;

@property (weak, nonatomic) IBOutlet UIButton *delButton;

@property (strong, nonatomic) IBOutlet UIView *containView;


@end

@implementation JGJBottomMulButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJContainMulButtonView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.delButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    
    [self.allSelButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    [self.delButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:1.0 radius:JGJCornerRadius];
    
//    [self.allSelButton.layer setLayerBorderWithColor:TYColorHex(0x666666) width:0.5 radius:JGJCornerRadius];
    
}

- (IBAction)allSelButtonPressed:(UIButton *)sender {
    
    self.isAllSelStatus = !self.isAllSelStatus;
    
    _allSelButton.selected = !sender.selected;
    if (self.bottomMulButtonViewBlock) {
        
        self.bottomMulButtonViewBlock(JGJBottomAllSelButtonType, self.isAllSelStatus);
        
    }
}

- (IBAction)delButtonPressed:(UIButton *)sender {
    
    if (self.bottomMulButtonViewBlock) {
        
        self.bottomMulButtonViewBlock(JGJBottomDelButtonType, self.isAllSelStatus);
        
    }
}

- (void)setIsAllSelStatus:(BOOL)isAllSelStatus {
    
    _isAllSelStatus = isAllSelStatus;
    
    NSString *btnTitle =  _isAllSelStatus ? @"取消全选" : @"全选本页";
    
    [self.allSelButton setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)setSelRecordCount:(NSInteger)selRecordCount {
    
    _selRecordCount = selRecordCount;
    
    NSString *selCount = @"批量删除";
    
    if (selRecordCount > 0) {
        
        selCount = [NSString stringWithFormat:@"批量删除(%@)", @(selRecordCount)];
        
    }else {
        
        selCount = @"批量删除";
    }
    
    [self.delButton setTitle:selCount forState:UIControlStateNormal];
}

@end
