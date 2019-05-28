//
//  JGJMarkBillBaseVc.m
//  mix
//
//  Created by 任涛 on 16/6/6.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMarkBillBaseVc.h"
#import "TYBaseTool.h"
#import "TYShowMessage.h"
#import "UIImage+Cut.h"
#import "NSString+File.h"
#import "AudioRecordingServices.h"
#import "YZGRecordWorkPointGuideView.h"

#import "YZGMateWorkitemsViewController.h"
#import "YZGGetIndexRecordViewController.h"
#import "YZGOnlyAddProjectViewController.h"
#import "YZGAddForemanAndMateViewController.h"
#import "JGJBillEditProNameViewController.h"

//子类，用于获取
#import "JGJMarkDayBillVc.h"
#import "JGJMarkBorrowBillVc.h"
#import "JGJMarkContractBillVc.h"
#import "UIImage+TYALAssetsLib.h"
#import "JGJMoreDayViewController.h"
//保存数据的文件
#import "YZGMateShowpoor.h"
#define JGJMarkDayBaseInfoFile [TYUserDocumentPaths stringByAppendingString:@"/JGJMarkDayBaseInfo.jgj"]

static const CGFloat kMarkBillNormalCellHeight = 50;
static const CGFloat kMarkBillMoneyCellHeight = 90;//输入工钱的高度
//static const CGFloat kMarkBillAudioCellHeight = 280;//有语音的cell
static const NSInteger kPicMaxNum = 4;//最多可以上传的图片数

@interface JGJMarkBillBaseVc ()
<
    JLGPickerViewDelegate,
    UICollectionViewDelegate,
    YZGAudioAndPicTableViewCellDelegate,
    YZGRecordWorkPointGuideViewDelegate,
    YZGMateShowpoorDelegate
>
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic,strong) NSMutableArray *proNameArray;//项目名称
@property (nonatomic,assign) CGFloat cellTextViewHeight;
@property (nonatomic,strong) YZGRecordWorkPointGuideView *recordWorkPointGuideView;
@property (nonatomic,strong) UIButton *saveButton;//保存的按钮
@property (nonatomic, strong) UIView *containSaveButtonView; //容纳保存按钮容器
@property (nonatomic,assign) BOOL needUseIntroductions;//需要显示使用说明
@property (nonatomic,strong) UIButton *delButton;//删除的按钮
@property (nonatomic,assign) float workTime;//删除的按钮
@property (nonatomic, assign)float overtime;
@property (nonatomic,strong) YZGGetBillModel *saveModel;//删除的按钮
@property (nonatomic, strong) YZGMateShowpoor *yzgMateShowpoor;

@end

@implementation JGJMarkBillBaseVc
//@synthesize yzgGetBillModel = _yzgGetBillModel;

+ (instancetype)getSubVc:(MateWorkitemsItems *)mateWorkitemsItems{
    JGJMarkBillBaseVc *jgjMarkBillBaseVc;
    switch (mateWorkitemsItems.accounts_type.code) {
        case 1:
            jgjMarkBillBaseVc = [[JGJMarkDayBillVc alloc] init];
            break;
        case 2:
            jgjMarkBillBaseVc = [[JGJMarkContractBillVc alloc] init];
            break;
        case 3:
            jgjMarkBillBaseVc = [[JGJMarkBorrowBillVc alloc] init];
            break;
        case 4:
            jgjMarkBillBaseVc = [[JGJMarkBorrowBillVc alloc] init];
            break;
        default:
            break;
    }
    return jgjMarkBillBaseVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self layoutInit];
    
}
- (YZGMateShowpoor *)yzgMateShowpoor
{
    if (!_yzgMateShowpoor) {
        _yzgMateShowpoor = [[YZGMateShowpoor alloc] initWithFrame:TYGetUIScreenRect];
        _yzgMateShowpoor.delegate = self;
    }
    return _yzgMateShowpoor;
}
#pragma mark - dataInit
- (void)dataInit{
    //因为要接受推送的角色，所有这个界面不使用本地角色，而使用传入角色
    _JGJisMateBool = self.mateWorkitemsItems.role == 1?1:0;
#warning 改这里请慎重
    if (self.markBillType == MarkBillTypeEdit && !self.isChat ) {
        self.identityString = JGJRecordIDStr;
    }else if (self.markBillType != MarkBillTypeChat && !self.isChat) {
        self.identityString = self.mateWorkitemsItems.role == 2?@"工人":@"班组长/工头";
    }else if (self.markBillType == MarkBillTypeChat || self.isChat) {
        self.identityString = _JGJisMateBool?@"班组长/工头":@"工人";
    }
    self.accountTypeCode = self.mateWorkitemsItems.accounts_type.code;
    self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
    self.yzgGetBillModel.uid = self.mateWorkitemsItems.uid;
    self.yzgGetBillModel.name = self.mateWorkitemsItems.name;
    self.yzgGetBillModel.role = self.mateWorkitemsItems.role;
    //设置使用说明的状态
    self.needUseIntroductions = NO;
    if (self.yzgGetBillModel.accounts_type.code == 1) {//设置默认数据
        self.yzgGetBillModel.manhour = MarkBillDefaultManhour;
        self.yzgGetBillModel.overtime = MarkBillDefaultOverhour;
        //读取
        YZGGetBillModel *oldYzgGetBillModel=  [NSKeyedUnarchiver unarchiveObjectWithFile:JGJMarkDayBaseInfoFile];

        BOOL isSamePhone = [oldYzgGetBillModel.phone_num isEqualToString:[TYUserDefaults objectForKey:JLGPhone]];
        BOOL isChat = self.markBillType == MarkBillTypeChat;
        if (isChat && _JGJisMateBool && oldYzgGetBillModel && isSamePhone) {
            oldYzgGetBillModel.manhour = MarkBillDefaultManhour;
            oldYzgGetBillModel.overtime = MarkBillDefaultOverhour;
            
            self.yzgGetBillModel = oldYzgGetBillModel;
            if (oldYzgGetBillModel.pid) {
                [JLGHttpRequest_AFN PostWithApi:@"v2/Workday/isDeletedProject" parameters:@{@"pro_id":@(oldYzgGetBillModel.pid)} success:^(NSDictionary *responseObject) {
                    
                    if ([responseObject[@"is_deleted"] integerValue] == 1) {
                        self.yzgGetBillModel.proname = nil;
                        self.yzgGetBillModel.pid = 0;
                    }
                    
                    
                    [self.tableView reloadRowsAtIndexPaths:@[self.proNameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }failure:nil];
            }
        }
        
        if (![TYUserDefaults boolForKey:YZGGuideDayFirst]) {
            self.needUseIntroductions = YES;//需要显示使用说明
            //先保存状态，避免出现更新不及时的情况
            [TYUserDefaults setBool:YES forKey:YZGGuideDayFirst];
            [TYUserDefaults synchronize];
        }
    }else if(self.yzgGetBillModel.accounts_type.code == 2)//包工
    {
//        if (![TYUserDefaults boolForKey:YZGGuideContractFirst]) {
//            self.needUseIntroductions = YES;//需要显示使用说明
//            //先保存状态，避免出现更新不及时的情况
//            [TYUserDefaults setBool:YES forKey:YZGGuideContractFirst];
//            [TYUserDefaults synchronize];
//        }
    }else if(self.yzgGetBillModel.accounts_type.code == 3)//借支
    {
//        if (![TYUserDefaults boolForKey:YZGGuideBorrowFirst]) {
//            self.needUseIntroductions = YES;//需要显示使用说明
//            //先保存状态，避免出现更新不及时的情况
//            [TYUserDefaults setBool:YES forKey:YZGGuideBorrowFirst];
//            [TYUserDefaults synchronize];
//        }
    }
    //如果是发布记账的时候，才转换时间
    if ((self.markBillType != MarkBillTypeEdit) && !self.yzgGetBillModel.date && self.selectedDate) {
        self.yzgGetBillModel.date = [self getWeekDaysString:self.selectedDate];
    }
    if ((self.markBillType == MarkBillTypeChat || self.isChat ) && self.workProListModel) {
        [self.proNameArray removeAllObjects];

        if (!_JGJisMateBool) {//如果是成员，不需要显示
            self.workProListModel.pro_id = self.workProListModel.pro_id?:[NSString stringWithFormat:@"%@",@(self.mateWorkitemsItems.pid)];
            self.workProListModel.pro_name = self.workProListModel.pro_name?:self.mateWorkitemsItems.pro_name;
            
            self.yzgGetBillModel.pid = [self.workProListModel.pro_id integerValue];
            self.yzgGetBillModel.proname = self.workProListModel.pro_name;
        }
    }
    [self cellDataInit];
}

- (void)cellDataInit{

}

#pragma mark - 布局的配置
- (void)layoutInit{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = TYColorHex(0xf5f5f5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.markBillType == MarkBillTypeEdit) {//编辑记账的情况
        self.title = @"修改";

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.view);
//            make.bottom.equalTo(self.containSaveButtonView.mas_top);

            
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.containSaveButtonView.mas_top);
            make.top.mas_equalTo(-1);

        }];
