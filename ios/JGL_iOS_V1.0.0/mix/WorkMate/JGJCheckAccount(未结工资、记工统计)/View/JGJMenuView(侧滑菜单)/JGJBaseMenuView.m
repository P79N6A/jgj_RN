//
//  JGJBaseMenuView.m
//  mix
//
//  Created by yj on 2018/5/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJBaseMenuView.h"

#import "JGJProFilterView.h"

#import "JGJMemberFilterView.h"

#import "UIView+GNUtil.h"

#import "JGJFirstFilterView.h"

#import "JGJRecordHeader.h"

#define AllProName @"全部项目"

@interface JGJBaseMenuView () <JGJFirstFilterViewDelegate>

//存储子视图的容器，便于销毁
@property (nonatomic, strong) NSMutableArray *contains;

@property (nonatomic, assign) CGFloat originalY;

@property (strong, nonatomic) JGJProFilterView *proSelView;

@property (strong, nonatomic) JGJMemberFilterView *memberSelView;

@property (nonatomic, strong) JGJFirstFilterView *containView;

@end

@implementation JGJBaseMenuView

- (instancetype)initWithFrame:(CGRect)frame proListModel:(JGJMyWorkCircleProListModel *)proListModel{
    
    if (self = [super initWithFrame:frame]) {
        
        self.proListModel = proListModel;
        
        [self commonset];
    }
    
    return self;
    
}

- (void)commonset {

    _originalY = 40;
    
    _limiWidth = TYGetUIScreenWidth - _originalY;
    
    [self buttonActionBlock];
    
}

#pragma mark - 按钮按下，和人员、项目选中
- (void)buttonActionBlock {
    
    TYWeakSelf(self);
    
//       返回按钮
    self.memberSelView.backBlock = ^{
        
        [weakself removesubView];
    };
    
//选中人员
    self.memberSelView.memberFilterViewBlock = ^(JGJSynBillingModel *memberModel) {
        
        [weakself removesubView];
        
        weakself.containView.selMemberModel = memberModel;
        
    };
    
//  返回
    self.proSelView.backBlock = ^{
        
        [weakself removesubView];
    };
    
//选中项目
    self.proSelView.proFilterViewBlock = ^(JGJRecordWorkPointFilterModel *proModel) {
        
        [weakself removesubView];
        
        weakself.containView.selProModel = proModel;
        
        
    };
    
////确定按钮按下
//    self.containView.filterViewBlock = ^(JGJSynBillingModel *memberModel, JGJRecordWorkPointFilterModel *proModel, NSArray *tagModels, NSArray *remark_tagModels) {
//
//        [weakself removesubView];
//
//        if (weakself.baseMenuViewBlock) {
//
//            weakself.baseMenuViewBlock(memberModel, proModel, tagModels, remark_tagModels);
//
//        }
//
//    };
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self) {
        
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        
        CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
        
        int x = point.x;
        
        if (x > 0 && x < _originalY) {

            [self removeAllView];
        
            //回调刷新数据
            if (self.baseMenuViewBlock) {
                
                
                self.baseMenuViewBlock(_containView.selMemberModel, _containView.selProModel, _containView.tagView.tags, _containView.remarkTagView.tags, _containView.desInfos, NO, _containView.tagView.selTagModels, _containView.remarkTagView.selTagModels, _containView.agencyTagView.tags, _containView.agencyTagView.selTagModels);
                
                
            }
            

        }
        
    }
    
}

- (void)removesubView {
    
    if (self.contains.count > 0) {
        
        [self.contains enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self popView:subView animation:NO];
            
            *stop = YES;
            
        }];
        
    }else {
        
        [self popView:self animation:NO];
    }
}

- (void)pushView {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    [TYKey_Window addSubview:self];
    
    [self addQueueWithSubView:self.containView];

    
}

- (void)popView:(UIView *)view animation:(BOOL)animation{
    
    [self removeQueueWithSubView:view];
}

- (void)addQueueWithSubView:(UIView *)subView {
    
    if (![self.contains containsObject:subView]) {
    
        [self addSubview:subView];
        
        [self.contains addObject:subView];
        
        [self animateWithSubView:subView];
    }
    
}

