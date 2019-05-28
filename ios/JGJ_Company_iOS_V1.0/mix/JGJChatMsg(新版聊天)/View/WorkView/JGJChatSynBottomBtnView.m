//
//  JGJChatSynCreatProBtnView.m
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJChatSynBottomBtnView.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
@interface JGJChatSynBottomBtnView()

@property (strong, nonatomic) IBOutlet UIView *contentView;

//拒绝 、创建项目
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

//同步、加入现有班组
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightW;

@end

@implementation JGJChatSynBottomBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
}

- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    _jgjChatListModel = jgjChatListModel;
    
    NSString *leftBtntitle = @"";
    
    NSString *rightBtntitle = @"";
    
    CGFloat ratio = 3;
    
    UIColor *leftlayerCor = AppFontffffffColor;
    
    UIColor *rightlayerCor = AppFontffffffColor;
    
    UIColor *leftTextCor = AppFont000000Color;
    
    UIColor *rightTextCor = AppFontffffffColor;
    
    UIColor *leftBackCor = AppFontffffffColor;
    
    UIColor *rightBackCor = AppFontffffffColor;
    
    self.checkBtn.hidden = YES;
    
    self.leftBtn.hidden = NO;
    
    self.rightBtn.hidden = NO;
    
    CGFloat rightBtnW = 105;
        
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    switch (jgjChatListModel.chatListType) {

        case JGJChatListSyncProjectToYouType: {// 创建项目 和加入现有项目

//            if ([JGJChatMsgDBManger queryLocalIsHaveTeamProject]) {
//
//                leftBtntitle = @"创建新项目组";
//
//                rightBtntitle = @"加入现有项目";
//
//                rightBtnW = 105;
//
//                leftlayerCor = AppFontEB4E4EColor;
//
//                rightlayerCor = AppFontEB4E4EColor;
//
//                leftTextCor = AppFontEB4E4EColor;
//
//                rightTextCor = AppFontEB4E4EColor;
//
//            }else {
//
//                self.leftBtn.hidden = YES;
//                rightBtntitle = @"创建新项目组";
//                rightBtnW = 105;
//                rightlayerCor = AppFontEB4E4EColor;
//                rightTextCor = AppFontEB4E4EColor;
//            }
            
            self.checkBtn.hidden = YES;
            
            self.leftBtn.hidden = YES;
            
            self.rightBtn.hidden = NO;
            
            rightBtntitle = @"查看详情";
            
            rightBtnW = 105;
            
            self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
            
            self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -65);
            
            [self.rightBtn setImage:[UIImage imageNamed:@"check_right_icon"] forState:UIControlStateNormal];
            
            self.rightBtn.titleLabel.font = FONT(AppFont32Size);
            self.rightBtn.userInteractionEnabled = NO;
            leftlayerCor = AppFontffffffColor;
            
            rightlayerCor = AppFontffffffColor;
            
            leftTextCor = AppFont000000Color;
            
            rightTextCor = AppFont000000Color;
            
        }
            break;
            
        case JGJChatListDemandSyncProjectType :{//请求同步项目 请求同步记工

//            leftBtntitle = @"拒绝";
//
//            rightBtntitle = @"同步";
//
//            rightBtnW = 50;
//
//            leftlayerCor = AppFont666666Color;
//
//            rightlayerCor = AppFontEB4E4EColor;
//
//            leftTextCor = AppFont000000Color;
//
//            rightTextCor = AppFontffffffColor;
//
//            leftBackCor = AppFontffffffColor;
//
//            rightBackCor = AppFontEB4E4EColor;
            
            self.checkBtn.hidden = YES;
            
            self.leftBtn.hidden = YES;
            
            self.rightBtn.hidden = NO;
            
            rightBtntitle = @"查看详情";
            
            rightBtnW = 105;
            
            self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
            
            self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -65);
            
            [self.rightBtn setImage:[UIImage imageNamed:@"check_right_icon"] forState:UIControlStateNormal];
            
            self.rightBtn.titleLabel.font = FONT(AppFont32Size);
            self.rightBtn.userInteractionEnabled = NO;
            leftlayerCor = AppFontffffffColor;
            
            rightlayerCor = AppFontffffffColor;
            
            leftTextCor = AppFont000000Color;
            
            rightTextCor = AppFont000000Color;

        }
            break;
            
            
        case JGJChatListAgreeSyncProjectType:
        case JGJChatListAgreeSyncProjectToYouType:{ // 记工同步请求

            self.checkBtn.hidden = YES;

            self.leftBtn.hidden = YES;

            self.rightBtn.hidden = NO;

            rightBtntitle = @"查看详情";

            rightBtnW = 105;

            self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

            self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
            
            self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -65);

            [self.rightBtn setImage:[UIImage imageNamed:@"check_right_icon"] forState:UIControlStateNormal];

            self.rightBtn.titleLabel.font = FONT(AppFont32Size);
            self.rightBtn.userInteractionEnabled = NO;
            leftlayerCor = AppFontffffffColor;

            rightlayerCor = AppFontffffffColor;

            leftTextCor = AppFont000000Color;

            rightTextCor = AppFont000000Color;
        }
            break;

        default:
            break;
    }
    
    
    
    [self.leftBtn.layer setLayerBorderWithColor:leftlayerCor width:1 radius:ratio];
    
    [self.rightBtn.layer setLayerBorderWithColor:rightlayerCor width:1 radius:ratio];
    
    [self.leftBtn setTitleColor:leftTextCor forState:UIControlStateNormal];
    
    [self.rightBtn setTitleColor:rightTextCor forState:UIControlStateNormal];
    
    [self.leftBtn setTitle:leftBtntitle forState:UIControlStateNormal];
    
    [self.rightBtn setTitle:rightBtntitle forState:UIControlStateNormal];
    
    self.leftBtn.backgroundColor = leftBackCor;
    
    self.rightBtn.backgroundColor = rightBackCor;
    
    [self jgj_updateConstraint:self.rightW withConstant:rightBtnW];
    
}