//        [self.tableView setFrame:CGRectMake(0, -1, TYGetUIScreenWidth, TYGetUIScreenHeight - 123) ];
        if (self.mateWorkitemsItems.is_del == 0) {//不是移除的账单
            [self JLGHttpRequest];
        }else{//查询薪资模板，账单是移除状态的时候用
            self.yzgGetBillModel.pid = self.mateWorkitemsItems.pid;
            self.yzgGetBillModel.proname = self.mateWorkitemsItems.pro_name;
            [self JLGHttpRequest_QueryTpl];
        }
    }else if (self.markBillType == MarkBillTypeChat){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
        
        //聊天的情况下，是工人就直接加载班组长/工头信息
        if (self.mateWorkitemsItems.role == 1 && self.workProListModel) {
            self.yzgGetBillModel.name = self.workProListModel.creater_name;
            self.yzgGetBillModel.uid = [self.workProListModel.creater_uid integerValue];

            [JLGHttpRequest_AFN PostWithApi:@"jlworkday/fmlist" parameters:nil success:^(id responseObject) {
                NSArray <YZGAddForemanModel *>*dataArr = [YZGAddForemanModel mj_objectArrayWithKeyValuesArray:responseObject];
                
                __block YZGAddForemanModel *addForemanModel = [YZGAddForemanModel new];
                //判断是否有这个人
                __block BOOL haveSameUser = NO;
                [dataArr enumerateObjectsUsingBlock:^(YZGAddForemanModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.uid == self.yzgGetBillModel.uid) {
                        haveSameUser = YES;
                        addForemanModel = obj;
                        *stop = YES;
                    }
                }];
                
                //如果有相同的人
                if (!haveSameUser) {
                    addForemanModel.name = self.yzgGetBillModel.name;
                    addForemanModel.uid =  self.yzgGetBillModel.uid;

                    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addfm" parameters:@{@"name":addForemanModel.name,@"telph":self.workProListModel.creater_telp} success:nil];
                }
                
                self.addForemanModel = addForemanModel;
                [self ModifySalaryTemplateData];
            }];
        }
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
    }
}
#pragma mark - 获取正常账单
- (void)JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@""];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@(self.mateWorkitemsItems.id) forKey:@"id"];
    if (self.markBillType == MarkBillTypeChat || self.isChat) {
        NSInteger my_role_type = _JGJisMateBool?1:2;
        [parameters setObject:@(my_role_type) forKey:@"my_role_type"];
    }
    if (_sendMsgType) {
         NSInteger my_role_type = _JGJisMateBool?1:2;
        [parameters setObject:@(_mateWorkitemsItems.role)?:@(my_role_type) forKey:@"role"];
    }
    [JLGHttpRequest_AFN PostWithApi:@"jlworkstream/getonebilldetail" parameters:parameters success:^(id responseObject) {
        YZGGetBillModel *yzgGetBillModel = [[YZGGetBillModel alloc] init];
        [yzgGetBillModel mj_setKeyValues:responseObject];
        
        self.yzgGetBillModel = yzgGetBillModel;
        self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
        
        if (self.yzgGetBillModel.notes_img.count > 0 ) {
            self.imagesArray = [self.yzgGetBillModel.notes_img mutableCopy];
        }
        NSDictionary *proDic = @{@"id":@(yzgGetBillModel.pid),@"name":yzgGetBillModel.proname};
        [self.proNameArray addObject:proDic];
        
       //推送弹框
        if ([_yzgGetBillModel.modify_marking intValue] >0 && _sendMsgType){
            self.yzgMateShowpoor.mateWorkitemsItem = _mateWorkitemsItems;
            [self.yzgMateShowpoor showpoorView];
        }

#pragma mark - 2.3.0添加
        [self setOldBillModelState];
        [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

-(void)setOldBillModelState
{
    _oldBillyzgGetBillModel = [YZGGetBillModel new];
    _oldBillyzgGetBillModel.salary          = _yzgGetBillModel.salary;
    _oldBillyzgGetBillModel.set_tpl.o_h_tpl = _yzgGetBillModel.set_tpl.o_h_tpl;
    _oldBillyzgGetBillModel.set_tpl.w_h_tpl = _yzgGetBillModel.set_tpl.w_h_tpl;
    _oldBillyzgGetBillModel.set_tpl.s_tpl   = _yzgGetBillModel.set_tpl.s_tpl;
    _oldBillyzgGetBillModel.voice_length    = _yzgGetBillModel.voice_length;
    _oldBillyzgGetBillModel.manhour         = _yzgGetBillModel.manhour;
    _oldBillyzgGetBillModel.overtime        = _yzgGetBillModel.overtime;
    _oldBillyzgGetBillModel.notes_voice     = _yzgGetBillModel.notes_voice;
    _oldBillyzgGetBillModel.notes_img       = _yzgGetBillModel.notes_img;
    _oldBillyzgGetBillModel.notes_txt       = _yzgGetBillModel.notes_txt;
    _oldBillyzgGetBillModel.proname         = _yzgGetBillModel.proname;
    


}

#pragma mark - 查询薪资模板
- (void)JLGHttpRequest_QueryTpl{
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querytpl" parameters:@{@"uid":@(self.mateWorkitemsItems.uid)} success:^(id responseObject) {
        GetBillSet_Tpl *bill_Tpl = [[GetBillSet_Tpl alloc] init];
        [bill_Tpl mj_setKeyValues:responseObject];
        
        self.yzgGetBillModel.set_tpl = bill_Tpl;
        self.yzgGetBillModel.manhour = self.yzgGetBillModel.set_tpl.w_h_tpl;//默认的情况下，工作是长就是模板的时间
        self.yzgGetBillModel.overtime = 0;//移除账单，默认情况下是不加班
        self.yzgGetBillModel.accounts_type = self.mateWorkitemsItems.accounts_type;
        
        [self getSalary];
        
        [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 查询最新的项目名字
- (void)JLGHttpRequest_LastproWithUid:(NSInteger )uid{
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/lastpro" parameters:@{@"uid":@(uid),@"accounts_type":@(self.yzgGetBillModel.accounts_type.code)} success:^(id responseObject) {
        
        self.yzgGetBillModel.pid = [responseObject[@"pid"] integerValue];
        self.yzgGetBillModel.proname = responseObject[@"pro_name"];
        [self.tableView reloadData];
    }failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
}


#pragma mark - 时间转换
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy年MM月dd日"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    //如果是今天要显示
    if ([date isToday]) {
        dateString = [dateString stringByAppendingString:@"(今天)"];
    }
    
    return dateString;
}


#pragma mark - 使用说明
- (void)UseIntroductionsDisPlay:(CGFloat )yOffest{
    [self UseIntroductionsDisPlay:yOffest segMentView:nil];
}

- (void)UseIntroductionsDisPlay:(CGFloat )yOffest segMentView:(SMCustomSegment *)segmentView{
    if (self.disappear) {//如果退出了就不显示
        return;
    }
    
    if (segmentView) {
        YZGRecordWorkPointGuideModel *recordWorkPointGuideModel = self.recordWorkPointGuideView.RecordWorkPointGuideModel;
#ifdef JGTestFunction
        recordWorkPointGuideModel.guideIndex = 0;
#else
        recordWorkPointGuideModel.guideIndex = 0;
#endif
        recordWorkPointGuideModel.accountTypeCode = self.accountTypeCode;
        CGRect showFrame = segmentView.frame;
        showFrame.origin.y += 64;
        
        recordWorkPointGuideModel.showFrame = showFrame;
        

        if (self.recordWorkPointGuideView.workFramePathArr.count == 0) {
#ifdef JGTestFunction
            //添加"点工,包工，借支"
            __weak typeof(self) weakSelf = self;
            UIView *selecetedView = segmentView.selectButtonsArr[segmentView.selectIndex];
            [self.recordWorkPointGuideView.workCellArr addObject:[UIImage cutFromView:selecetedView]];
#else
            //添加"点工,包工，借支"
            __weak typeof(self) weakSelf = self;
            [segmentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    [weakSelf.recordWorkPointGuideView.workCellArr addObject:[UIImage cutFromView:obj]];
                }
            }];
#endif
            
            //添加cell
            [self.recordWorkPointGuideView.workIndexPathArr enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                CGRect showFrame = [tableViewCell convertRect:tableViewCell.bounds toView:self.view];
                showFrame.origin.y += yOffest?:64;
                [weakSelf.recordWorkPointGuideView.workFramePathArr addObject:[NSValue valueWithCGRect:showFrame]];
                
                [weakSelf.recordWorkPointGuideView.workCellArr addObject:[UIImage cutFromView:tableViewCell]];
            }];
        }
        
        [self.recordWorkPointGuideView showGuideViewSegment:recordWorkPointGuideModel];
    }else{
        YZGRecordWorkPointGuideModel *recordWorkPointGuideModel = self.recordWorkPointGuideView.RecordWorkPointGuideModel;
        recordWorkPointGuideModel.guideIndex = 0;
        recordWorkPointGuideModel.accountTypeCode = self.accountTypeCode;
        recordWorkPointGuideModel.indexPath = self.recordWorkPointGuideView.workIndexPathArr[0];
        
        if (self.recordWorkPointGuideView.workFramePathArr.count == 0) {
            __weak typeof(self) weakSelf = self;
            [self.recordWorkPointGuideView.workIndexPathArr enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                CGRect showFrame = [tableViewCell convertRect:tableViewCell.bounds toView:self.view];
                showFrame.origin.y += yOffest?:64;
                [weakSelf.recordWorkPointGuideView.workFramePathArr addObject:[NSValue valueWithCGRect:showFrame]];
                
                [weakSelf.recordWorkPointGuideView.workCellArr addObject:[UIImage cutFromView:tableViewCell]];
            }];
        }
        recordWorkPointGuideModel.showFrame = [self.recordWorkPointGuideView.workFramePathArr[0] CGRectValue];
        [self.recordWorkPointGuideView showRecordWorkPointGuideView:recordWorkPointGuideModel];
    }
}

