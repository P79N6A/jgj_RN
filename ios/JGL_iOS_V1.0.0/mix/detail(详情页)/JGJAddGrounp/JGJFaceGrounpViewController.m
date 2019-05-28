//
//  JGJFaceGrounpViewController.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJFaceGrounpViewController.h"
#import "JGJKeyboardView.h"
#import "JGJTopGroupView.h"
#import "JGJAddPeopleToGroupListView.h"
#import "JGJNetAnimation.h"
#import "JGJGetViewFrame.h"
#import "JGJChatRootVc.h"
#import "YQShadowLable.h"

#import "JGJChatMsgDBManger+JGJGroupDB.h"

#import "JGJMangerTool.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size
#define RGB_COLOR(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
@interface JGJFaceGrounpViewController ()<ClickKerBoradButtondelegate,Joindelegate>
{
    NSString *PassWordStr;
    JGJMyWorkCircleProListModel *JoingroupChatModel;
    NSArray *_joinContacts;
    JGJKeyboardView *KeyBoardView;
}
@property(nonatomic ,strong)JGJTopGroupView *topview;
@property(nonatomic ,strong)UIView *AnimalView;
@property(nonatomic ,strong)UILabel *bottomLable;
@property(nonatomic ,strong)JGJAddPeopleToGroupListView *listcollectionview;
@property(nonatomic,strong)JGJNetAnimation *animationview;
@property(nonatomic,strong)UIView *TOPPassView;

@property (nonatomic, strong) JGJMangerTool *tool;

@end

@implementation JGJFaceGrounpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  KeyBoardView = [[JGJKeyboardView alloc]initWithFrame:CGRectMake(0, ScreenWidth.height - 300 - JGJ_IphoneX_BarHeight, ScreenWidth.width, 240)];
//    self.view.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = AppFont1e1e1eColor;

    KeyBoardView.numdelegate = self;
    [self.view addSubview:KeyBoardView];
    [self.view addSubview:self.TOPPassView];
    [self.view addSubview:self.DesCriptionLable];
    [self.view addSubview:self.OnePassWorldLable];

    [self.view addSubview:self.TwoPassWorldLable];
    [self.view addSubview:self.ThreePassWorldLable];
    [self.view addSubview:self.FourPassWorldLable];
    [self.view addSubview:self.bottomLable];
    self.navigationItem.titleView = self.topview;
    
    //间隔获取人员数据
    [self intervalLoadData];
    
   }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self BackItem];

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(UIView *)TOPPassView
{
    if (!_TOPPassView) {
//        _TOPPassView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth.width, 85)];
//        _TOPPassView.backgroundColor = [UIColor darkGrayColor];
    }
    return _TOPPassView;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[JGJGetViewFrame saImageWithSingleColor:[UIColor whiteColor]]
//                                                 forBarPosition:UIBarPositionAny
//                                                     barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    //回复那条线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"barButtonItem_transparent"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    if (self.tool) {
        
        //定时器失效
        [self.tool inValidTimer];
        
        self.tool = nil;
    }
    
}

-(JGJTopGroupView *)topview
{
    if (!_topview) {
        _topview = [[JGJTopGroupView alloc]initWithFrame:CGRectMake((ScreenWidth.width-120)/2, 0, 120, 60)];
        
    }

    return _topview;
}
-(JGJAddPeopleToGroupListView *)listcollectionview
{
    if (!_listcollectionview) {
        //- JGJ_IphoneX_BarHeight
        
        _listcollectionview = [[JGJAddPeopleToGroupListView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomLable.frame)+5, ScreenWidth.width, ScreenWidth.height-CGRectGetMaxY(_bottomLable.frame))];
        _listcollectionview.delegate =self;
        
        
    }
    return _listcollectionview;
}
-(UILabel *)OnePassWorldLable
{
    if (!_OnePassWorldLable) {
        
        _OnePassWorldLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth.width-203)/2, CGRectGetMaxY(_DesCriptionLable.frame) + 22, 38, 54)];
//        _OnePassWorldLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_facetoface@2x"]];
        _OnePassWorldLable.backgroundColor = AppFont101010Color;
        _OnePassWorldLable.textColor =  RGB_COLOR(9, 154, 255);
        _OnePassWorldLable.layer.masksToBounds = YES;
        _OnePassWorldLable.layer.cornerRadius = 4;
        _OnePassWorldLable.textAlignment = NSTextAlignmentCenter;
        _OnePassWorldLable.font = [UIFont systemFontOfSize:23];
        
        
    }
    return _OnePassWorldLable;
}

-(UILabel *)TwoPassWorldLable
{
    if (!_TwoPassWorldLable) {
        _TwoPassWorldLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_OnePassWorldLable.frame)+17, CGRectGetMaxY(_DesCriptionLable.frame)+22, 38, 54)];