- (void)animateWithSubView:(UIView *)subView {
    
    [UIView animateWithDuration:JGJBaseMenuViewDurTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        subView.x = _originalY;
        
        if ([subView isKindOfClass:NSClassFromString(@"JGJFirstFilterView")]) {
            
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)removeQueueWithSubView:(UIView *)subView {
    
     if ([self.contains containsObject:subView]) {
         
        [UIView animateWithDuration:JGJBaseMenuViewDurTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            if (self.contains.count == 2 && [self.containView isEqual:subView]) {
                
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

            }
            
            subView.x = TYGetUIScreenWidth;
            
        } completion:^(BOOL finished) {
            
            [subView removeFromSuperview];
            
            [self.contains removeObject:subView];

            if (self.contains.count == 1) {
                
                [self.contains removeAllObjects];
                
                [self removeFromSuperview];
            }
            
        }];
        
     }else {
         
         [self removeFromSuperview];
         
     }
    
}

#pragma mark - 移除所有视图
- (void)removeAllView {
    
    [UIView animateWithDuration:JGJBaseMenuViewDurTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _proSelView.x = TYGetUIScreenWidth;
        
        _containView.x = TYGetUIScreenWidth;
        
        _memberSelView.x = TYGetUIScreenWidth;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

        [self.contains removeAllObjects];

        [self clearSelMember];

        [self clearSelPro];
        
    }];
    
}

- (void)clearSelMember{
    
    if (_memberSelView.allMembers.count > 0) {

        _containView.selMemberModel.isSelected = NO;
        
        _memberSelView.headerView.isSelHeaderView = YES;
    }
    
}

- (void)clearSelPro{
    
    if (_proSelView.allPros.count > 0) {
        
        _containView.selProModel.isSel = NO;
    }
    
}

#pragma mark - setter


#pragma mark - delegate

#pragma mark - JGJFirstFilterViewDelegate