#pragma mark - 跳转到备注界面
- (void)goToOtherInfoVc{
    if (self.markBillType == MarkBillTypeEdit) {//如果是编辑状态就不进入下一个界面
        return;
    }
    JGJOtherInfoViewController *otherInfoVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"otherInfo"];
    
    otherInfoVc.yzgGetBillModel = self.yzgGetBillModel;
    otherInfoVc.yzgGetBillModel.role = _JGJisMateBool == 1?1:2;
    otherInfoVc.imagesArray = self.imagesArray;
    otherInfoVc.deleteImgsArray = self.deleteImgsArray;
    otherInfoVc.parametersDic = self.parametersDic;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)]) {
        [self.delegate MateGetBillPush:self ByVc:otherInfoVc];
    }else{
        [self.navigationController pushViewController:otherInfoVc animated:YES];
    }
}

#pragma mark - 错误提示信息
- (BOOL )showErrorMessage{
    if (!self.yzgGetBillModel.name) {
        [TYShowMessage showPlaint:[NSString stringWithFormat:@"请选择%@",self.identityString]];
        return NO;
    }
    
    if (self.accountTypeCode == 1) {
        //如果没有时间
        BOOL isNoHour = self.yzgGetBillModel.set_tpl.w_h_tpl == 0 && self.yzgGetBillModel.set_tpl.o_h_tpl == 0;
        if (isNoHour) {
            [TYShowMessage showPlaint:@"请设置工资标准"];
            return NO;
        }
    }else if (self.accountTypeCode == 2) {
        if (!self.yzgGetBillModel.unitprice) {
            [TYShowMessage showPlaint:@"请设置单价"];
            return NO;
        }
        
        if (!self.yzgGetBillModel.quantities) {
            [TYShowMessage showPlaint:@"请设置数量"];
            return NO;
        }
    }else if (self.accountTypeCode == 3) {
        if (self.yzgGetBillModel.salary == 0) {
            [TYShowMessage showPlaint:@"请输入借支金额"];
            return NO;
        }
    }else if (self.accountTypeCode == 4) {
        if (self.yzgGetBillModel.salary == 0) {
            [TYShowMessage showPlaint:@"请输入结算金额"];
            return NO;
        }
    }
    
    return YES;
}

- (void)saveDataTOServerInEidt{
    YZGAudioAndPicTableViewCell *audioCell = (YZGAudioAndPicTableViewCell *)[self.tableView cellForRowAtIndexPath:self.noteIndexPath]?:self.audioCell;
    if (audioCell) {
        [audioCell configAudioData:self.yzgGetBillModel parametersDic:self.parametersDic deleteImgsArray:self.deleteImgsArray imagesArray:self.imagesArray];
    }
}