- (void)jgj_updateConstraint:(NSLayoutConstraint *)constraint withConstant:(CGFloat)constant
{
    if (constraint.constant == constant) {
        return;
    }
    
    constraint.constant = constant;
}

- (IBAction)creatButtonPressed:(UIButton *)sender {// 点击左边按钮
    
    switch (_jgjChatListModel.chatListType) {
            
        case JGJChatListSyncProjectToYouType:{// 加入现有项目
            
            if (self.actionBlock) {
                if ([JGJChatMsgDBManger queryLocalIsHaveTeamProject]) { // 此时 两个按钮 左边是创建项目 右边是加入现有项目
                    
                    self.actionBlock(JGJChatCreatProType,self.jgjChatListModel);
                    
                }
                
            }
        }
            break;
            
        case JGJChatListDemandSyncBillType :
        case JGJChatListDemandSyncProjectType:{// 拒绝
            
            if (self.actionBlock) {
                
                self.actionBlock(JGJChatRefuseSynType,self.jgjChatListModel);
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)joinButtonPressed:(UIButton *)sender {// 点击右边按钮
    
    switch (_jgjChatListModel.chatListType) {
            
        case JGJChatListSyncProjectToYouType:{// 创建新项目组
            
            if (self.actionBlock) {
                
                if ([JGJChatMsgDBManger queryLocalIsHaveTeamProject]) { // 此时 两个按钮 左边是创建项目 右边是加入现有项目
                    
                    self.actionBlock(JGJChatJoinproType,self.jgjChatListModel);
                    
                }else {// 此时只有一个右边按钮 为创建项目按钮
                    
                    self.actionBlock(JGJChatCreatProType,self.jgjChatListModel);
                }
                
            }
        }
            break;
            
        case JGJChatListDemandSyncBillType :
        case JGJChatListDemandSyncProjectType:{// 同步
            
            if (self.actionBlock) {
                
                self.actionBlock(JGJChatAgreeSynType,self.jgjChatListModel);
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
