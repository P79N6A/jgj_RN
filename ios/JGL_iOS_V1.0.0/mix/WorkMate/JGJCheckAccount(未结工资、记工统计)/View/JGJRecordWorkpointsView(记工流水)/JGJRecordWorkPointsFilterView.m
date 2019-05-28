//
//  JGJRecordWorkPointsFilterView.m
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkPointsFilterView.h"

#import "JGJProFilterView.h"

#import "JGJMemberFilterView.h"

#import "UIView+GNUtil.h"

#define AllProName @"全部项目"

@interface JGJRecordWorkPointsFilterView ()

@property (weak, nonatomic) IBOutlet UIButton *proButton;

@property (weak, nonatomic) IBOutlet UIButton *memberButton;

@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

@property (weak, nonatomic) IBOutlet UILabel *memberLable;

@property (weak, nonatomic) IBOutlet UIImageView *proSelImageView;

@property (weak, nonatomic) IBOutlet UIImageView *memberImageView;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (strong, nonatomic) UIViewController *curVc;

@property (strong, nonatomic) JGJProFilterView *proFilterView;

@property (strong, nonatomic) JGJMemberFilterView *memberFilterView;

@property (assign, nonatomic) BOOL isSelPro;

@property (assign, nonatomic) BOOL isSelMember;

@property (strong, nonatomic) JGJRecordWorkPointFilterModel *proModel;

@property (strong, nonatomic) JGJSynBillingModel *memberModel;

@end

@implementation JGJRecordWorkPointsFilterView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJRecordWorkPointsFilterView" owner:self options:nil] lastObject];
    
    self.containView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, self.height);
    
    [self addSubview:self.containView];
    
    self.proNameLable.textColor = AppFont666666Color;
    
    self.memberLable.textColor = AppFont666666Color;
    
    self.memberLable.text = RecordMemberDes;
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        self.memberLable.text = AgencyDes;
    }
}

- (IBAction)filterProButtonPressed:(UIButton *)sender {
    
    _isSelPro = !_isSelPro;
    
    [self setProSelImageViewWithIsSelected:_isSelPro];
    
    if (_isSelPro) {
        
        [self.curVc.view addSubview:self.proFilterView];
        
    }else {
        
        [self removeMemberFilterView];
    }
    
}

- (IBAction)filterMemberButtonPressed:(UIButton *)sender {
    
    _isSelMember = !_isSelMember;
    
    [self setMemberSelImageViewWithIsSelected:_isSelMember];
    
    if (_isSelMember) {
        
        [self.curVc.view addSubview:self.memberFilterView];
        
    }else {
        
        [self removeProFilterView];
    }

}

- (void)setProSelImageViewWithIsSelected:(BOOL)isSelected {
    
    NSString *imageStr = isSelected ? @"up_press" : @"down_press";
    
    self.proSelImageView.image = [UIImage imageNamed:imageStr];
    
    if (!isSelected) {
        
        [self removeProFilterView];
        
    }else {
        
        _isSelMember = NO;
        
        [self setMemberSelImageViewWithIsSelected:_isSelMember];
        
    }
    
}

- (void)setMemberSelImageViewWithIsSelected:(BOOL)isSelected {
    
    NSString *imageStr = isSelected ? @"up_press" : @"down_press";
    
    self.memberImageView.image = [UIImage imageNamed:imageStr];
    
    if (!isSelected) {
        
        [self removeMemberFilterView];
        
    }else {
        
        _isSelPro = NO;
        
        [self setProSelImageViewWithIsSelected:_isSelPro];
    }
    
}

- (UIViewController *)curVc {
    
    if (!_curVc) {
        
        _curVc = [UIView getCurrentViewControllerWithCurView:self];
    }
    
    return _curVc;
}