#pragma mark - 保存数据到服务器
- (void)saveDataToServer{
    if (![self showErrorMessage]) {
        return;
    }
    //此处判断是否编辑记账改变 2.3.0需求
    if (![self VerifyWhetherThereIsaChargeToAnAccountChanges] && _markBillType == MarkBillTypeEdit) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.markBillType == MarkBillTypeEdit) {
        [self saveDataTOServerInEidt];
    }
    
    if (self.mateWorkitemsItems.id != 0) {
        self.parametersDic[@"id"] = @(self.mateWorkitemsItems.id);
    }
    self.parametersDic[@"name"] = self.yzgGetBillModel.name;
    self.parametersDic[@"uid"] = @(self.yzgGetBillModel.uid);
    self.parametersDic[@"salary"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.salary];
    self.parametersDic[@"text"] = self.yzgGetBillModel.notes_txt?:@"";
    self.parametersDic[@"pro_name"] = self.yzgGetBillModel.proname?:@"";
    if (self.yzgGetBillModel.pid == 0) {
        self.parametersDic[@"pid"] = @"";
    }else{
        self.parametersDic[@"pid"] = @(self.yzgGetBillModel.pid);
    }
    //只获取日期
    self.parametersDic[@"date"] = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    
    if (self.accountTypeCode == 1) {//点工
        self.parametersDic[@"accounts_type"] = @1;
        self.parametersDic[@"work_time"] = @(self.yzgGetBillModel.manhour);
        self.parametersDic[@"over_time"] = @(self.yzgGetBillModel.overtime);
        self.parametersDic[@"salary_tpl"] = @(self.yzgGetBillModel.set_tpl.s_tpl);
        self.parametersDic[@"work_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.w_h_tpl);
        self.parametersDic[@"overtime_hour_tpl"] = @(self.yzgGetBillModel.set_tpl.o_h_tpl);
    }else if(self.accountTypeCode == 2){//包工
        self.parametersDic[@"accounts_type"] = @2;
        self.parametersDic[@"p_s_time"] = self.yzgGetBillModel.start_time?:@"0";
        self.parametersDic[@"p_e_time"] = self.yzgGetBillModel.end_time?:@"0";
        self.parametersDic[@"sub_pro_name"] = self.yzgGetBillModel.sub_proname?:@"";
        self.parametersDic[@"quantity"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.quantities];
        self.parametersDic[@"unit_price"] = [NSString stringWithFormat:@"%.2f",self.yzgGetBillModel.unitprice];
        self.parametersDic[@"units"] = self.yzgGetBillModel.units?:@"";

    }else if(self.accountTypeCode == 3){//借支
        self.parametersDic[@"accounts_type"] = @3;
    }else if(self.accountTypeCode == 4){//借支
        self.parametersDic[@"accounts_type"] = @4;

    }
    

    
    [self ModifyRelase:self.parametersDic dataArray:self.yzgGetBillModel.dataArr dataNameArray:self.yzgGetBillModel.dataNameArr];
}
#pragma mark - 提交数据到服务器，用于子类重写
- (void)ModifyRelase:(NSDictionary *)parametersDic dataArray:(NSArray *)dataArray dataNameArray:(NSArray *)dataNameArray{
    
    [self.tableView endEditing:YES];
    if (self.markBillType != MarkBillTypeEdit) {//发布记账
        NSMutableDictionary *parametersDicRelase = [parametersDic mutableCopy];
        [parametersDicRelase removeObjectForKey:@"id"];

        if (self.markBillType == MarkBillTypeChat || self.isChat) {
            [parametersDicRelase setValue:@(_JGJisMateBool?1:2) forKey:@"my_role_type"];
            [parametersDicRelase setValue:self.workProListModel.pro_id forKey:@"gpid"];
            [parametersDicRelase setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
        }

        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        
        __weak typeof(self) weakSelf = self;
        [JLGHttpRequest_AFN uploadImagesWithApi:@"jlworkday/relase" parameters:parametersDicRelase imagearray:self.imagesArray otherDataArray:[dataArray copy] dataNameArray:[dataNameArray copy] success:^(NSArray *responseObject) {
            [TYLoadingHub hideLoadingView];
            [TYShowMessage showSuccess:@"记账成功\n永不丢失，随时查看!"];
            
            NSDictionary *responseDic = [responseObject firstObject];
            if (responseDic[@"record_id"]) {
                self.record_id = responseDic[@"record_id"];
            }
            
            NSInteger accountsType = weakSelf.yzgGetBillModel.accounts_type.code;
            if (weakSelf.isNeedRecordAgain) {//保存再记
                NSString *date = weakSelf.yzgGetBillModel.date;
                
                UIViewController *uperVc = (UIViewController *)weakSelf.delegate;
                if ([uperVc isKindOfClass:NSClassFromString(@"YZGMateReleaseBillViewController")]
                    ) {
                    //移除监控
                    SEL removeObserver = NSSelectorFromString(@"removeObserver");
                    IMP imp = [uperVc methodForSelector:removeObserver];
                    void (*func)(id, SEL) = (void *)imp;
                    func(uperVc, removeObserver);
                }
                
                //聊天的时候，创建者保存再记不需要清项目
                NSInteger pid = 0;
                NSString *proname;
                if (weakSelf.markBillType == MarkBillTypeChat || weakSelf.isChat) {
                    pid = weakSelf.yzgGetBillModel.pid;
                    proname = weakSelf.yzgGetBillModel.proname;
                }
                
                //重置数据
                weakSelf.yzgGetBillModel = nil;
                weakSelf.yzgGetBillModel.date = date;
                weakSelf.yzgGetBillModel.accounts_type.code = accountsType;
                
                //聊天的时候，创建者保存再记不需要清项目
                if (weakSelf.markBillType == MarkBillTypeChat || weakSelf.isChat) {
                    weakSelf.yzgGetBillModel.pid = pid;
                    weakSelf.yzgGetBillModel.proname = proname;
                }
                
                if ([uperVc isKindOfClass:NSClassFromString(@"YZGMateReleaseBillViewController")]
                    ) {
                    //增加监控
                    SEL addObserver = NSSelectorFromString(@"addObserver");
                    IMP imp = [uperVc methodForSelector:addObserver];
                    void (*func)(id, SEL) = (void *)imp;
                    func(uperVc, addObserver);
                }
                
                if (accountsType == 1) {//点工
                    weakSelf.addForemanModel = nil;
                    [weakSelf.addForemandataArray removeAllObjects];
                    
                    weakSelf.yzgGetBillModel.manhour = MarkBillDefaultManhour;
                    weakSelf.yzgGetBillModel.overtime = MarkBillDefaultOverhour;
                }
                
                [weakSelf.imagesArray removeAllObjects];
                [weakSelf.tableView reloadData];
            }else{//直接发布
                if (accountsType == 1 && _JGJisMateBool) {
                    //去掉备注信息
                    self.yzgGetBillModel.notes_img = nil;
                    self.yzgGetBillModel.notes_txt = nil;
                    self.yzgGetBillModel.notes_voice = nil;
                    self.yzgGetBillModel.notes_voice_amr = nil;
                    
                    self.yzgGetBillModel.phone_num = [TYUserDefaults objectForKey:JLGPhone];
                    
                    //模型写入文件
                    [NSKeyedArchiver archiveRootObject:weakSelf.yzgGetBillModel toFile:JGJMarkDayBaseInfoFile];
                }

                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(MateGetBillPopView:getBillVc:)]) {
                    [weakSelf.delegate MateGetBillPopView:nil getBillVc:self];
                }
                
                UIViewController *superVc = weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count - 2];
                if ([superVc isKindOfClass:[YZGGetIndexRecordViewController class]]) {
                    YZGGetIndexRecordViewController *mateWorkitemsVc = (YZGGetIndexRecordViewController *)superVc;
                    [mateWorkitemsVc JLGHttpRequest];
                }
            }
            [TYNotificationCenter postNotificationName:JGJModifyBillSuccess object:nil];
        } failure:^(NSError *error) {
            [TYLoadingHub hideLoadingView];
        }];
    }else{//编辑记账
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        
        NSString *releaseApi = self.mateWorkitemsItems.is_del?@"jlworkday/relase":@"jlworkday/modifyrelase";
        __weak typeof(self) weakSelf = self;
        
        NSMutableDictionary *postParametersDic = parametersDic.mutableCopy;
        //聊天的时候
        if (!self.mateWorkitemsItems.is_del &&(self.markBillType == MarkBillTypeChat || self.isChat)) {
            [postParametersDic setValue:@(_JGJisMateBool?1:2) forKey:@"my_role_type"];
            [postParametersDic setValue:self.workProListModel.pro_id forKey:@"gpid"];
            [postParametersDic setValue:self.workProListModel.pro_name forKey:@"gpro_name"];
        }
        if (_sendMsgType) {
            NSInteger roleindex = _JGJisMateBool?1:2;
            [postParametersDic setValue:@(self.mateWorkitemsItems.role?:roleindex) forKey:@"role"];
        }
        [JLGHttpRequest_AFN uploadImagesWithApi:releaseApi parameters:postParametersDic.copy imagearray:self.imagesArray otherDataArray:[dataArray copy] dataNameArray:[dataNameArray copy] success:^(id responseObject) {
            [TYLoadingHub hideLoadingView];
            
            [TYShowMessage showSuccess:@"修改记账成功\n及时对账，避免纠纷!"];
            
            NSDictionary *responseDic = [responseObject firstObject];
            if (responseDic[@"record_id"]) {
                self.record_id = responseDic[@"record_id"];
            }

            UIViewController *superVc = weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count - 2];
            if ([superVc isKindOfClass:[YZGMateWorkitemsViewController class]]) {
                YZGMateWorkitemsViewController *mateWorkitemsVc = (YZGMateWorkitemsViewController *)superVc;
                [mateWorkitemsVc JLGHttpRequest];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [TYNotificationCenter postNotificationName:JGJModifyBillSuccess object:nil];
        } failure:^(NSError *error) {
            [TYLoadingHub hideLoadingView];
        }];
    }
}

#pragma mark - 弹出所在项目名称
- (void)showProjectPickerByIndexPath:(NSIndexPath *)indexPath{
    
   //聊天并且自己是创建者的时候，不能选择项目
    if ([self.workProListModel.myself_group boolValue] && (self.markBillType == MarkBillTypeChat || self.isChat)) {
           return;
    }
    
     __weak typeof(self) weakSelf = self;
    [self querypro:^{
        [weakSelf showJLGPickerView:indexPath];
    }];

//    if (self.proNameArray.count == 0 ) {
//        [TYLoadingHub showLoadingWithMessage:@""];
//        __weak typeof(self) weakSelf = self;
//        [self querypro:^{
//            [weakSelf showJLGPickerView:indexPath];
//        }];
//    }else{
//        //后面加的，毕竟已经做了记账很久了，逻辑已经忘记了，算是填坑吧
//        if (self.proNameArray.count == 1) {
//            NSDictionary *proDic = self.proNameArray[0];
//            if ([proDic[@"id"] integerValue] == 0) {
//                [TYLoadingHub showLoadingWithMessage:@""];
//                [self querypro:^{
//                    [weakSelf showJLGPickerView:indexPath];
//                }];
//            }else{
//                [self showJLGPickerView:indexPath];
//            }
//        }else{
//            [self showJLGPickerView:indexPath];
//        }
//    }
    
    
    
    
}