//        _TwoPassWorldLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_facetoface@2x"]];
        _TwoPassWorldLable.backgroundColor = AppFont101010Color;
        _TwoPassWorldLable.textColor =  RGB_COLOR(9, 154, 255);
        _TwoPassWorldLable.layer.masksToBounds = YES;
        _TwoPassWorldLable.layer.cornerRadius = 4;
        _TwoPassWorldLable.textAlignment = NSTextAlignmentCenter;
        _TwoPassWorldLable.font = [UIFont systemFontOfSize:23];
    }
    return _TwoPassWorldLable;
}
-(UILabel *)ThreePassWorldLable
{

    if (!_ThreePassWorldLable) {
        
        _ThreePassWorldLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_TwoPassWorldLable.frame)+17, CGRectGetMaxY(_DesCriptionLable.frame)+22, 38, 54)];
//        _ThreePassWorldLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_facetoface@2x"]];
        _ThreePassWorldLable.backgroundColor = AppFont101010Color;
        _ThreePassWorldLable.textColor =  RGB_COLOR(9, 154, 255);
        _ThreePassWorldLable.layer.masksToBounds = YES;
        _ThreePassWorldLable.layer.cornerRadius = 4;
        _ThreePassWorldLable.textAlignment = NSTextAlignmentCenter;
        _ThreePassWorldLable.font = [UIFont systemFontOfSize:23];
    }
    return _ThreePassWorldLable;

}

-(UILabel *)FourPassWorldLable
{

    if (!_FourPassWorldLable) {
        
        _FourPassWorldLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_ThreePassWorldLable.frame)+17, CGRectGetMaxY(_DesCriptionLable.frame)+22, 38, 54)];
//        _FourPassWorldLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_facetoface@2x"]];
        _FourPassWorldLable.backgroundColor = AppFont101010Color;
        _FourPassWorldLable.textColor = RGB_COLOR(9, 154, 255);
        _FourPassWorldLable.layer.masksToBounds = YES;
        _FourPassWorldLable.layer.cornerRadius = 4;
        _FourPassWorldLable.textAlignment = NSTextAlignmentCenter;
        _FourPassWorldLable.font = [UIFont systemFontOfSize:23];

    }
    return _FourPassWorldLable;
}

-(UILabel *)DesCriptionLable
{
    if (!_DesCriptionLable) {
        _DesCriptionLable = [[UILabel alloc]initWithFrame:CGRectMake((TYGetUIScreenWidth-205)/2, 50, 205, 60)];
        _DesCriptionLable.numberOfLines = 2;
        _DesCriptionLable.textColor = AppFont999999Color;
        _DesCriptionLable.text = @"和身边的朋友输入相同的数字进入同一个群聊";
        _DesCriptionLable.textAlignment = NSTextAlignmentCenter;
        _DesCriptionLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
    }

    return _DesCriptionLable;

}
-(UIView *)AnimalView
{
    if (!_AnimalView) {
        _AnimalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth.width, 200)];
        [_AnimalView addSubview:self.OnePassWorldLable];
        [_AnimalView addSubview:self.TwoPassWorldLable];
        [_AnimalView addSubview:self.ThreePassWorldLable];
        [_AnimalView addSubview:self.FourPassWorldLable];
        [_AnimalView addSubview:self.bottomLable];
        

    }

    return _AnimalView;
}
-(UILabel *)bottomLable
{
    if (!_bottomLable) {
        _bottomLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_OnePassWorldLable.frame)+10, ScreenWidth.width, 30)];
        _bottomLable.text = @"这些朋友也将进入群聊";
        _bottomLable.textAlignment = NSTextAlignmentCenter;
        _bottomLable.font = [UIFont systemFontOfSize:16];
        _bottomLable.textColor = AppFont999999Color;
        _bottomLable.alpha = 0;
    }
    return _bottomLable;
}