- (JGJProFilterView *)proFilterView {
    
    if (!_proFilterView) {
        
        _proFilterView = [[JGJProFilterView alloc] initWithFrame:CGRectMake(0, TYGetMaxY(self), TYGetUIScreenWidth, TYGetUIScreenHeight - TYGetMaxY(self) - JGJ_NAV_HEIGHT)];
        
        _proFilterView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
         TYWeakSelf(self);
        _proFilterView.proFilterViewBlock = ^(JGJRecordWorkPointFilterModel *proModel) {
            
            _isSelPro = NO;
            
            weakself.proModel = proModel;
            
            [weakself setProSelImageViewWithIsSelected:NO];
            
            if (weakself.recordWorkPointsFilterViewBlock) {
                
                weakself.recordWorkPointsFilterViewBlock(weakself.memberModel, weakself.proModel);
            }
            
            if ([NSString isEmpty:proModel.class_type_id] ) {
                
                weakself.proNameLable.text = AllProName;
                
            }else {
                
                weakself.proNameLable.text = proModel.name;
   
            }
            
            if ([weakself.proNameLable.text isEqualToString:AllProName]) {
                
                weakself.proNameLable.textColor = AppFont666666Color;
                
            }else {
                
                weakself.proNameLable.textColor = AppFont333333Color;
            }
        };
    }
    
    return _proFilterView;
}

- (JGJMemberFilterView *)memberFilterView {
    
    if (!_memberFilterView) {
                
        _memberFilterView = [[JGJMemberFilterView alloc] initWithFrame:CGRectMake(0, TYGetMaxY(self), TYGetUIScreenWidth, TYGetUIScreenHeight - TYGetMaxY(self) - JGJ_NAV_HEIGHT)];
        
        _memberFilterView.proListModel = self.proListModel;
        
        _memberFilterView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        TYWeakSelf(self);
        
        _memberFilterView.memberFilterViewBlock = ^(JGJSynBillingModel *memberModel) {
          
            _isSelMember = NO;
            
            [weakself setMemberSelImageViewWithIsSelected:NO];
            
            weakself.memberModel = memberModel;
            
            if (weakself.recordWorkPointsFilterViewBlock) {
                
                weakself.recordWorkPointsFilterViewBlock(weakself.memberModel, weakself.proModel);
            }
            
            if ([NSString isEmpty:memberModel.class_type_id]) {
                
                weakself.memberLable.text = RecordMemberDes;
                
                if (![NSString isEmpty:weakself.proListModel.group_id]) {
                    
                    weakself.memberLable.text = AgencyDes;
                }
                
                weakself.memberLable.textColor = AppFont666666Color;
                
            }else {
                
                weakself.memberLable.text = memberModel.name;
                
                weakself.memberLable.textColor = AppFont333333Color;
            }
        };
    }
    
    return _memberFilterView;
}

- (void)removeProFilterView {
    
    if (self.proFilterView) {
        
        [self.proFilterView removeFromSuperview];
        
    }
}

- (void)removeMemberFilterView {
    
    if (self.memberFilterView) {
        
        [self.memberFilterView removeFromSuperview];
    }
}

//移除筛选界面 ,移除后恢复原状态
- (void)removeFilterView {
    
    _isSelMember = NO;
    
    [self setMemberSelImageViewWithIsSelected:NO];
    
    _isSelPro = NO;

    [self setProSelImageViewWithIsSelected:NO];
    
}

- (void)setAllMembers:(NSArray *)allMembers {
    
    _allMembers = allMembers;
    
    self.memberFilterView.staListModel = self.staListModel;
    
    self.memberFilterView.allMembers = _allMembers;

}

- (void)setAllPros:(NSArray *)allPros {
    
    _allPros = allPros;
    
    self.proFilterView.staListModel = self.staListModel;
    
    self.proFilterView.allPros = _allPros;
}

- (void)setStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    _staListModel = staListModel;
    
    self.proNameLable.text = AllProName;
    
    self.memberLable.text = RecordMemberDes;
    
    if (![NSString isEmpty:self.proListModel.group_id]) {
        
        self.memberLable.text = AgencyDes;
    }
    
    if ([staListModel.class_type isEqualToString:@"person"]) {
        
        self.memberLable.text = staListModel.name;
        
    }else if ([staListModel.class_type isEqualToString:@"project"]) {
        
        self.proNameLable.text = staListModel.name;
        
    }else if ((![NSString isEmpty:self.staListModel.pid] || ![NSString isEmpty:self.staListModel.class_type_id]) && [NSString isEmpty:staListModel.class_type]) {
        
        self.proNameLable.text = staListModel.proName?:@"";
        
        self.memberLable.text = staListModel.name?:@"";
    }

}

@end