-(void)querypro:(JGJMarkBillQueryproBlock )queryproBlock{
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
        if (responseObject.count == 0) {
            [TYLoadingHub hideLoadingView];
//            [TYShowMessage showPlaint:@"暂无可用的项目"];
            
            //聊天的时候，也是编辑
            if (self.markBillType == MarkBillTypeEdit) {
                return ;
            }
            
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
            superViewIsGroup = weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)];
            onlyAddProVc.superViewIsGroup = superViewIsGroup;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)]) {
                [weakSelf.delegate MateGetBillPush:weakSelf ByVc:onlyAddProVc];
            }else{
                [weakSelf.navigationController pushViewController:onlyAddProVc animated:YES];
            }
        }else{
            
            [weakSelf.proNameArray removeAllObjects];
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *proDic = @{@"id":obj[@"pid"],@"name":obj[@"pro_name"]};
                [weakSelf.proNameArray addObject:proDic];

                //如果是选中的项目，更新项目名字
                if (weakSelf.yzgGetBillModel.pid == [obj[@"pid"] integerValue]) {
                    weakSelf.yzgGetBillModel.proname = obj[@"pro_name"];
                }
            }];

            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.proNameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            if (queryproBlock) {
                queryproBlock();
            }
        }
        
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark 如果删除的项目是选中的项目，清除状态
-(void)deleteSelectProByPid:(NSInteger )pid{
    __weak typeof(self) weakSelf = self;
    NSArray *tmpProNameArr = self.proNameArray.copy;
    [tmpProNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果是选中的项目，删除项目
        if (pid == [obj[@"id"] integerValue]) {
            weakSelf.yzgGetBillModel.pid = 0;
            weakSelf.yzgGetBillModel.proname = nil;

            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.proNameIndexPath] withRowAnimation:UITableViewRowAnimationNone];

            [weakSelf.proNameArray removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    
    
}

- (void)showJLGPickerView:(NSIndexPath *)indexPath{
    if (self.markBillType != MarkBillTypeEdit) { //1.4.5编辑状态隐藏编辑按钮和新增按钮
        [self.jlgPickerView.leftButton setTitle:@"新增" forState:UIControlStateNormal];
        [self.jlgPickerView.leftButton setImage:[UIImage imageNamed:@"RecordWorkpoints_BtnAdd"] forState:UIControlStateNormal];
        self.jlgPickerView.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        self.jlgPickerView.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 27, 0, 0);
        [self.jlgPickerView setAllSelectedComponents:nil];
        self.jlgPickerView.isShowEditButton = YES;//显示编辑按钮
    }
    [self.jlgPickerView showPickerByIndexPath:indexPath dataArray:self.proNameArray title:@"所在项目" isMulti:NO];
    self.jlgPickerView.editButton.hidden = (self.markBillType == MarkBillTypeEdit);
}

#pragma mark - 获取对应的cell,给子类重写
- (UITableViewCell *)getCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return cell;
}

- (void)dayWorkDidSelectIndexPath:(NSIndexPath *)indexPath{
}

- (void)contractWorkDidSelectIndexPath:(NSIndexPath *)indexPath{
}

- (void)borrowingWorkDidSelectIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark - 登录第一次以后显示的使用说明
- (void)firstShowUseIntroductions:(SMCustomSegment *)segmentView{
    [self.view layoutIfNeeded];//必须重新布局才能找到cell
    
    //是否显示使用说明
    if (self.needUseIntroductions) {
        self.needUseIntroductions = NO;
        [self UseIntroductionsDisPlay:(self.markBillType != MarkBillTypeEdit)?(64 + 85):0 segMentView:segmentView];
    }
}

#pragma mark - 键盘监控
- (void)addKeyBoardObserver{
    if (UseIQKeyBoardManager) {
        if (self.markBillType != MarkBillTypeEdit) {
            return;
        }
    }

    [TYNotificationCenter addObserver:self selector:@selector(MarkBillKeyboardDidShowFrame:) name:UIKeyboardWillShowNotification object:nil];
    [TYNotificationCenter addObserver:self selector:@selector(MarkBillKeyboardDidHiddenFrame:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyBoardObserver{
    if (UseIQKeyBoardManager) {
        if (self.markBillType != MarkBillTypeEdit) {
            return;
        }
    }
    
    [TYNotificationCenter removeObserver:self];
}

- (void)hiddenRecordWorkPointGuideView{
    [self.recordWorkPointGuideView hiddenRecordWorkPointGuideView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyBoardObserver];
    
    self.disappear = NO;
    //显示成红色
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, JGJMainColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getWhiteLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *whiteLeftBarButton = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = whiteLeftBarButton;
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:JGJMainColor tintColor:[UIColor whiteColor] titleColor:[UIColor whiteColor]];
    }
    if (!UseIQKeyBoardManager) {
        [IQKeyboardManager sharedManager].enable = NO;
    }else{
        [[IQKeyboardManager sharedManager]setKeyboardDistanceFromTextField:80];
    }

#pragma mark - 导航栏添加背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_account_edit_up"]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉那条线

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    _sendMsgType = NO;
    self.disappear = YES;
    //显示成白色
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, AppFontfafafaColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *leftBarButtonItem = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }

        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:AppFontfafafaColor tintColor:JGJMainRedColor titleColor:AppFont333333Color];
    }
    
    [self.view endEditing:YES];
    if (!UseIQKeyBoardManager) {
        [IQKeyboardManager sharedManager].enable = YES;
    }
    [self.navigationController.navigationBar setShadowImage:nil];//恢复那条线
}

- (void)dealloc{
    [self removeKeyBoardObserver];;
    self.returnKeyHandler = nil;
    //因为聊天需要缓存，不能清除
//    [NSString removeFileByPath:[AudioRecordingServices getCacheDirectory]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.proNameArray = nil;
    self.jlgPickerView = nil;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.yzgGetBillModel.accounts_type.code == -1) {
        return 1;
    }

    return self.cellDataArray.count;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.yzgGetBillModel.accounts_type.code == -1) {
        return 0;
    }
    
    NSArray *sectionNumArr = self.cellDataArray[section];

    return sectionNumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.yzgGetBillModel.accounts_type.code == -1) {
        return 0;
    }
    
    UITableViewCell *cell;;

    if ((self.markBillType == MarkBillTypeEdit) && indexPath.section == self.noteIndexPath.section &&indexPath.row == self.noteIndexPath.row) {//如果是编辑，并且是之前备份的indexPath,返回备注的cell
        YZGAudioAndPicTableViewCell *auidioPicCell = [YZGAudioAndPicTableViewCell cellWithTableView:tableView];
//        auidioPicCell = [auidioPicCell configureAudioAndPicCellByModel:self.yzgGetBillModel showVc:self imagesArray:self.imagesArray];
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        
        dataDic[@"notes_txt"] = self.yzgGetBillModel.notes_txt;
        dataDic[@"voice_length"] = [NSString stringWithFormat:@"%@",@(self.yzgGetBillModel.voice_length)];
        dataDic[@"notes_voice"] = self.yzgGetBillModel.notes_voice;
        dataDic[@"amrFilePath"] = self.yzgGetBillModel.notes_voice_amr;
        
        [auidioPicCell configureAudioAndPicCell:dataDic showVc:self imagesArray:self.imagesArray.mutableCopy];
        auidioPicCell.tableView = tableView;
        self.audioCell = auidioPicCell;
        return auidioPicCell;
    }
    cell = [self getCell:cell tableView:tableView indexPath:indexPath];
    
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.yzgGetBillModel.accounts_type.code == -1) {
        return 0;
    }
    
    //编辑的时候，不需要显示第一个header
    //发布的时候，不需要显示第一个和第二个header
    if (section == 0) {
        return 0.01;
    }
    
    
    CGFloat hegitHeader = 15;

    return hegitHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = (section == 1) ? TYColorHex(0Xe6e6e6) : AppFontf1f1f1Color;
    return headerView;

}
#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.markBillType == MarkBillTypeEdit) && (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0))) {//金钱和工人班组长/工头不能修改
        return;
    }

    [self.view endEditing:YES];
    
    BOOL canSelected = !((self.markBillType == MarkBillTypeEdit) ||(self.markBillType == MarkBillTypeChat && self.mateWorkitemsItems.role == 1));
    if (canSelected && indexPath.section == 1 && indexPath.row == 0) {//发布记账
        //进入选择人
        [self goToAddForemanAdnMateVc];
        return;
    }
    
    if (self.accountTypeCode == 1) {//点工
        [self dayWorkDidSelectIndexPath:indexPath];
#pragma mark-因为担心去改了原先的修改薪资模板就把上班时间等价于薪资模板 所以加一个对比基础值用于计算薪资
        if (indexPath.section == 1 &&indexPath.row == 1) {
            _workTime = self.yzgGetBillModel.manhour;
            _overtime = self.yzgGetBillModel.overtime;
        }
        
//        ====
    }else if(self.accountTypeCode == 2){//包工
        [self contractWorkDidSelectIndexPath:indexPath];
    }else if(self.accountTypeCode == 3 ||self.accountTypeCode == 4){//借支和工资结算
        [self borrowingWorkDidSelectIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.yzgGetBillModel) {
        return 0;
    }

    if (indexPath.section == 0) {
        //如果是发布的时候就不用显示，如果是编辑才显示
        return indexPath.row == 0?((self.markBillType == MarkBillTypeEdit)?kMarkBillMoneyCellHeight:0.001):kMarkBillNormalCellHeight;
    }

    if ((self.markBillType == MarkBillTypeEdit) && indexPath.section == self.noteIndexPath.section &&indexPath.row == self.noteIndexPath.row) {
        YZGAudioAndPicTableViewCell *auidioPicCell = [YZGAudioAndPicTableViewCell cellWithTableView:tableView];
        CGFloat newHeight = [auidioPicCell getiAudioHeight:self.yzgGetBillModel textViewHeight:self.cellTextViewHeight];
        return newHeight;
    }

    return kMarkBillNormalCellHeight;
}

