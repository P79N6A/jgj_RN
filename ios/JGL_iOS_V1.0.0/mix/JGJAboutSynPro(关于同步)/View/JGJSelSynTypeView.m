//
//  JGJSelSynTypeView.m
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSelSynTypeView.h"

#import "UILabel+GNUtil.h"

#import "YYText.h"

@interface JGJSelSynTypeView ()

@property (weak, nonatomic) IBOutlet UILabel *synWorkAccountTitle;

@property (weak, nonatomic) IBOutlet YYLabel *synWorkAccountDes;

@property (weak, nonatomic) IBOutlet UILabel *synWorkTitle;

@property (weak, nonatomic) IBOutlet YYLabel *synWorkDes;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synWorkAccountTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synWorkTop;

@end

@implementation JGJSelSynTypeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
     
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
        
    }
    
    return self;
    
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJSelSynTypeView" owner:self options:nil] lastObject];
        
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.synWorkAccountTitle.font = [UIFont boldSystemFontOfSize:AppFont38Size];
    
    self.synWorkTitle.font = [UIFont boldSystemFontOfSize:AppFont38Size];
    
    self.synWorkTitle.textColor = AppFont333333Color;
    
    self.synWorkDes.textColor = AppFont333333Color;
    
    self.synWorkAccountDes.textColor = AppFont333333Color;
    
    self.synWorkAccountTitle.textColor = AppFont333333Color;
    
    self.synWorkAccountDes.text = @"向你的老板、上级班组长(工头)\n同步记工数据和记账金额，\n方便他查看班组里面的记工及其他数据。\n接收方在吉工家APP [我的记工账本 > 同步给我的记工] \n中查看已同步的数据";
    
    self.synWorkDes.text = @"向施工单位项目管理人员同步记工数据，\n接收方在吉工宝APP [项目>记工报表] \n中查看已同步的数据";
    
    self.backgroundColor = AppFontf1f1f1Color;
    
    self.synWorkAccountTop.constant = TYIS_IPHONE_5_OR_LESS ? 18 : 54;
    
    self.synWorkTop.constant = TYIS_IPHONE_5_OR_LESS ? 18 : 54;
    
    CGFloat lineSpace = TYIS_IPHONE_5 ? 2 : 5;
    
    NSMutableAttributedString *synWorkAccountDes = [[NSMutableAttributedString alloc] initWithString:self.synWorkAccountDes.text];
    
    synWorkAccountDes.yy_lineSpacing = lineSpace;
    
    synWorkAccountDes.yy_alignment = NSTextAlignmentCenter;
    
    self.synWorkAccountDes.attributedText = synWorkAccountDes;
    
    NSMutableAttributedString *synWorkDes = [[NSMutableAttributedString alloc] initWithString:self.synWorkDes.text];
    
    synWorkDes.yy_lineSpacing = lineSpace;
    
    synWorkDes.yy_alignment = NSTextAlignmentCenter;
    
    self.synWorkDes.attributedText = synWorkDes;
    
}

- (IBAction)selSynButtonPressed:(UIButton *)sender {
    
    JGJSyncType type = sender.tag - 100;
    
    if ([self.delegate respondsToSelector:@selector(selSynTypeView:syncType:)]) {
        
        [self.delegate selSynTypeView:self syncType:type];
    }
    
}



@end
