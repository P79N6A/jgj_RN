//
//  JGJFilterAccountMemberHeaderView.m
//  mix
//
//  Created by yj on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJFilterAccountMemberHeaderView.h"

@interface JGJFilterAccountMemberHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *selImageView;

@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJFilterAccountMemberHeaderView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJFilterAccountMemberHeaderView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.name.textColor = AppFont333333Color;
    
    self.selImageView.hidden = YES;
    
    self.name.text = RecordMemberDes;
    
}

#pragma mark - 代理班组长
- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    if (![NSString isEmpty:proListModel.group_id]) {
        
        self.name.text = AgencyDes;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.filterAccountMemberHeaderViewBlock) {
        
        self.filterAccountMemberHeaderViewBlock(self);
    }
    
    self.isSelHeaderView = !self.isSelHeaderView;
}

- (void)setIsSelHeaderView:(BOOL)isSelHeaderView {
    
    _isSelHeaderView = isSelHeaderView;
    
    self.selImageView.hidden = !isSelHeaderView;
}

@end