#pragma mark - cell的配置
- (YZGGetBillMoneyTableViewCell *)configureMoneyCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.markBillType == MarkBillTypeEdit) {
        //显示头部
        cell = [YZGGetBillMoneyTableViewCell cellWithTableView:self.tableView];
        
        YZGGetBillMoneyTableViewCell *moneyCell= (YZGGetBillMoneyTableViewCell *)cell;
        if (!self.yzgGetBillModel.date && self.selectedDate) {
            self.yzgGetBillModel.date = [moneyCell getWeekDaysString:self.selectedDate];
        }
        moneyCell.delegate = self;
        moneyCell.notGetBillDidLoad = (self.markBillType != MarkBillTypeEdit);
        moneyCell.yzgGetBillModel = self.yzgGetBillModel;
        return moneyCell;
    }else{
        cell = [UITableViewCell getNilViewCell:_tableView indexPath:indexPath];
        return (YZGGetBillMoneyTableViewCell *)cell;
    }
}

- (YZGRecordWorkNextVcTableViewCell *)configureNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell = [YZGRecordWorkNextVcTableViewCell cellWithTableView:self.tableView];
    YZGRecordWorkNextVcTableViewCell *nextVcCell= (YZGRecordWorkNextVcTableViewCell *)cell;
    
    if (self.accountTypeCode == 1) {//点工
        nextVcCell = [self configDayNextVcCell:cell atIndexPath:indexPath];
    }else if(self.accountTypeCode == 2){//包工
        nextVcCell = [self configContractNextVcCell:cell atIndexPath:indexPath];
    }else{//点工
        nextVcCell = [self configBorrowingNextVcCell:cell atIndexPath:indexPath];
    }
    
    NSArray *sectionArr = self.cellDataArray[indexPath.section];
    nextVcCell.isLastedCell = (indexPath.row + 1) == sectionArr.count;
    return nextVcCell;
}

- (YZGRecordWorkNextVcTableViewCell *)configDayNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    return (YZGRecordWorkNextVcTableViewCell *)cell;
}

- (YZGRecordWorkNextVcTableViewCell *)configContractNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    return (YZGRecordWorkNextVcTableViewCell *)cell;
}

- (YZGRecordWorkNextVcTableViewCell *)configBorrowingNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    return (YZGRecordWorkNextVcTableViewCell *)cell;
}

#pragma mark - GetBillMoneyCell的delegate
- (void)GetBillMoneyEndEditing:(YZGGetBillMoneyTableViewCell *)cell detailStr:(NSString *)detailStr{
    self.yzgGetBillModel.salary = [detailStr floatValue];
}

- (void)GetBillMoneyChangeCharacters:(YZGGetBillMoneyTableViewCell *)cell detailStr:(NSString *)detailStr{
    self.yzgGetBillModel.salary = [detailStr floatValue];
}

#pragma mark 选择时间
- (void)GetBillSelectedDate:(YZGGetBillMoneyTableViewCell *)cell{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self showDatePickerByIndexPath:indexPath];
}

#pragma mark 选择时间控件弹出
- (void)showDatePickerByIndexPath:(NSIndexPath *)indexPath{
    NSString *dateFormat = [NSString getNumOlnyByString:self.yzgGetBillModel.date];
    NSDate *date = [NSDate dateFromString:dateFormat withDateFormat:@"yyyyMMdd"];
    self.jlgDatePickerView.datePicker.date = date;
    self.jlgDatePickerView.showMoreButton = @"show";
    //设置最大和最小时间
    [self.jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];

    [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
}
- (void)MarkBillKeyboardDidShowFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yEndOffset = TYGetUIScreenHeight - endKeyboardRect.origin.y;
    
    if (yEndOffset == 0 || [self.oldYOffsetDic[@"isShow"] boolValue]) {
        return;
    }

    self.oldYOffsetDic[@"oldYOffset"] = @(yEndOffset);
    self.oldYOffsetDic[@"accountTypeCode"] = @(self.accountTypeCode);
    self.oldYOffsetDic[@"isShow"] = @YES;

    [UIView animateWithDuration:duration animations:^{
        //显示
        
        if (self.markBillType == MarkBillTypeEdit) {
            [self.containSaveButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-yEndOffset);
            }];
            [self.containSaveButtonView layoutIfNeeded];
            if (!UseIQKeyBoardManager) {
                [self.tableView layoutIfNeeded];
            }
        }else{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-yEndOffset);
            }];
            [self.tableView layoutIfNeeded];
        }
    }completion:^(BOOL finished) {
    }];
}


- (void)MarkBillKeyboardDidHiddenFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        //显示
        if (self.markBillType == MarkBillTypeEdit) {
            [self.containSaveButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
            }];
            [self.containSaveButtonView layoutIfNeeded];
            if (!UseIQKeyBoardManager) {
                [self.tableView layoutIfNeeded];
            }
        }else{
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(0);
            }];
            [self.tableView layoutIfNeeded];
        }
    }completion:^(BOOL finished) {
        self.oldYOffsetDic[@"isShow"] = @NO;
        self.oldYOffsetDic[@"oldYOffset"] = @(0);
    }];
}

#pragma mark - 返回日薪
- (CGFloat)getSalary{
    if (self.yzgGetBillModel.accounts_type.code == 1) {//点工
        self.yzgGetBillModel.salary = (CGFloat )self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.manhour/self.yzgGetBillModel.set_tpl.w_h_tpl + (CGFloat )self.yzgGetBillModel.set_tpl.s_tpl*self.yzgGetBillModel.overtime/self.yzgGetBillModel.set_tpl.o_h_tpl;
        if (isnan(self.yzgGetBillModel.salary)) {
            self.yzgGetBillModel.salary = 0.f;
        }
    }else if(self.yzgGetBillModel.accounts_type.code == 2){//包工
        self.yzgGetBillModel.salary = self.yzgGetBillModel.unitprice * self.yzgGetBillModel.quantities;
    }
#pragma mark - 添加 重新计算薪资 不要以薪资模板来计算工资  这样逻辑是错的
    if ((_workTime || _overtime)&&self.yzgGetBillModel.accounts_type.code == 1) {
        self.yzgGetBillModel.salary = (CGFloat )self.yzgGetBillModel.set_tpl.s_tpl*_workTime/self.yzgGetBillModel.set_tpl.w_h_tpl + (CGFloat )self.yzgGetBillModel.set_tpl.s_tpl*_overtime/self.yzgGetBillModel.set_tpl.o_h_tpl;;
        self.yzgGetBillModel.manhour = _workTime;
        self.yzgGetBillModel.overtime = _overtime;
    }
    return self.yzgGetBillModel.salary;
}
#pragma mark - 修改了金额的设置
- (void)ModifySalaryTemplateData{
    if (self.accountTypeCode != 3) {
    [self getSalary];
    }
    [self reloadSalary];

    if (self.markBillType != MarkBillTypeChat) {
        [self JLGHttpRequest_LastproWithUid:self.addForemanModel.uid];
    }else{
        [self.tableView reloadData];
    }
}
#pragma mark - 增加一个薪资尚上下班时长重新计算
-(void)reloadSalary
{
    if (_workTime > 0) {
        self.yzgGetBillModel.manhour = _workTime;
    }
    if (_overtime >0) {
        self.yzgGetBillModel.overtime = _overtime;
    }

    _workTime = 0.00;
    _overtime = 0.00;
}