-(void)ClickKeyBoardnumberButtonToString:(NSString *)numberStr
{
    if ([numberStr intValue] == 10) {
        return;
    }
    if ([numberStr intValue]==12) {
        if (PassWordStr.length == 0) {
            
        }else{
            
            NSString *str = PassWordStr;
            PassWordStr = [str substringToIndex:PassWordStr.length-1];
        }
    }else{
        if ([PassWordStr isKindOfClass:[NSNull class]]||PassWordStr.length == 0) {
            PassWordStr = numberStr;
        }else{
            if (PassWordStr.length>4) {
                return;
            }
            NSString *str = PassWordStr;
            PassWordStr = [NSString stringWithFormat:@"%@%@",str,numberStr];
        }
    }

    /*
    switch (PassWordStr.length) {
            case 0:
           self.OnePassWorldLable.text   = nil;
            break;
        case 1:
            self.OnePassWorldLable.text   = [PassWordStr substringWithRange:NSMakeRange(0, 1)];
            self.TwoPassWorldLable.text   =  nil;
            self.ThreePassWorldLable.text =  nil;
           self.FourPassWorldLable.text  =  nil;
            break;
        case 2:
            self.TwoPassWorldLable.text   = [PassWordStr substringWithRange:NSMakeRange(1, 1)];
            self.ThreePassWorldLable.text =  nil;
            self.FourPassWorldLable.text  =  nil;
            break;
        case 3:
           self.ThreePassWorldLable.text = [PassWordStr substringWithRange:NSMakeRange(2, 1)];
           self.FourPassWorldLable.text  =  nil;

            break;
        case 4:
            self.FourPassWorldLable.text  = [PassWordStr substringWithRange:NSMakeRange(3, 1)];

            break;
        default:
            break;
    }*/
    switch (PassWordStr.length) {
        case 0:
            self.OnePassWorldLable.text   = @"";
            self.TwoPassWorldLable.text   =  @"";
            self.ThreePassWorldLable.text =  @"";
            self.FourPassWorldLable.text  =  @"";
            break;
        case 1:
            [self.OnePassWorldLable removeFromSuperview];
            self.OnePassWorldLable = nil;
            [self.view addSubview:self.OnePassWorldLable];
            self.OnePassWorldLable.text   = [PassWordStr substringWithRange:NSMakeRange(0, 1)];
            self.TwoPassWorldLable.text   =  @"";
            self.ThreePassWorldLable.text =  @"";
            self.FourPassWorldLable.text  =  @"";
            break;
        case 2:
            [self.OnePassWorldLable removeFromSuperview];
            self.OnePassWorldLable = nil;
            [self.view addSubview:self.OnePassWorldLable];
            
            [self.TwoPassWorldLable removeFromSuperview];
            self.TwoPassWorldLable = nil;
            [self.view addSubview:self.TwoPassWorldLable];
            
            self.OnePassWorldLable.text   = [PassWordStr substringWithRange:NSMakeRange(0, 1)];
            self.TwoPassWorldLable.text   =  [PassWordStr substringWithRange:NSMakeRange(1, 1)];
            self.ThreePassWorldLable.text =  @"";
            self.FourPassWorldLable.text  =  @"";

            break;
        case 3:
            [self.OnePassWorldLable removeFromSuperview];
            self.OnePassWorldLable = nil;
            [self.view addSubview:self.OnePassWorldLable];
            
            [self.TwoPassWorldLable removeFromSuperview];
            self.TwoPassWorldLable = nil;
            [self.view addSubview:self.TwoPassWorldLable];
            
            [self.ThreePassWorldLable removeFromSuperview];
            self.ThreePassWorldLable = nil;
            [self.view addSubview:self.ThreePassWorldLable];

            self.OnePassWorldLable.text   = [PassWordStr substringWithRange:NSMakeRange(0, 1)];
            self.TwoPassWorldLable.text   =  [PassWordStr substringWithRange:NSMakeRange(1, 1)];
            self.ThreePassWorldLable.text =  [PassWordStr substringWithRange:NSMakeRange(2, 1)];
            self.FourPassWorldLable.text  =  @"";

            
            break;
        case 4:
            self.OnePassWorldLable.text   = [PassWordStr substringWithRange:NSMakeRange(0, 1)];
            self.TwoPassWorldLable.text   =  [PassWordStr substringWithRange:NSMakeRange(1, 1)];
            self.ThreePassWorldLable.text =  [PassWordStr substringWithRange:NSMakeRange(2, 1)];
            self.FourPassWorldLable.text  =  [PassWordStr substringWithRange:NSMakeRange(3, 1)];
            
            break;
        default:
            break;
    }

    
    if (PassWordStr.length == 4) {
        
        [self.view addSubview:self.animationview];
        [self StartAnimation];
        [TYLoadingHub showLoadingWithMessage:nil];
        [self PeopleJoinGroup];
    }

}
#pragma mark 开始上移动化
- (void)StartAnimation {
    
    _DesCriptionLable.text = @"";

    [UIView animateWithDuration:.5 animations:^{
        
        _OnePassWorldLable.transform = CGAffineTransformMakeTranslation(0, -100);
        _TwoPassWorldLable.transform = CGAffineTransformMakeTranslation(0, -100);
        _ThreePassWorldLable.transform = CGAffineTransformMakeTranslation(0, -100);
        _FourPassWorldLable.transform = CGAffineTransformMakeTranslation(0, -100);
        _bottomLable.transform = CGAffineTransformMakeTranslation(0, -100);
        _bottomLable.alpha = 1;

    } completion:^(BOOL finished) {
    
        [self.view addSubview:self.listcollectionview];
        _listcollectionview.frame = CGRectMake(0, CGRectGetMaxY(_bottomLable.frame)+5, ScreenWidth.width, ScreenWidth.height-CGRectGetMaxY(_bottomLable.frame));
        [_DesCriptionLable removeFromSuperview];
        _DesCriptionLable = nil;
    }];
}

