//
//  JGJQuaSafeUnDealedResultView.m
//  JGJCompany
//
//  Created by yj on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeUnDealedResultView.h"

@interface JGJQuaSafeUnDealedResultView ()

@property (weak, nonatomic) IBOutlet UIButton *unRelationButton;

@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

@property (weak, nonatomic) IBOutlet UIButton *passButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation JGJQuaSafeUnDealedResultView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJQuaSafeUnDealedResultView" owner:self options:nil] lastObject];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    [self.unRelationButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    [self.unRelationButton.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:JGJCornerRadius / 2.0];
    
    [self.modifyButton setTitleColor:AppFontFF0000Color forState:UIControlStateNormal];
    
    [self.modifyButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius / 2.0];
    
    [self.passButton setTitleColor:AppFont83C76EColor forState:UIControlStateNormal];
    
    [self.passButton.layer setLayerBorderWithColor:AppFont83C76EColor width:0.5 radius:JGJCornerRadius / 2.0];
}

- (void)setListModel:(JGJInspectPlanProInfoDotListModel *)listModel {

    _listModel = listModel;
    
    self.unRelationButton.hidden = !_listModel.isExPand;
    
    self.modifyButton.hidden = !_listModel.isExPand;
    
    self.passButton.hidden = !_listModel.isExPand;
        
}

- (IBAction)handleButtonPressed:(UIButton *)sender {
    
    QuaSafeUnDealedResultViewButtonType buttonType = sender.tag - 100;
    
    if ([self.delegate respondsToSelector:@selector(quaSafeUnDealedResultView:selectedButtonType:)]) {
        
        [self.delegate quaSafeUnDealedResultView:self selectedButtonType:buttonType];
    }
    
}


@end