#pragma mark - 增加了项目
- (void)addProNameByName:(NSDictionary *)proNameDic{
    NSIndexPath *indexPath = [self getProNameIndexPath];
    
    YZGRecordWorkNextVcTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setDetail:proNameDic[@"pro_name"]];
    self.yzgGetBillModel.proname = proNameDic[@"pro_name"];
    self.yzgGetBillModel.pid = [proNameDic[@"pid"] integerValue];
    
    NSDictionary *proDic = @{@"id":proNameDic[@"pid"],@"name":proNameDic[@"pro_name"]};
    
    if ([proNameDic[@"exist"] integerValue]) {//如果重复
        __block NSUInteger exchangeIdx = 0;
        [self.proNameArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"id"] integerValue] == [proNameDic[@"pid"] integerValue]) {
                exchangeIdx = idx;
                *stop = YES;
            }
        }];
        [self.proNameArray exchangeObjectAtIndex:0 withObjectAtIndex:exchangeIdx];
    }else{
        [self.proNameArray insertObject:proDic atIndex:0];
    }
}

#pragma mark - 获取项目名的indexPath,用于子类重写
- (NSIndexPath *)getProNameIndexPath{
    return self.proNameIndexPath;
}

#pragma mark - 是否需要进入新增项目
- (BOOL)isAddNewProName:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - 跳转到增加人的界面
- (void)goToAddForemanAdnMateVc{
    YZGAddForemanAndMateViewController *addForemanAndMateVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"addForemanAndMate"];
    
    addForemanAndMateVc.addForemanModel = self.addForemanModel;
    addForemanAndMateVc.dataArray = self.addForemandataArray;
    addForemanAndMateVc.workProListModel = self.workProListModel;
    if (self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)]) {
        [self.delegate MateGetBillPush:self ByVc:addForemanAndMateVc];
    }
}

#pragma mark - pickerView选中以后
- (void)JLGPickerViewSelect:(NSArray *)finishArray{
    __block NSIndexPath *indexPath;
    [finishArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            indexPath = obj;
        }
    }];
    
    if (finishArray.count == 3) {//左边的按键,是否进入新增项目
        if ([self isAddNewProName:indexPath]) {
            YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
            
            BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
            superViewIsGroup = self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)];
            onlyAddProVc.superViewIsGroup = superViewIsGroup;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)]) {
                [self.delegate MateGetBillPush:self ByVc:onlyAddProVc];
            }else{
                [self.navigationController pushViewController:onlyAddProVc animated:YES];
            }
        }
        return;
    }
    
    BOOL isSame = YES;
    NSString *dataName;
    NSString *dataCode;
    id arrFirstObject = [finishArray firstObject];
    if ([arrFirstObject isKindOfClass:[NSDictionary class]]) {
        dataName = [finishArray firstObject][@"name"];
        dataCode = [finishArray firstObject][@"id"];
    }else{
        return;//异常情况
    }

    self.yzgGetBillModel.proname = dataName;
    self.yzgGetBillModel.pid = [dataCode integerValue];

    if (isSame == NO) {//计算工资
        [self getSalary];
        [self.tableView reloadData];
    }else if(indexPath){//刷新对应的cell
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)JGJPickViewEditButtonPressed:(NSArray *)dataArray {
    
    JGJBillEditProNameViewController *editProNameVC = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJBillEditProNameViewController"];
    
    editProNameVC.dataArray = dataArray;
    if (self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)]) {
        
        [self.delegate MateGetBillPush:self ByVc:editProNameVC];
    }else{
        
        [self.navigationController pushViewController:editProNameVC animated:YES];
    }
    editProNameVC.modifyThePorjectNameSuccess = ^(NSIndexPath *indexPath, NSString *changedName) {
        
    };
}

- (BOOL )setHourWith:(NSIndexPath *)indexPath withHour:(NSInteger )hourInt{
    BOOL isSame = YES;
    return isSame;
}

#pragma mark - 选择完时间
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath{
    if (self.markBillType != MarkBillTypeEdit) {//如果是发布记账
        self.yzgGetBillModel.date = [self getWeekDaysString:date];
    }
    
    if ((self.markBillType == MarkBillTypeEdit) && indexPath.section == 0 && indexPath.row == 0) {
        YZGGetBillMoneyTableViewCell *getBillMoenyCell = [self.tableView cellForRowAtIndexPath:indexPath];
        self.yzgGetBillModel.date = [getBillMoenyCell getWeekDaysString:date];
    }
    
    
    if ((self.markBillType == MarkBillTypeEdit) && self.accountTypeCode == 2 && indexPath.section == 3) {//如果是修改记账，并且是包工
        if (indexPath.row == self.startTimeIndexPath.row && indexPath.section == self.startTimeIndexPath.section) {//开工时间
            self.yzgGetBillModel.start_time = [NSDate stringFromDate:date format:@"yyyyMMdd"];
        }else if(indexPath.row == self.endTimeIndexPath.row && indexPath.section == self.endTimeIndexPath.section){//完工时间
            if ([date compare:self.yzgGetBillModel.startDate] == NSOrderedAscending) {
                [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
                return;
            }
            self.yzgGetBillModel.end_time = [NSDate stringFromDate:date format:@"yyyyMMdd"];
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 刷新备份的cell数据
- (void )RefreshOtherInfo{
    [self.tableView reloadRowsAtIndexPaths:@[self.noteIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - AudioAndPicCell的delegate
#pragma mark 删除图片
- (void)AudioAndPicCellDelete:(YZGAudioAndPicTableViewCell *)cell Index:(NSInteger )index{
    if ([self.imagesArray[index] isKindOfClass:[NSString class]]) {//记录删除的图片地址
        [self.deleteImgsArray addObject:self.imagesArray[index]];
    }
    //更新数据源
    [self removeImageAtIndex:index];
}

#pragma mark 编辑结束时也要获取备注信息
- (void)AudioAndPicCellTextFiledEndEditing:(YZGAudioAndPicTableViewCell *)cell textStr:(NSString *)textStr{
    self.yzgGetBillModel.notes_txt = textStr;
}

- (void)AudioAndPicCellTextFiledBeginEditing:(YZGAudioAndPicTableViewCell *)cell textView:(UITextView *)textView{
    if(!UseIQKeyBoardManager){
        //懒得计算了，直接写死，快骂我
        //任性
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.accountTypeCode == 1) {//点工
                self.tableView.contentOffset = CGPointMake(0, 375);
            }else if(self.accountTypeCode == 2){//包工
                self.tableView.contentOffset = CGPointMake(0, 475);
            }else if(self.accountTypeCode == 3){//借支
                self.tableView.contentOffset = CGPointMake(0, 260);
            }
            else if(self.accountTypeCode == 4){//借支
                self.tableView.contentOffset = CGPointMake(0, 260);
            }
        });
    }
}

- (void)AudioAndPicCellTextViewDidChange:(UITextView *)textView textViewHeight:(CGFloat )textViewHeight{
    self.yzgGetBillModel.notes_txt = textView.text;
    self.cellTextViewHeight = textViewHeight;
}

#pragma mark 添加图片
- (void)AudioAndPicAddPicBtnClick:(YZGAudioAndPicTableViewCell *)cell{
    [self.view endEditing:YES];
    [self.sheet showInView:self.view];
}

#pragma mark 成功添加录音
- (void)AudioAndPicAddAudio:(YZGAudioAndPicTableViewCell *)cell audioInfo:(NSDictionary *)audioInfo{
    if (audioInfo.allKeys.count == 0) {
        return ;
    }
    
    NSInteger fileTime = [audioInfo[@"fileTime"] integerValue];
    if (fileTime == 0) {
        self.yzgGetBillModel.notes_voice = nil;
        self.yzgGetBillModel.notes_voice_amr = nil;
        self.yzgGetBillModel.voice_length = 0;
    }else{
        self.yzgGetBillModel.notes_voice = audioInfo[@"filePath"];
        self.yzgGetBillModel.notes_voice_amr = audioInfo[@"amrFilePath"];
        self.yzgGetBillModel.voice_length = fileTime;
    }
}

#pragma mark - 增加完图片
- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr{
    [self.tableView reloadRowsAtIndexPaths:@[self.noteIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= kPicMaxNum) {
        [TYShowMessage showPlaint:[NSString stringWithFormat:@"最多可以上传%@张图片",@(kPicMaxNum)]];
        return ;
    }
    
    self.imageSelectedIndex = indexPath.row;
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}
#pragma mark - setter
- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel{
    _addForemanModel = addForemanModel;
    self.yzgGetBillModel.set_tpl = self.addForemanModel.tpl;
    self.yzgGetBillModel.name = self.addForemanModel.name;
    self.yzgGetBillModel.uid = self.addForemanModel.uid;
    self.yzgGetBillModel.manhour = self.addForemanModel.tpl.w_h_tpl;
    [self.tableView reloadData];
}

#pragma mark - IBAction
- (void )UseIntroductionsBtnClick:(UIBarButtonItem *)sender {
    [self UseIntroductionsDisPlay:0];
}

#pragma mark - 提交数据给服务器
- (void )saveBtnClick:(id)sender {
    [self saveDataToServer];
}

#pragma mark - 删除数据
- (void)delBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/delinfo" parameters:@{@"id":@(self.mateWorkitemsItems.id)} success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        
        NSString *sourceType = @"0";
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *sources = (NSArray *)responseObject;
            NSDictionary *sourceDic = sources.firstObject;
            if ([sourceDic isKindOfClass:[NSDictionary class]]) {
                sourceType = sourceDic[@"source"];
            }
        }
        
        NSInteger source = [sourceType integerValue];
        
        if (source == 1) {
            
            [TYShowMessage showSuccess:@"记账删除成功\n和他工账有差异,请及时核对"];
        }else {
            
            [TYShowMessage showSuccess:@"删除成功"];
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)cellDataArray
{
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

- (JLGPickerView *)jlgPickerView
{
    if (!_jlgPickerView) {
        _jlgPickerView = [[JLGPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgPickerView.delegate = self;
    }
    return _jlgPickerView;
}

- (NSMutableArray *)proNameArray
{
    if (!_proNameArray) {
        _proNameArray = [[NSMutableArray alloc] init];
    }
    return _proNameArray;
}

- (NSMutableArray *)deleteImgsArray
{
    if (!_deleteImgsArray) {
        _deleteImgsArray = [[NSMutableArray alloc] init];
    }
    return _deleteImgsArray;
}

- (YZGGetBillModel *)yzgGetBillModel
{
    if (!_yzgGetBillModel) {
        _yzgGetBillModel = [[YZGGetBillModel alloc] init];
    }
    return _yzgGetBillModel;
}

- (YZGRecordWorkPointGuideView *)recordWorkPointGuideView
{
    if (!_recordWorkPointGuideView) {
        _recordWorkPointGuideView = [[YZGRecordWorkPointGuideView alloc] initWithFrame:TYGetUIScreenRect];
        _recordWorkPointGuideView.delegate = self;
        
//当前是创建者进入、是班组长/工头身份，否者为工人
        _recordWorkPointGuideView.isMateBool = _JGJisMateBool;
        if (self.workProListModel) {
             _recordWorkPointGuideView.workProListModel = self.workProListModel;   
        }
    }
    return _recordWorkPointGuideView;
}

- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}

- (NSMutableDictionary *)parametersDic
{
    if (!_parametersDic) {
        _parametersDic = [[NSMutableDictionary alloc] init];
    }
    return _parametersDic;
}

- (NSIndexPath *)proNameIndexPath
{
    if (!_proNameIndexPath) {
        _proNameIndexPath = [[NSIndexPath alloc] init];
    }
    return _proNameIndexPath;
}

- (NSIndexPath *)noteIndexPath
{
    if (!_noteIndexPath) {
        _noteIndexPath = [[NSIndexPath alloc] init];
    }
    return _noteIndexPath;
}

- (NSIndexPath *)startTimeIndexPath
{
    if (!_startTimeIndexPath) {
        _startTimeIndexPath = [[NSIndexPath alloc] init];
    }
    return _startTimeIndexPath;
}

- (NSIndexPath *)endTimeIndexPath
{
    if (!_endTimeIndexPath) {
        _endTimeIndexPath = [[NSIndexPath alloc] init];
    }
    return _endTimeIndexPath;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        //添加保存按钮
        _saveButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_saveButton];
        _saveButton.backgroundColor = JGJMainColor;
        _saveButton.titleLabel.textColor = [UIColor whiteColor];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_saveButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_mateWorkitemsItems) {
            if (_mateWorkitemsItems.accounts_type.code >= 3) {
                _saveButton.backgroundColor = AppFont83C76EColor;
                [_saveButton.layer setLayerBorderWithColor:AppFont83C76EColor width:0.5 radius:5];
 
            }
        }
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.delButton.mas_right).with.offset(10);
            make.right.mas_equalTo(self.containSaveButtonView.mas_right).with.offset(-10);
            make.bottom.width.height.mas_equalTo(self.delButton);
        }];
    }
    return _saveButton;
}