-(JGJNetAnimation *)animationview
{
    if (!_animationview) {
        _animationview = [[JGJNetAnimation alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomLable.frame)+10, ScreenWidth.width, 40)];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [_animationview stopAnimation];
//
//        });
    }
    return _animationview;
    
}
#pragma mark -面对面建群加入者回调

-(void)PeopleJoinGroup
{
    if ([NSString isEmpty:PassWordStr]) {
        
        return;
    }
    
    NSDictionary *body = @{
                           
                           @"code":PassWordStr
                           
                           };
    
    [JLGHttpRequest_AFN PostWithNapi:JGJGroupFaceToFaceURL parameters:body success:^(id responseObject) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        array = responseObject;
        
        self.listcollectionview.JoinArray = array;
        
        _joinContacts = [JGJSynBillingModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)intervalLoadData {
    
    //间隔1s获取人员
    
    if (!self.tool) {
        
        JGJMangerTool *tool = [JGJMangerTool mangerTool];
        
        tool.inValidCount = 3.0;
        
        self.tool = tool;
        
    }
    
    if (![self.tool startTimer]) {
        
        [self.tool startTimer];
    }
    
    __weak JGJMangerTool *weakTool = self.tool;
    
    TYWeakSelf(self);
    
    self.tool.toolTimerBlock = ^{
        
        [weakself PeopleJoinGroup];
        
        TYLog(@"face-to-face");
        
    };
}

- (void)handleCreatGroupChatRequest:(NSArray *)ModelArray {
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid!=%@", myUid];
    
    ModelArray = [ModelArray filteredArrayUsingPredicate:predicate];
    
    NSMutableString *membersUidStr = [NSMutableString string];
    for (JGJSynBillingModel *memberModel in ModelArray) {
        [membersUidStr appendFormat:@"%@,",memberModel.uid];
    }
    //    删除末尾的逗号
    if (membersUidStr.length > 0 && membersUidStr != nil) {
        [membersUidStr deleteCharactersInRange:NSMakeRange(membersUidStr.length - 1, 1)];
    }
    NSDictionary *parameters = @{
                                 @"code": PassWordStr?:@"",
                                 @"uid" : membersUidStr?:@""};
    
    TYLog(@"uid %@",parameters);
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:JGJCreateChatURL parameters:parameters success:^(id responseObject) {
        
        JoingroupChatModel = [JGJMyWorkCircleProListModel mj_objectWithKeyValues:responseObject];
        
        [self handleJoinGroupChatWithgroupChatModel:JoingroupChatModel];
        
        JGJChatGroupListModel *groupModel = [JGJChatGroupListModel mj_objectWithKeyValues:[JoingroupChatModel mj_JSONObject]];
        
        groupModel.max_asked_msg_id = @"0";
        
        groupModel.sys_msg_type = @"normal";
        
        groupModel.local_head_pic = [JoingroupChatModel.members_head_pic mj_JSONString];
        
        [JGJChatMsgDBManger insertGroupDBWithGroupModel:groupModel isHomeVc:NO];
        
        [TYLoadingHub hideLoadingView];
        
        //定时器失效
        [self.tool inValidTimer];
        
        self.tool = nil;
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

#pragma mark -设置返回按钮
-(void)BackItem{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 60, 44);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    UIImage * bImage = [[UIImage imageNamed:@"barButtonItem_back_white"]
//                        resizableImageWithCapInsets: UIEdgeInsetsMake(0, -20, 0, 0)];
    [btn addTarget:self action: @selector(backButtonClick)forControlEvents: UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState: UIControlStateNormal];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = lb;
    
    // 让按钮内部的所有内容左对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 让按钮的内容往左边偏移10
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    
    [self.navigationController.navigationBar setBackgroundImage:[JGJGetViewFrame saImageWithSingleColor:AppFont1e1e1eColor]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barTintColor = AppFont1e1e1eColor;
    

    
}
-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 点击加入群聊按钮
-(void)ClickjoinGroup
{

    if(_joinContacts){
        [self handleCreatGroupChatRequest:_joinContacts];

    }else{
        [TYShowMessage showError:@"进入群聊失败"];
        
    }

}


#pragma mark - 进入群聊
- (void)handleJoinGroupChatWithgroupChatModel:(JGJMyWorkCircleProListModel *)groupChatModel {
    
    JGJChatRootVc *chatRootVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatRootCommonVc"];
    chatRootVc.workProListModel = groupChatModel; //进入群聊
    [self.navigationController pushViewController:chatRootVc animated:YES];
}
@end
