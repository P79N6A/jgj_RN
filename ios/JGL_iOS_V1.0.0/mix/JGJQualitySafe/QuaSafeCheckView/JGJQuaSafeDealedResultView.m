//
//  JGJQuaSafeDealedResultView.m
//  JGJCompany
//
//  Created by yj on 2017/7/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeDealedResultView.h"

@interface JGJQuaSafeDealedResultView ()
@property (weak, nonatomic) IBOutlet UIButton *checkDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyResultButton;
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *checkRecordButton;

@end

@implementation JGJQuaSafeDealedResultView


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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJQuaSafeDealedResultView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];

    [self.checkDetailButton setTitleColor:AppFont4990e2Color forState:UIControlStateNormal];

    [self.checkRecordButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.modifyResultButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.modifyResultButton.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:JGJCornerRadius / 2.0];
    
    [self.checkRecordButton.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:JGJCornerRadius / 2.0];
}

- (void)setListModel:(JGJInspectPlanProInfoDotListModel *)listModel {

    _listModel = listModel;
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
    
    if (listModel.dot_status_list.count > 0) {
        
        replyModel = [listModel.dot_status_list firstObject];
    }
    
    //待整改才能看见查看按钮

    self.modifyResultButton.hidden = [replyModel.is_operate isEqualToString:@"0"];
    
    self.checkDetailButton.hidden = ![replyModel.status isEqualToString:@"1"];
    
}

- (IBAction)handleButtonPressed:(UIButton *)sender {
    
    QuaSafeDealResultViewButtonType buttonType = sender.tag - 100;
    
    if ([self.delegate respondsToSelector:@selector(quaSafeDealResultView:selectedButtonType:)]) {
        
        [self.delegate quaSafeDealResultView:self selectedButtonType:buttonType];
    }
    
}


@end