- (UIButton *)delButton {

    if (!_delButton) {
        _delButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_delButton];
        [self.containSaveButtonView addSubview:_delButton];
        _delButton.backgroundColor = [UIColor whiteColor];
        [_delButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        [_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [_delButton.layer setLayerBorderWithColor:AppFont666666Color width:0.5 radius:5];
        [_delButton addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_delButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@45);
            make.left.equalTo(self.containSaveButtonView).offset(10);
            make.centerY.equalTo(self.containSaveButtonView);
        }];
    }
    return _delButton;
}

- (NSMutableDictionary *)oldYOffsetDic
{
    if (!_oldYOffsetDic) {
        _oldYOffsetDic = [[NSMutableDictionary alloc] init];
    }
    return _oldYOffsetDic;
}
        
- (UIView *)containSaveButtonView {
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc] init];
        _containSaveButtonView.backgroundColor = AppFontfafafaColor;
        [self.view addSubview:_containSaveButtonView];
        [_containSaveButtonView addSubview:self.saveButton];
        [_containSaveButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@63);
            make.left.right.bottom.equalTo(self.view);
        }];
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewTop];
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
        UIView *lineViewBottom = [[UIView alloc] init];
        lineViewBottom.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewBottom];
        [lineViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
    }
    return _containSaveButtonView;
}

- (void)scrollViewDidScroll{
    
}

#pragma mark - 设置姓名的颜色
- (UIColor *)setNameColorBy:(NSString *)detailStr defaultStr:(NSString *)defaultStr{
    UIColor *detailColor = [UIColor new];
    if (self.markBillType != MarkBillTypeChat) {
        detailColor = self.markBillType == MarkBillTypeEdit?AppFontccccccColor:((defaultStr.length && [detailStr isEqualToString:defaultStr]) ? AppFontccccccColor : AppFont333333Color);
    }else{//聊天
        detailColor = ![self.workProListModel.myself_group boolValue]?AppFontccccccColor:((defaultStr.length && [defaultStr isEqualToString:defaultStr]) ? AppFont333333Color :AppFontccccccColor );
    }
    
    return detailColor;
}
-(void)JLGDataPickerClickMoredayButton
{
//  [self.navigationController pushViewController:[[JGJMoreDayViewController alloc]init] animated:YES];

}
-(void)tapBillMoneyLable
{
    if (_yzgGetBillModel.modify_marking) {
    self.yzgMateShowpoor.mateWorkitemsItem = _mateWorkitemsItems;
    [self.yzgMateShowpoor showpoorView];
    }
}
//-(YZGGetBillModel *)oldBillyzgGetBillModel
//{
//    if (!_oldBillyzgGetBillModel) {
//        _oldBillyzgGetBillModel = [YZGGetBillModel new];
//    }
//    return _oldBillyzgGetBillModel;
//
//}
-(BOOL)VerifyWhetherThereIsaChargeToAnAccountChanges
{
    if (_oldBillyzgGetBillModel.salary == _yzgGetBillModel.salary && _oldBillyzgGetBillModel.set_tpl.o_h_tpl == _yzgGetBillModel.set_tpl.o_h_tpl &&_oldBillyzgGetBillModel.set_tpl.w_h_tpl == _yzgGetBillModel.set_tpl.w_h_tpl && _oldBillyzgGetBillModel.set_tpl.s_tpl == _yzgGetBillModel.set_tpl.s_tpl &&_oldBillyzgGetBillModel.voice_length == _yzgGetBillModel.voice_length && _oldBillyzgGetBillModel.manhour == _yzgGetBillModel.manhour && _oldBillyzgGetBillModel.overtime == _yzgGetBillModel.overtime&& [_oldBillyzgGetBillModel.proname?:@"" isEqualToString:_yzgGetBillModel.proname?:@""]&& [_oldBillyzgGetBillModel.notes_txt?:@"" isEqualToString:_yzgGetBillModel.notes_txt?:@"'"] &&
        !self.imagesArray.count&&_oldBillyzgGetBillModel.notes_img == _yzgGetBillModel.notes_img&&!self.deleteImgsArray.count) {
        return NO;
    }
    return YES;
}
@end