- (void)filterView:(JGJFirstFilterView *)filterView filterViewType:(JGJFirstFilterViewType)filterViewType memberModel:(JGJSynBillingModel *)memberModel proModel:(JGJRecordWorkPointFilterModel *)proModel {
    
    switch (filterViewType) {
            
        case JGJFirstFilterProType:{
            
            [self addQueueWithSubView:self.proSelView];
            
            JGJRecordWorkPointFilterModel *selProModel = [JGJRecordWorkPointFilterModel new];
            
            //当前显示的数据
            if (self.containView.desInfos.count > 0) {
                
                JGJComTitleDesInfoModel *desInfoModel = self.containView.desInfos[0];
                
                selProModel.name = desInfoModel.des;
                
                selProModel.class_type_id = desInfoModel.typeId;
            }
            
            if (![NSString isEmpty:selProModel.name]) {
                
                self.containView.selProModel = selProModel;
                
            }else
            
            if (!self.containView.selProModel) {
                
                if (self.staListModel) {
                    
                    if ([NSString isEmpty:self.staListModel.class_type_id]) {
                        
                        selProModel.name = AllProName;
                        
                        selProModel.class_type_id = @"0";
                        
                    }else {
                        
                        selProModel.class_type_id = self.staListModel.pid?:@"0";
                        
                        selProModel.name = self.staListModel.proName;
                    }
                }
                
                self.containView.selProModel = selProModel;
            }
            
            self.proSelView.selProModel = self.containView.selProModel;
            
            self.proSelView.allPros = self.allPros;
            
        }
            
            break;
            
        case JGJFirstFilterMemberType:{
            
            [self addQueueWithSubView:self.memberSelView];
            
            JGJSynBillingModel *selMemberModel = [JGJSynBillingModel new];
            
            //当前显示的数据
            if (self.containView.desInfos.count > 0) {
                
                JGJComTitleDesInfoModel *desInfoModel = self.containView.desInfos[1];
                
                selMemberModel.name = desInfoModel.des;
                
                selMemberModel.class_type_id = desInfoModel.typeId;
            }
            
            //当前显示的数据有名字
            if (![NSString isEmpty:selMemberModel.name]) {
                
                self.containView.selMemberModel = selMemberModel;
                
            }else
            
            //为空的情况
            if (!self.containView.selMemberModel) {
                
                JGJSynBillingModel *selMemberModel = [JGJSynBillingModel new];
                
                if (self.staListModel) {
                    
                    if ([NSString isEmpty:self.staListModel.class_type_id]) {
                        
                        selMemberModel.name = MemberDes;
                        
                        if (![NSString isEmpty:self.proListModel.group_id]) {
                            
                            selMemberModel.name = AgencyDes;
                        }
                        
                    }else {
                        
                        selMemberModel.class_type_id = self.staListModel.class_type_id;
                        
                        selMemberModel.name = self.staListModel.name;
                    }
                    
                }
                
                self.containView.selMemberModel = selMemberModel;
                
            }
            
            self.memberSelView.selMemberModel = self.containView.selMemberModel;
            
            self.memberSelView.allMembers = self.allMembers;
            
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)setStaListModel:(JGJRecordWorkStaListModel *)staListModel {
    
    _staListModel = staListModel;
    
     JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
    
    JGJRecordWorkPointFilterModel *selProModel = [[JGJRecordWorkPointFilterModel alloc] init];
    
    //之前保存的记录
    if (self.proInfos.count > 0 && !self.isRest) {
       
        JGJComTitleDesInfoModel *proInfoModel = self.proInfos[0];
        
        selProModel.class_type_id = proInfoModel.typeId;
        
        selProModel.name = proInfoModel.des;
        
        JGJComTitleDesInfoModel *memberInfoModel = self.proInfos[1];
        
        memberModel.name = memberInfoModel.des;
        
        memberModel.class_type_id = memberInfoModel.typeId;
        
        self.containView.selMemberModel = memberModel;
        
        self.containView.selProModel = selProModel;
    
    }else if (_staListModel) {
        
        //项目类型是人的则项目是0
        if ([_staListModel.class_type isEqualToString:@"person"]) {
            
            memberModel.class_type_id = staListModel.class_type_id; //class_type_id是人员id
            
            if ([NSString isEmpty:_staListModel.name]) {
                
                memberModel.name = MemberDes;
                
                if (![NSString isEmpty:self.proListModel.group_id]) {
                    
                    memberModel.name = AgencyDes;
                }
                
            }else {
                
                memberModel.name = staListModel.name;
            }
            
            selProModel.name = self.staListModel.target_name?:AllProName;
            
            selProModel.class_type_id = staListModel.class_type_target_id;
            
            if ([NSString isEmpty:staListModel.class_type_target_id]) {
                
                selProModel.class_type_id = @"0";
                
                selProModel.name = AllProName;
            }
        
        }
        
        //类型是项目人名是全部人员
        if ([_staListModel.class_type isEqualToString:@"project"]) {
            
            if (![NSString isEmpty:_staListModel.name]) {
                
                _staListModel.proName = _staListModel.name;
            
            }
            
            if ([NSString isEmpty:_staListModel.proName] && [NSString isEmpty:_staListModel.name]) {
                
                selProModel.name = AllProName;
                
                selProModel.class_type_id = @"0";
                
            }else {
                
                selProModel.class_type_id = staListModel.class_type_id?:@"0"; //class_type_id是项目id
                
                selProModel.name = staListModel.target_name;
                
                if (![NSString isEmpty:_staListModel.proName]) {
                    
                    selProModel.name = staListModel.name;
                    
                }else {
                    
                    selProModel.name = AllProName;
                }
                
            }
    
#pragma mark - 记录一下错误 #20508 的修改情况
            if (![NSString isEmpty:_staListModel.target_name] && JLGisLeaderBool) {
                
                memberModel.name = _staListModel.target_name;
                memberModel.class_type_id = _staListModel.class_type_target_id;
                
            }else {
                
                memberModel.name = MemberDes;
                //class_type_target_id是人员的uid
                memberModel.class_type_id = @"";
            }
            
            if (![NSString isEmpty:self.proListModel.group_id]) {
                
                memberModel.name = AgencyDes;
            }
            
        }
        
        //没有类型的是从记多天进来,有人有项目
        if ([NSString isEmpty:_staListModel.class_type]) {
            
            if ([staListModel.pid isEqualToString:@"-1"]) {
                
                selProModel.class_type_id = @"0";
                
            }else {
                
               selProModel.class_type_id = staListModel.pid?:@"0";
            }
            
            
            if ([NSString isEmpty:_staListModel.proName]) {
                
                selProModel.name = AllProName;
                
            }else {
                
                selProModel.name = staListModel.proName;
            }
            
            if ([NSString isEmpty:_staListModel.name]) {
                
                memberModel.name = MemberDes;
                
                if (![NSString isEmpty:self.proListModel.group_id]) {
                    
                    memberModel.name = AgencyDes;
                }
                
            }else {
                
                memberModel.name = staListModel.name;
            }
            
            memberModel.class_type_id = staListModel.class_type_id;
        }
        
        self.containView.selMemberModel = memberModel;
        
        self.containView.selProModel = selProModel;
        
    }
    
}

#pragma mark - getter

- (NSMutableArray *)contains {
    
    if (!_contains) {
        
        _contains = [[NSMutableArray alloc] init];
        
        [_contains addObject:self];
    }
    
    return _contains;
}

- (JGJFirstFilterView *)containView {
    
    if (!_containView) {
        
        _containView = [[JGJFirstFilterView alloc] initWithFrame:CGRectMake(_limiWidth, 0, _limiWidth, TYGetUIScreenHeight)];
        
        //代班长
        _containView.proModel = self.proListModel;
        
        _containView.proInfos = self.proInfos;
        
        _containView.recordTags = self.recordTags;
        
        _containView.notetags = self.notetags;
        
        //代理人
        _containView.agencytags = self.agencytags;
        
        //选中的模型
        _containView.selrecordTtags = self.selrecordTtags;
        
        _containView.selnotetags  = self.selnotetags;
        
        //代理人
        _containView.selAgencytags = self.selAgencytags;
        
        _containView.delegate = self;
                
        _containView.staModel = self.staListModel;
        
        _containView.backgroundColor = [UIColor whiteColor];
        
        TYWeakSelf(self);

        //确定按钮按下
        _containView.filterViewBlock = ^(JGJSynBillingModel *memberModel, JGJRecordWorkPointFilterModel *proModel, NSArray *tagModels, NSArray *remark_tagModels, NSArray *desInfos, BOOL isRest, NSArray *seltagModels, NSArray *selremark_tagModels, NSArray *agentags, NSArray *selAgentags) {
            
            [weakself clearSelMember];
            
            [weakself clearSelPro];
            
            if (weakself.baseMenuViewBlock) {
                
                weakself.baseMenuViewBlock(memberModel, proModel, tagModels, remark_tagModels, desInfos, isRest, seltagModels, selremark_tagModels, agentags, selAgentags);
                
            }
            
            // desInfos 等于0是复位标识不移除，只清楚数据
            if (desInfos.count > 0) {
                
                [weakself removeAllView]; ;
            }
            
        };
    }
    
    return _containView;
}

- (JGJProFilterView *)proSelView {
    
    if (!_proSelView) {
        
        _proSelView = [[JGJProFilterView alloc] initWithFrame:CGRectMake(_limiWidth, 0, _limiWidth, TYGetUIScreenHeight)];
    }
    
    return _proSelView;
}

- (JGJMemberFilterView *)memberSelView {
    
    if (!_memberSelView) {
        
        _memberSelView = [[JGJMemberFilterView alloc] initWithFrame:CGRectMake(_limiWidth, 0, _limiWidth, TYGetUIScreenHeight) proListModel:self.proListModel];
        
    }
    
    return _memberSelView;
}

#pragma mark - 是否代理班组长
- (BOOL)isAgency {
    
    return ![NSString isEmpty:self.proListModel.group_id];
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    self.memberSelView.proListModel = proListModel;
    
}

@end
