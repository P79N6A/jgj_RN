//
//  JGJDetailViewController.m
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJDetailViewController.h"
#import "JGJHeadCollectionViewCell.h"
#import "JGJDescriptionCollectionViewCell.h"
#import "JGJImageCollectionViewCell.h"
#import "JGJNewsCollectionViewCell.h"
#import "JGJHadReciveCollectionViewCell.h"
#import "JGJNewDetailCollectionViewCell.h"
#import "JGJGetViewFrame.h"
#import "IQKeyboardManager.h"
#import "JGJAnimationView.h"
#import "JGJRightFromCollectionViewCell.h"
#import "JGJPerInfoVc.h"
#import "JGJReciveHeadCollectionViewCell.h"
#import "JGJDepartLableCollectionViewCell.h"
#import "JGJSecondCollectionViewCell.h"
#import "JGJThreeCollectionViewCell.h"
#import "HJPhotoBrowser.h"
#import "HJPhotoItem.h"
#import "JGJHoldCollectionViewCell.h"
#import "NSString+Extend.h"
#import "JGJCustomProInfoAlertVIew.h"
#import "UIImageView+WebCache.h"
#import "FDAlertView.h"
#import "PopoverView.h"
#import "JGJPlaceEditeView.h"
#import "CFRefreshStatusView.h"
#import "JGJBuilderDiaryViewController.h"
#import "JGJChatListBaseVc.h"
#import "JGJconstrunCollectionViewCell.h"
#import "JGJConstructDetailCollectionViewCell.h"
#import "JGJFromProCollectionViewCell.h"
#import "JGJTabBarViewController.h"
#import "JGJCheckPhotoTool.h"
#import "JGJMyWebviewViewController.h"
#pragma mark - 修改键盘
#import "JGJChatInputView.h"
#import "JGJSendMessageView.h"
#import "JGJMyWebviewViewController.h"
#import "JGJDetailStatusNumerCollectionViewCell.h"

// 3.1.0新增 发送日志位置信息
#import "JGJTheCurrentAddressOfLogDetailInfoTCell.h"
#import "JGJDetailUnReadInfoVc.h"

#import "JGJImage.h"

#import "JGJCusActiveSheetView.h"

#import "JGJSwitchMyGroupsTool.h"

#import "JGJTaskDetailCell.h"

static NSString *headIdentifer = @"headCellIdentifer";
static NSString *DesCriptionid = @"desCellIdentifer";
static NSString *Imagecellid   = @"imageCellIdentifer";
static NSString *Newscellid    = @"newsCellIdentifer";
static NSString *hadreciveLableid = @"HadreciveCellIdentifer";
static NSString *newDetail     = @"NewDetailCellIdentifer";
static NSString *FromCellId     = @"FromIdCellIdentifer";
static NSString *reciveHead     = @"reciveCellIdentifer";
static NSString *departcellid     = @"departCellIdentifer";
static NSString *secondcellId     = @"secondCellIdentifer";
static NSString *ThreeCellid     = @"ThreeCellIdentifer";
static NSString *HoldCellid     = @"HoldCellIdentifer";
static NSString *strunctdetailCellid     = @"struncdetailindentifer";
static NSString *strunctCellid     = @"struncindentifer";
static NSString *fromproCellID     = @"fromProindentifer";
static NSString *singerTextID     = @"singerTextID";
static NSString *singerNumID     = @"singerNumID";
static NSString *moreLineTextID     = @"moreLineTextID";
static NSString *numId    = @"numLineTextID";
static NSString *systemNoticeCellId     = @"systemNoticeCellId";

static NSString *JGJTaskDetailCellID     = @"JGJTaskDetailCell";

#define MainScreen    [UIScreen mainScreen].bounds.size

#define NumRow    1

//#define ChatInputViewH 56.5

@interface JGJDetailViewController ()<
UICollectionViewDelegate,

UICollectionViewDataSource,

UITextViewDelegate,

HJPhotoBrowserDelegate,

ClickDetailButtondelegate,

UITextFieldDelegate,

ClickreciveButtondelesgate,

editeDelegate,

FDAlertViewDelegate,

tapCollectionDelegate,

tapProdelegate,

ClickHeadWaitDodelegate,

JGJNewDetailCollectionViewCellDelegate,

JGJChatInputViewDelegate,

JGJSendMessageViewDelegate,

JGJDescriptionCollectionViewCellDelegate,

UIScrollViewDelegate,

JGJTaskDetailCellDelegate

>
{
    JGJDescriptionCollectionViewCell *Descell;
    
    JGJTheCurrentAddressOfLogDetailInfoTCell *_addressInfoCell;
    UIView *topView;
    
    float Keyheight;
    
    NSMutableArray *ImageArray;
    
    NSString *masg_id;
    
    NSMutableArray *ReplyArray;
    
    NSMutableArray *HadReciveArr;
    
    NSMutableArray *UnReciveArr;
    
    UILabel *departlable;
    
    NSArray *_ChatMsgArray;
    
    UIButton *replybutton;
    
    JGJRightFromCollectionViewCell * rightcell;
    
    JGJHoldCollectionViewCell *holdcell;
    
    NSString  *hadRecive;
    
    CGSize imagSizel;
    
    CGSize scaleImagesize;
    
    JGJReciveHeadCollectionViewCell *recivecell;
    
    // 接收人id字符串,作为修改日志时，传给后台的参数
    NSString *_receiver_uid;
    
}
@property(nonatomic ,assign)CGFloat textFieldOldHeight;

@property(nonatomic ,strong)UITextView *TextView;

@property(nonatomic ,strong)UITextField *NTextView;


@property(nonatomic ,assign)UIButton *HadButton;

@property (nonatomic, strong) NSArray *modelsArray;

@property (nonatomic, strong) UIView  *HoldView;

@property (nonatomic, strong) JGJNotifyDetailMembersModel *detailMemeberModel;

@property (nonatomic, strong) JGJLogWeatherDeailModel *weatherModel;

@property (nonatomic, strong) NSArray *memberModels;

@property (nonatomic, strong) NSArray *ReciveMembersModelArr;

@property (nonatomic, strong) JGJChatMsgListModel *gethchatMsgmodel;

@property (nonatomic, assign) BOOL ReplyState;

@property (nonatomic, strong) UIButton *emojiButton;

//@property (nonatomic, strong) JGJChatInputView *chatInputView;

@property (nonatomic, strong) JGJSendMessageView *sendMessageView;

//保存当前的msg_id
@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, strong) NSMutableArray *replyList;

@property (nonatomic, strong) JGJQualityReplyRequestModel *replyRequest;

@end

@implementation JGJDetailViewController

-(UIImage *)photoBrowser:(HJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return [UIImage imageNamed:@""];
}
-(void)clickcancelButton
{
    
}
-(void)sendMessageView:(JGJSendMessageView *)messageView sendMessageViewButtonType:(JGJSendMessageViewType)buttonType
{
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.MainCollectionview];
    
    ImageArray = [NSMutableArray array];
    
    NSString *uid = self.jgjChatListModel.uid;
    
    if ([NSString isEmpty:uid]) {
        
        uid = self.jgjChatListModel.msg_sender;
    }
    
    if (self.jgjChatListModel.chatListType == JGJChatListLog && !self.workProListModel.isClosedTeamVc && [uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
        
        [self loadRightView];
        
    }
    if (!self.workProListModel.isClosedTeamVc || !self.jgjChatListModel.IsCloseTeam) {//已关闭项目不初始化回复编辑栏
        
        
    }else{
        
        [self.view addSubview:self.closeTeamImage];
        
    }
    
    _NTextView.text = [JGJHistoryText readWithkey:@"sendDetail"];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideAndHidtextfile:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShowAndshowtextfile:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [self emojiKeyBoard];
    
    self.maxImageCount = 9;
    
    //符文本点击的跳转连接
    //    [TYNotificationCenter addObserver:self selector:@selector(clickUrl:) name:JLGcontentOpenUrl object:nil];
    
}
-(void)clickUrl:(NSNotification *)notification
{
    NSDictionary *urlDic = notification.object;
    JGJMyWebviewViewController *webVc = [[JGJMyWebviewViewController alloc]init];
    webVc.url = urlDic[@"url"];
    [self.navigationController pushViewController:webVc animated:YES];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([NSString isEmpty: self.chatInputView.textView.text ]) {
        self.chatInputView.placeholder = @"请输入回复内容";
        
    }
    self.jgjChatListModel.reply_uid = nil;
    
    [self hiddenEmojiKeyboard];
    
    [self.view endEditing:YES];
    
}

- (void)hiddenEmojiKeyboard {
    
    self.chatInputView.switchingKeybaord = NO;
    
    [self keyboardWillHideAndHidtextfile:nil];
}
#pragma mark - 更换键盘
-(void)emojiKeyBoard{
    
    [self.view addSubview:self.chatInputView];
    
    self.chatInputView.hidden = self.workProListModel.isClosedTeamVc;
    
    if (self.workProListModel.isClosedTeamVc) {
        
        [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.mas_equalTo(self.view);
            
            make.height.mas_equalTo(0);
            
        }];
        
    }else {
        
        [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_equalTo(self.view);
            
            make.height.mas_equalTo(ChatInputViewH);
            
            make.bottom.mas_equalTo(ChatTabbarSafeBottomMargin);

            
        }];
        
    }
    
    [self.MainCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.bottom.mas_equalTo(self.chatInputView.mas_top);
        
    }];
    
    
}

-(void)keyboardWillHideAndHidtextfile:(NSNotification *)obj
{
    
    //    if ([NSString isEmpty: self.chatInputView.textView.text ]) {
    //        _chatInputView.placeholder = @"请输入回复内容";
    //
    //    }
    //    self.jgjChatListModel.reply_uid = nil;
    // 如果正在切换键盘，就不要执行后面的代码
    double duration = 0.25;
    
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.chatInputView.switchingKeybaord){
        
        //增加高度
        [UIView animateWithDuration:duration animations:^{
            
            [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view).offset(-EmotionKeyboardHeight);
                
            }];
        }];
        
        return;
    }
    
    //取消指定人的回复
    //    self.sendMessageView.inputTextView.text = nil;
    //
    //    self.sendMessageView.inputTextView.placeholderText = @"请输入回复内容";
    
    
    [UIView animateWithDuration:duration animations:^{
        //显示
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(ChatTabbarSafeBottomMargin);
            
        }];
        
        [self.MainCollectionview mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view).offset(0);
            
        }];
        
        [self.MainCollectionview layoutIfNeeded];
        
        [self.chatInputView layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        
    }];
    
    if (self.chatInputView.emotionKeyboard) {
        
        [self.chatInputView.emotionKeyboard removeFromSuperview];
    }
    
}
-(void)keyboardWillShowAndshowtextfile:(NSNotification *)obj
{
    
    // 如果正在切换键盘，就不要执行后面的代码
    //    if (self.chatInputView.switchingKeybaord) return;
    
    NSDictionary *userInfo = obj.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yEndOffset = TYGetUIScreenHeight - endKeyboardRect.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        //显示
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.view).offset(-yEndOffset);
            
        }];
        [self.chatInputView layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}
-(void)backButtonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    [JGJHistoryText saveWithKey:@"sendDetail" andContent:_TextView.text?:@""];
    
}

-(UICollectionView *)MainCollectionview
{
    if (!_MainCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        if (self.workProListModel.isClosedTeamVc) {//已关闭项目不初始化回复编辑栏
            
            _MainCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70) collectionViewLayout:layout];
            
        }else{
            
            _MainCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40.5-70) collectionViewLayout:layout];
            
        }
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _MainCollectionview.showsHorizontalScrollIndicator = NO;
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:headIdentifer];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJDescriptionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DesCriptionid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Imagecellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJNewsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Newscellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJHadReciveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:hadreciveLableid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJNewDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:newDetail];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJRightFromCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:FromCellId];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJReciveHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reciveHead];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJDepartLableCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:departcellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:secondcellId];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJThreeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ThreeCellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJHoldCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HoldCellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJConstructDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:strunctdetailCellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJconstrunCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:strunctCellid];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJFromProCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:fromproCellID];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJSingerTextCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:singerTextID];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJSingerNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:singerNumID];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJMoreLineTextCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:moreLineTextID];
        
        [_MainCollectionview registerNib:[UINib nibWithNibName:@"JGJDetailStatusNumerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:numId];

        [self.MainCollectionview registerNib:[UINib nibWithNibName:@"JGJDetailNoticesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:systemNoticeCellId];

        // 注册地址信息cell
        [_MainCollectionview registerClass:[JGJTheCurrentAddressOfLogDetailInfoTCell class] forCellWithReuseIdentifier:NSStringFromClass([JGJTheCurrentAddressOfLogDetailInfoTCell class])];
        //有图片的样式
        [self.MainCollectionview registerNib:[UINib nibWithNibName:JGJTaskDetailCellID bundle:nil] forCellWithReuseIdentifier:JGJTaskDetailCellID];
        
        _MainCollectionview.dataSource = self;
        
        _MainCollectionview.delegate = self;
        
        _MainCollectionview.backgroundColor = [UIColor whiteColor];
        
        _MainCollectionview.scrollEnabled = YES;
        
        _MainCollectionview.bounces = YES;
        
        _MainCollectionview.showsVerticalScrollIndicator = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeection)];
        
        tap.cancelsTouchesInView = NO;
        
        [_MainCollectionview addGestureRecognizer:tap];
        
        self.MainCollectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
                
                [self getLogDeailWithId:_jgjChatListModel];
                
                
            }else{
                
                if ([self.jgjChatListModel.msg_type isEqualToString:@"notice"]) {
                    
                    [self getNoticeInfoWithMsgid:_jgjChatListModel];
                    
                }else {
                    
                    [self HadRecivemasgID:_jgjChatListModel];//其他列表
                }
                
            }
        }];
    }
    
    
    return _MainCollectionview;
    
    
}

-(void)clickColeection
{
    [self hiddenEmojiKeyboard];
    
    [self.view endEditing:YES];
    
    
}
-(UICollectionViewCell *)accordingTypeReturnCollectioncell:(NSString *)type andIndexPath:(NSIndexPath *)indexPath andCollectionview:(UICollectionView *)collectionview
{
    if ([type isEqualToString:@"text"] ||[type isEqualToString:@"number"] ||[type isEqualToString:@"select"] ||[type isEqualToString:@"date"]||[type isEqualToString:@"dateframe"]||[type isEqualToString:@"date"]|| [type isEqualToString:@"logdate"]) {
        JGJSingerTextCollectionViewCell *cell =[collectionview dequeueReusableCellWithReuseIdentifier:singerTextID forIndexPath:indexPath];
        cell.elementModel = _logDeailModel.element_list[indexPath.row ];
        
        return cell;
        
    }else if ([type isEqualToString:@"textarea"])
    {
        JGJMoreLineTextCollectionViewCell *cell =[collectionview dequeueReusableCellWithReuseIdentifier:moreLineTextID forIndexPath:indexPath];
        cell.elementModel = _logDeailModel.element_list[indexPath.row];
        return cell;
        
    }else if ([type isEqualToString:@"weather"])
    {
        JGJconstrunCollectionViewCell *cell =[collectionview dequeueReusableCellWithReuseIdentifier:strunctCellid forIndexPath:indexPath];
        _jgjChatListModel.weat_pm = _weatherModel.weat_pm;
        _jgjChatListModel.weat_am = _weatherModel.weat_am;
        _jgjChatListModel.temp_am = _weatherModel.temp_am;
        _jgjChatListModel.temp_pm = _weatherModel.temp_pm;
        _jgjChatListModel.wind_am = _weatherModel.wind_am;
        _jgjChatListModel.wind_pm = _weatherModel.wind_pm;
        cell.ChatMsgListModel     = _jgjChatListModel;
        return cell;        
    }else{
        JGJSingerNumCollectionViewCell *cell =[collectionview dequeueReusableCellWithReuseIdentifier:singerNumID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }
    
}
-(float)accordingTypeRetrunHeight:(NSString *)type andIndextpath:(NSIndexPath *)indexpath
{
    if ([type isEqualToString:@"text"] ||[type isEqualToString:@"number"] ||[type isEqualToString:@"select"] ||[type isEqualToString:@"date"]||[type isEqualToString:@"dateframe"]||[type isEqualToString:@"date"] || [type isEqualToString:@"logdate"]) {
        
        return [self RowSingerLineHeight:[_logDeailModel.element_list[indexpath.row] element_value] andDepart_W:[self RowNodepartHeight:[[_logDeailModel.element_list[indexpath.row] element_name] stringByAppendingString:@"："]]] + 13;
        //        return 18;
        
    }else if ([type isEqualToString:@"weather"])
    {
        return 85;
    }else if ([type isEqualToString:@"textarea"])
    {
        if ([NSString isEmpty:[_logDeailModel.element_list[indexpath.row] element_value]]) {
            
            return 35;
        }
        return [self RowMoreLineHeight:[_logDeailModel.element_list[indexpath.row] element_value] andDepart_W:[self RowNodepartHeight:[_logDeailModel.element_list[indexpath.row] element_name]] + 2] +25 + 15 ;
    }else{
        
        return 0;
        
    }
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //头部
        JGJHeadCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:headIdentifer forIndexPath:indexPath];
        cell.backgroundColor = AppFontfafafaColor;
        cell.model = self.jgjChatListModel;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 1){

        //信息
        if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
            
            return [self accordingTypeReturnCollectioncell:[_logDeailModel.element_list[indexPath.row] element_type] andIndexPath:indexPath andCollectionview:collectionView];
            
        }else{
            
            Descell = [collectionView dequeueReusableCellWithReuseIdentifier:DesCriptionid forIndexPath:indexPath];
            Descell.model = self.jgjChatListModel;
            Descell.delegate = self;
            return Descell;
        }
        
    }else if(indexPath.section == 2){
        
        NSString *ID = NSStringFromClass([JGJTheCurrentAddressOfLogDetailInfoTCell class]);
        _addressInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        
        BOOL isHaveLocation = NO;
        for (int i = 0; i < _logDeailModel.element_list.count; i ++) {
            
            JGJElementDetailModel *model = _logDeailModel.element_list[i];
            if ([model.element_type isEqualToString:@"location"]) {
                
                _addressInfoCell.locationJsonStr = model.element_value;
                isHaveLocation = YES;
            }
        }
        if (![self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
            
            _addressInfoCell.hidden = YES;
        }else {
            
            if (isHaveLocation) {
                
                _addressInfoCell.hidden = NO;
                
            }else {
                
                _addressInfoCell.hidden = YES;
            }
            
        }
        return _addressInfoCell;
    }
    // 位置信息
    if (indexPath.section == 3) {
        
        //大图
        JGJImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:Imagecellid forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.jgjChatListModel;
        if (self.jgjChatListModel.msg_src.count>0) {
            cell.Url_str = self.jgjChatListModel.msg_src[indexPath.row];
            
        }
        return cell;
        
    }
    else if(indexPath.section == 4){
        
        JGJFromProCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:fromproCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.jgjChatListModel = self.jgjChatListModel;
        
        cell.delegate = self;
        return cell;
        
    }else if(indexPath.section == 5){
        
        rightcell = [collectionView dequeueReusableCellWithReuseIdentifier:FromCellId forIndexPath:indexPath];
        rightcell.isClosedTeamVc = self.workProListModel.isClosedTeamVc;//是否已关闭项目i
        rightcell.jgjChatListModel = self.jgjChatListModel;
        rightcell.delegate = self;
        if (hadRecive) {
            rightcell.hadClick = hadRecive;
        }
        
        return rightcell;
        
        
    }else if(indexPath.section ==6){
        
        JGJHoldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HoldCellid forIndexPath:indexPath];
        
        return cell;
        
        
    }
    
    else if(indexPath.section == 7){
        
        JGJDetailStatusNumerCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:numId forIndexPath:indexPath];
        cell.textLable.text = [NSString stringWithFormat:@"(%@人)",self.detailMemeberModel.readed_percent?:@"0/0"];
        
        return cell;
        
    }
    
    else if(indexPath.section == 8){
        recivecell = [collectionView dequeueReusableCellWithReuseIdentifier:reciveHead forIndexPath:indexPath];
        recivecell.headImageView.layer.masksToBounds = YES;
        recivecell.headImageView.layer.cornerRadius = JGJCornerRadius;
        if (self.memberModels.count) {
            recivecell.holdLable.hidden = YES;
            recivecell.detailMemeberModel = self.memberModels[indexPath.row];
            recivecell.headImageView.hidden = NO;
            recivecell.headButton.hidden = NO;
            //            recivecell.noDataLable.hidden = YES;
        }else{
            recivecell.backgroundColor = [UIColor whiteColor];
            recivecell.contentView.backgroundColor = [UIColor whiteColor];
            recivecell.headImageView.hidden = YES;
            recivecell.holdLable.hidden = NO;
            recivecell.headButton.hidden = YES;
            //            recivecell.noDataLable.hidden = NO;
        }
        
        return recivecell;
        
        
    }
    else if(indexPath.section == 9){
        
        JGJDepartLableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:departcellid forIndexPath:indexPath];
        cell.color = AppFontdbdbdbColor;
        return cell;
        
        
    }else if (indexPath.section == 10){
        
        JGJQualityDetailReplayListModel *listModel = self.replyList[indexPath.row];
        
        if (ReplyArray.count) {
            if ([ReplyArray[indexPath.row][@"is_system_reply"]?:@"0" intValue]) {
                
                JGJDetailNoticesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:systemNoticeCellId forIndexPath:indexPath];
                
                cell.dataDic = ReplyArray[indexPath.row];
                
                return cell;
            }
        }
        
        if(listModel.msg_src.count > 0) {
            
            JGJTaskDetailCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:JGJTaskDetailCellID forIndexPath:indexPath];
            
            cell.delegate = self;
            
            cell.listModel = listModel;
            
            return cell;
            
        }
        
        //详细信息
        JGJNewDetailCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:newDetail forIndexPath:indexPath];
        cell.NameLbale.textColor = AppFont628ae0Color;
        cell.DataArray = ReplyArray[indexPath.row];
        cell.delegate = self;
        cell.NameLbale.tag = indexPath.row;
        return cell;
    }
    
    
    return 0;
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NumRow;
            break;
        case 1:
            if (self.jgjChatListModel.chatListType == JGJChatListLog) {
                
                return _logDeailModel.element_list.count;
            }
            if ([NSString isEmpty:_jgjChatListModel.msg_text]) {
                return 0;
            }
            return NumRow;
            break;
        case 2:
            if (![self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
                
                return 0;
            }else {
                
                BOOL isHaveLocation = NO;
                for (int i = 0; i < _logDeailModel.element_list.count; i ++) {
                    
                    JGJElementDetailModel *model = _logDeailModel.element_list[i];
                    if ([model.element_type isEqualToString:@"location"]) {
                        
                        isHaveLocation = YES;
                    }
                }
                
                if (isHaveLocation) {
                    
                    return NumRow;
                    
                }else {
                    
                    return 0;
                }
                
            }
            break;
        case 3:
            
            if (self.jgjChatListModel.msg_src.count <= 0) {
                return 0;
            }
            return 1;
            
            break;
        case 4:
            return NumRow;
            break;
            
        case 5:
            return 0;
            break;
        case 6:
            return NumRow;
            break;
        case 7:
            return NumRow;
            break;
        case 8:
            
            return 0;
            
            break;
        case 9:
            return 0;
            break;
        case 10:
            
            if (ReplyArray.count) {
                
                return ReplyArray.count;
            }else{
                return NumRow;
            }
            
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            //非日志
            return CGSizeMake(MainScreen.width, 65);
            break;
        case 1:
            
            if (self.jgjChatListModel.chatListType == JGJChatListLog) {
                
                return CGSizeMake(TYGetUIScreenWidth, [self accordingTypeRetrunHeight:[_logDeailModel.element_list[indexPath.row] element_type] andIndextpath:indexPath]);
                
            }else{
                
                return CGSizeMake(MainScreen.width, [self RowHeight:self.jgjChatListModel.msg_text] + 10);
            }
            break;
        case 2:
            
            if (![self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
                
                return CGSizeMake(MainScreen.width, 0);
                
            }else {
                
                NSString *address;
                BOOL isHaveLocation = NO;
                for (int i = 0; i < _logDeailModel.element_list.count; i ++) {
                    
                    JGJElementDetailModel *model = _logDeailModel.element_list[i];
                    if ([model.element_type isEqualToString:@"location"]) {
                        
                        NSDictionary *locationDic = (NSDictionary *)[model.element_value mj_JSONObject];
                        address = [NSString stringWithFormat:@"%@%@",locationDic[@"address"]?:@"",locationDic[@"name"]?:@""];
                        isHaveLocation = YES;
                    }
                }
                
                if (isHaveLocation) {
                    
                    CGFloat height = [NSString getContentHeightWithString:address maxWidth:TYGetUIScreenWidth - 65];
                    if (height <= 20.0) {
                        
                        return CGSizeMake(MainScreen.width, 60 + 20);
                        
                    }else {
                        
                        return CGSizeMake(MainScreen.width, 60 + height);
                    }
                }else {
                    
                    return CGSizeMake(MainScreen.width, 0);
                }
                
            }
            break;
            
        case 3:
            
            if (self.jgjChatListModel.msg_src.count == 1) {
                
                [self getimagSizeWithUrl:self.jgjChatListModel.msg_src[0]];
                return [self retrunImagesize:imagSizel];
            }else{
                
                if (self.jgjChatListModel.msg_src.count > 0) {
                    return CGSizeMake(TYGetUIScreenWidth, ((self.jgjChatListModel.msg_src.count - 1)/3 +1)*((250.00/375*TYGetUIScreenWidth -5 * 4) /3 ) + ((self.jgjChatListModel.msg_src.count - 1)/3 +1)*3 + 4);
                    
                }else{
                    return CGSizeMake(TYGetUIScreenWidth, 1);
                }
                
            }
            
            
            break;
            
        case 4:
            return CGSizeMake(MainScreen.width, [self RowSingerLineHeight:self.jgjChatListModel.from_group_name?:@"" andDepart_W:20] > 25?40:32);
            break;
        case 5:
            return CGSizeMake(MainScreen.width, 45);
            break;
        case 6:
            return CGSizeMake(MainScreen.width, 10);
            break;
            
        case 7:
            
            return CGSizeMake(MainScreen.width, 55);;
            
            break;
        case 8:
            
            return CGSizeMake(TYGetUIScreenWidth, 0);
            
            break;
        case 9:
            
            return CGSizeMake(MainScreen.width, 1);
            
            break;
        case 10:
            if (!ReplyArray.count) {
                return CGSizeZero;
            }else{
                if ([ReplyArray[indexPath.row][@"is_system_reply"]?:@"0" intValue]) {
                    //此处系统消息
                    NSString *content = [NSString stringWithFormat:@"%@\n%@",ReplyArray[indexPath.row][@"user_info"][@"real_name"],ReplyArray[indexPath.row][@"reply_text"]];
                    CGFloat timeWidth = [JGJLableSize RowWidth:ReplyArray[indexPath.row][@"create_time"]?:@"" andFont:[UIFont systemFontOfSize:13.1]];
//                    CGFloat reply_height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 56 - timeWidth content:content font:AppFont30Size];
                    
                    CGFloat reply_height = [NSString stringWithContentWidth:TYGetUIScreenWidth -56 - timeWidth content:content font:AppFont30Size lineSpace:1];
                    
                    UIFont *font = FONT(AppFont30Size);
                    
                    if (reply_height > 2 * font.lineHeight) {
                        
                        reply_height = 2 * font.lineHeight + 10;
                        
                    }
                    return CGSizeMake(TYGetUIScreenWidth, reply_height + 20);
                    
                }
                
                CGFloat height = 50;
                
                JGJQualityDetailReplayListModel *listModel = self.replyList[indexPath.row];
                
                if (listModel.msg_src.count > 0) {
                    
                    height = listModel.taskHeight;
                    
                }else {
                    
                    height = [self RowHeight:ReplyArray[indexPath.row][@"reply_text"]]+52;
                }
                
                return CGSizeMake(MainScreen.width, height);
            }
            break;
            
        default:
            break;
    }
    return CGSizeZero;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 11;
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    if (section == 3){
        if (self.jgjChatListModel.msg_src.count==1) {
            return UIEdgeInsetsMake(10.0f, 10.0f, 1.0f, TYGetUIScreenWidth - 10 -scaleImagesize.width);
        }else{
            if (self.jgjChatListModel.msg_src.count == 0) {
                return UIEdgeInsetsMake(0.0f, 0.0f, 2.0f, 0.0f);
            }else{
                return UIEdgeInsetsMake(8.0f, 0.0f, 2.0f, 0.0f);
            }
        }
    }else if (section == 6){
        return UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    } else if (section == 7){
        
        
        return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
        
    }else if (section == 8){
        
        return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
        
    }
    
    return UIEdgeInsetsZero;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [TYShowMessage showPlaint:@"这些都是示范数据，无法操作，谢谢"];
        return;
    }
    
    if (self.workProListModel.isClosedTeamVc) {
        return;
    }
    if (indexPath.section == 8) {
        
        if (HadReciveArr.count) {
            
            JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
            
            perInfoVc.jgjChatListModel.uid = HadReciveArr[indexPath.row][@"uid"];
            perInfoVc.jgjChatListModel.group_id = _workProListModel.group_id;
            perInfoVc.jgjChatListModel.class_type = _workProListModel.class_type;
            JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
            JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
            memberModel.is_active = [NSString stringWithFormat:@"%@", HadReciveArr[indexPath.row][@"is_active"]];
            memberModel.real_name = HadReciveArr[indexPath.row][@"real_name"];
            memberModel.telphone = HadReciveArr[indexPath.row][@"telphone"];
            commonModel.teamModelModel = memberModel;
            
            if ([memberModel.is_active isEqualToString:@"0"]) {
                
                [self handleClickedUnRegisterAlertViewWithCommonModel:commonModel];
            }else {
                
                [self.navigationController pushViewController:perInfoVc animated:YES];
            }
        }
    }else if (indexPath.section == 0 && indexPath.row == 0){
        if (_jgjChatListModel) {
            
            JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
            perInfoVc.jgjChatListModel.group_id = _workProListModel.group_id;
            perInfoVc.jgjChatListModel.class_type = _workProListModel.class_type;
            if ( [NSString isEmpty:_jgjChatListModel.uid]) {
                perInfoVc.jgjChatListModel.uid = _jgjChatListModel.msg_sender;
            }else{
                perInfoVc.jgjChatListModel.uid = _jgjChatListModel.uid;
            }
            [self.navigationController pushViewController:perInfoVc animated:YES];
        }
    }
    else if (indexPath.section == 10) {
        if (indexPath.row > ReplyArray.count-1 ||[ ReplyArray[indexPath.row][@"is_system_reply"]?:@"0" intValue] == 1) {
            
            return;
        }
        
        if ([ReplyArray[indexPath.row][@"operate_delete"] integerValue] == 1) {
            
            [self sheetViewWithDic:ReplyArray[indexPath.row] indexPath:indexPath];
            
        }else {
            
            _ReplyState = YES;
            self.jgjChatListModel.reply_uid = ReplyArray[indexPath.row][@"user_info"][@"uid"];
            
            self.chatInputView.placeholder = [NSString stringWithFormat:@"回复%@：",ReplyArray[indexPath.row][@"user_info"][@"real_name"]];
            [self.chatInputView.textView becomeFirstResponder];
        }
        
    }else  if (indexPath.section == 3) {
        
        if (self.jgjChatListModel.msg_src.count == 1) {
            JGJImageCollectionViewCell *cell = (JGJImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            NSArray *imageArr = @[cell.ImageView];
            [JGJCheckPhotoTool browsePhotoImageView:self.jgjChatListModel.msg_src selImageViews:imageArr didSelPhotoIndex:0];
        }
        
    }else if (indexPath.section == 7){
#pragma mark - 点击已读未读人数行
        
        JGJDetailUnReadInfoVc *unReadInfoVc = [JGJDetailUnReadInfoVc new];
        
        unReadInfoVc.is_readed_notify = YES;
        
        unReadInfoVc.chatMsgListModel = self.jgjChatListModel;
        
        [self.navigationController pushViewController:unReadInfoVc animated:YES];
        
    }
    
}

- (void)sheetViewWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    
    TYWeakSelf(self);
    
    NSArray *buttons = @[@"删除",@"取消"];
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            [weakself delRepleWithId:dic[@"id"] indexPath:indexPath];
        }
    }];
    
    [sheetView showView];
    
}

#pragma mark - 删除自己回复的消息
- (void)delRepleWithId:(NSString *)id_str indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *parameters = @{
                                 @"id" : id_str,
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/delReplyMessage" parameters:parameters success:^(id responseObject) {
        
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithArray:ReplyArray];
        [dataArr removeObjectAtIndex:indexPath.row];
        ReplyArray = dataArr;
        [self.MainCollectionview reloadData];
        [TYShowMessage showSuccess:@"删除成功"];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_ReplyState) {
        _TextView.text = @"";
        _TextView.textColor = AppFont333333Color;
        _ReplyState = NO;
    }
    
    return YES;
}

//点击回复消息的名字Lable
-(void)JGJNewDetailCollectionViewCellTapNameLableAndIndexpathRow:(NSInteger)row
{
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    perInfoVc.jgjChatListModel.uid = ReplyArray[row][@"user_info"][@"uid"];
    perInfoVc.jgjChatListModel.group_id = _workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = _workProListModel.class_type;
    JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
    JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
    memberModel.is_active = [NSString stringWithFormat:@"%@", ReplyArray[row][@"real_name"][@"is_active"]];
    memberModel.telphone = ReplyArray[row][@"telphone"];
    commonModel.teamModelModel = memberModel;
    if ([memberModel.is_active isEqualToString:@"0"]) {
        [self handleClickedUnRegisterAlertViewWithCommonModel:commonModel];
    }else {
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
}

-(void)tapCollectionViewSectionAndTag:(NSInteger)currentIndex imagArrs:(NSMutableArray *)imageArrs
{
    
    
    [JGJCheckPhotoTool browsePhotoImageView:self.jgjChatListModel.msg_src selImageViews:imageArrs didSelPhotoIndex:currentIndex];
    
}


- (void)handleClickedUnRegisterAlertViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel {
    
    commonModel.alertViewHeight = 210.0;
    commonModel.alertmessage = @"该用户还未注册,赶紧让他下载【吉工家工人班组】一起开展工作吧!";
    commonModel.alignment = NSTextAlignmentLeft;
    [JGJCustomProInfoAlertVIew alertViewWithCommonModel:commonModel];
    
}

-(float)RowMoreLineHeight:(NSString *)Str andDepart_W:(NSInteger )width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20,3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1;
    
    
}

-(float)RowSingerLineHeight:(NSString *)Str andDepart_W:(NSInteger )width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - width - 20,3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1;
}

-(float)RowNodepartHeight:(NSString *)Str
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width;
}


-(float)RowHeight:(NSString *)Str
{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1 ;
    
}

-(float)RowDrewHeight:(NSString *)Str
{
    UILabel *lable = [[UILabel alloc]init];
    lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:13.2];
    lable.text = Str;
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    lable.textColor = [UIColor darkTextColor];
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-10, 1000);
    CGSize expectSize = [lable sizeThatFits:maximumLabelSize];
    
    return expectSize.height;
    
}
- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    _jgjChatListModel = jgjChatListModel;
    
    _jgjChatListModel.msg_text = @"";
    masg_id = jgjChatListModel.msg_id;

    [self.MainCollectionview.mj_header beginRefreshing];
//    if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
//
//        [self getLogDeailWithId:jgjChatListModel];
//
//
//    }else{
//
//        if ([self.jgjChatListModel.msg_type isEqualToString:@"notice"]) {
//
//            [self getNoticeInfoWithMsgid:jgjChatListModel];
//
//        }else {
//
//            [self HadRecivemasgID:jgjChatListModel];//其他列表
//        }
//
//    }
    
}

- (void)getNoticeInfoWithMsgid:(JGJChatMsgListModel *)jgjChatListModel
{
//    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    NSDictionary *param ;
    if (![NSString isEmpty:jgjChatListModel.bill_id] && ![jgjChatListModel.bill_id isEqualToString:@"0"]) {
        
        param = @{@"bill_id":jgjChatListModel.bill_id?:@""};
    }else {
        
        param = @{@"id":jgjChatListModel.msg_id?:@""};
    }
//    self.MainCollectionview.hidden = YES;
    [JLGHttpRequest_AFN PostWithApi:@"pc/Notice/noticeInfo" parameters:param success:^(id responseObject) {
        
        UserInfo *userinfoModel = [UserInfo mj_objectWithKeyValues:responseObject[@"user_info"]];
        JGJChatMsgListModel *chatModel = [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
        self.jgjChatListModel.class_type = chatModel.class_type;
        self.jgjChatListModel.create_time = chatModel.create_time;
        self.jgjChatListModel.from_group_name = chatModel.from_group_name;
        self.jgjChatListModel.group_id = chatModel.group_id;
        self.jgjChatListModel.id = chatModel.id;
        self.jgjChatListModel.msg_src = chatModel.msg_src;
        self.jgjChatListModel.msg_text = chatModel.msg_text;
        self.jgjChatListModel.send_time = chatModel.send_time;
        self.jgjChatListModel.user_name = userinfoModel.real_name;
        self.jgjChatListModel.real_name = userinfoModel.real_name;
        self.jgjChatListModel.head_pic  = userinfoModel.head_pic;
        self.jgjChatListModel.uid       = userinfoModel.uid;
        self.jgjChatListModel.msg_id    = chatModel.msg_id;
//        self.MainCollectionview.hidden = NO;
        
        [self HadRecivemasgID:self.jgjChatListModel];//其他列表
        [self.MainCollectionview reloadData];
        [TYLoadingHub hideLoadingView];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [_MainCollectionview.mj_header endRefreshing];
        if ([error isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = (NSDictionary *)error;
            [TYShowMessage showError:dic[@"errmsg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }];
}

#pragma mark - 获取日志模板等信息
-(void)getLogDeailWithId:(JGJChatMsgListModel *)msg_model
{
    NSString *keyStr;
    //以前一直是id现在没法兼容  聊天室进入会改成msg_id
    NSDictionary *param;
    
    if (![NSString isEmpty:msg_model.bill_id]) {
        
    
        param = @{@"bill_id":msg_model.bill_id};
    }else {
        
        keyStr = _chatRoomGo?@"msg_id":@"id";
        
        if (!_msg_id) {
            
            _msg_id = msg_model.msg_id;
        }
        
        param = @{keyStr:_msg_id?:@""};
        
        
    }
//    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"pc/Log/logInfo" parameters:param success:^(id responseObject) {
       
        _logDeailModel = [JGJLogDetailModel mj_objectWithKeyValues:responseObject];
        _gethchatMsgmodel = [JGJChatMsgListModel mj_objectWithKeyValues:responseObject];
        _receiver_uid = responseObject[@"receiver_list"][@"receiver_uid"];
        
        self.jgjChatListModel.create_time = _gethchatMsgmodel.create_time;
        self.jgjChatListModel.week_day = _gethchatMsgmodel.week_day;
        
        JGJLogUserInfoModel *userInfo = [JGJLogUserInfoModel mj_objectWithKeyValues:responseObject[@"user_info"]];
        _jgjChatListModel.week_day    = _gethchatMsgmodel.week_day;
        _jgjChatListModel.create_time = _gethchatMsgmodel.create_time;
        _jgjChatListModel.real_name   = userInfo.real_name;
        _jgjChatListModel.user_name = userInfo.real_name;
        _jgjChatListModel.head_pic    = userInfo.head_pic;
        _jgjChatListModel.uid         = userInfo.uid;
        _jgjChatListModel.msg_src     = _logDeailModel.msg_src;
        _jgjChatListModel.cat_name    = _gethchatMsgmodel.cat_name;
        _jgjChatListModel.cat_id       = _gethchatMsgmodel.cat_id;
        _jgjChatListModel.from_group_name       = _gethchatMsgmodel.from_group_name;
        _jgjChatListModel.id       = _gethchatMsgmodel.id;

        _jgjChatListModel.msg_id  = _gethchatMsgmodel.msg_id;
        _jgjChatListModel.group_id = _gethchatMsgmodel.group_id;
        
        _jgjChatListModel.class_type = _gethchatMsgmodel.class_type;
        
        self.title = [_jgjChatListModel.cat_name stringByAppendingString:@"详情"];
        
        for (int i = 0; i< _logDeailModel.element_list.count; i++) {
            if ([[_logDeailModel.element_list[i] element_type] isEqualToString:@"weather"]) {
                NSDictionary *dic = [[NSDictionary alloc]init];
                dic = [self parseJSONStringToNSDictionary:responseObject[@"element_list"][i][@"weather_value"]];
                
                _weatherModel = [JGJLogWeatherDeailModel mj_objectWithKeyValues:dic];
            }
            
        }
        //修改返回
        if (_ModifyLog) {
            _jgjChatListModel.msg_src = _logDeailModel.msg_src;
            
        }
        [self HadRecivemasgID:self.jgjChatListModel];//其他列表
        [_MainCollectionview reloadData];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = (NSDictionary *)error;
            [TYShowMessage showError:dic[@"errmsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [TYLoadingHub hideLoadingView];
        [_MainCollectionview.mj_header endRefreshing];
    }];
}


- (void)HadRecivemasgID:(JGJChatMsgListModel *)jgjChatListModel {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
       
        return;
    }
    if ([NSString isEmpty:jgjChatListModel.msg_id]) {
        [TYShowMessage showError:@"消息类型错误"];
        return;
    }
    
    if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
        
        NSString *keyStr;
        
        NSDictionary *body;
        keyStr = _chatRoomGo?@"msg_id":@"id";
        body = @{
                 @"pg": @"",
                 @"pagesize": @"",
                 keyStr:jgjChatListModel.msg_id
                 };
        
        [JLGHttpRequest_AFN PostWithApi:@"pc/Log/logReplyList" parameters:body success:^(id responseObject) {
            
            //回复
            ReplyArray = [NSMutableArray array];
            ReplyArray = responseObject[@"replyList"];
            
            self.replyList = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject[@"replyList"]];
            
            //已收到头像
            HadReciveArr = [NSMutableArray array];
            HadReciveArr = responseObject[@"members"];
            
            //未收到头像
            UnReciveArr = [NSMutableArray array];
            UnReciveArr = responseObject[@"unrelay_members"];
            hadRecive = responseObject[@"is_replyed"];
            _ChatMsgArray = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            self.detailMemeberModel = [JGJNotifyDetailMembersModel new];
            self.detailMemeberModel = [JGJNotifyDetailMembersModel mj_objectWithKeyValues:responseObject];
            self.memberModels = [NSArray array];
            self.memberModels = self.detailMemeberModel.members;
            self.ReciveMembersModelArr = [NSArray array];
            self.ReciveMembersModelArr = self.detailMemeberModel.unrelay_members;
            
            [_MainCollectionview.mj_header endRefreshing];
            [_MainCollectionview reloadData];
            
            [TYShowMessage hideHUD];
            
            if (self.replyChat) {
                [self ScrollBottm];
            }
            
            
        }failure:^(NSError *error) {
            
            [TYShowMessage hideHUD];
            [_MainCollectionview.mj_header endRefreshing];
        }];
        
    }else{
        
        NSDictionary *body;
        
        body = @{
                 @"pg": @"",
                 @"pagesize": @"",
                 @"msg_id":jgjChatListModel.msg_id
                 };
        [JLGHttpRequest_AFN PostWithApi:@"v2/quality/getReplyMessageList" parameters:body success:^(id responseObject) {
            
            self.replyList = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            //回复
            ReplyArray = [NSMutableArray array];
            ReplyArray = responseObject[@"list"];
            //已收到头像
            HadReciveArr = [NSMutableArray array];
            HadReciveArr = responseObject[@"members"];
            
            //未收到头像
            UnReciveArr = [NSMutableArray array];
            UnReciveArr = responseObject[@"unrelay_members"];
            hadRecive = responseObject[@"is_replyed"];
            _ChatMsgArray = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            self.detailMemeberModel = [JGJNotifyDetailMembersModel new];
            self.detailMemeberModel = [JGJNotifyDetailMembersModel mj_objectWithKeyValues:responseObject];
            self.memberModels = [NSArray array];
            self.memberModels = self.detailMemeberModel.members;
            self.ReciveMembersModelArr = [NSArray array];
            self.ReciveMembersModelArr = self.detailMemeberModel.unrelay_members;
            
            [_MainCollectionview.mj_header endRefreshing];
            [_MainCollectionview reloadData];
            
            [TYShowMessage hideHUD];
            
            if (self.replyChat) {
                
                [self ScrollBottm];
            }
            
        }failure:^(NSError *error) {
            
            [TYShowMessage hideHUD];
            [_MainCollectionview.mj_header endRefreshing];
        }];
        
        
    }
}

-(void)GetNetDatamasgID:(NSString *)msg_id Action:(NSString *)actionType AndReplyext:(NSString *)text{
    
    self.replyChat = YES;
    NSDictionary *body;
    
    if ([actionType isEqualToString:@"replyMessage"]) {
        
//        if (text.length <=0) {
//            
//            return;
//        }
#pragma mark - 日志回复HTTP  222
        
        if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
            NSString *keyStr;
            //以前一直是id现在没法兼容  聊天室进入会改成msg_id
            keyStr = _chatRoomGo?@"msg_id":@"id";
            
            body = @{
                     keyStr:_jgjChatListModel.msg_id?:@"",
                     @"reply_text":text?:@"",
                     @"reply_uid":self.jgjChatListModel.reply_uid?:@"",
                     };
            
            JGJQualityReplyRequestModel *replyRequest = [JGJQualityReplyRequestModel mj_objectWithKeyValues:body];
            
            self.replyRequest = replyRequest;
            
            [self sendMessageInfos:nil];
            
//            [TYLoadingHub showLoadingWithMessage:nil];
//
//            [JLGHttpRequest_AFN PostWithApi:@"/pc/log/replyMessage" parameters:body success:^(id responseObject) {
//
//                [JGJHistoryText saveWithKey:@"sendDetail" andContent:@""];
//
//                self.chatInputView.placeholder = @"请输入回复内容";
//                //                [self.chatInputView resignFirstResponder];
//                self.jgjChatListModel.reply_uid = nil;
//
//                [_MainCollectionview reloadData];
//
//                [self HadRecivemasgID:_jgjChatListModel];
//
//                [TYLoadingHub hideLoadingView];
//
//            }failure:^(NSError *error) {
//                [TYShowMessage hideHUD];
//                self.jgjChatListModel.reply_uid = nil;
//                [TYLoadingHub hideLoadingView];
//
//            }];
        }else{
            
            body = @{
                     @"msg_id":self.jgjChatListModel.msg_id?:@"",
                     @"reply_text":text?:@"",
                     @"group_id":self.jgjChatListModel.group_id?:@"",
                     @"reply_type":self.jgjChatListModel.msg_type?:@"",
                     @"reply_uid":self.jgjChatListModel.reply_uid?:@"",
                     @"class_type":self.jgjChatListModel.class_type?:@"",
                     @"msg_src":@"",
                     @"bill_id":@"",
                     @"statu":@"",
                     @"is_rect":@"",
                     };
            
            JGJQualityReplyRequestModel *replyRequest = [JGJQualityReplyRequestModel mj_objectWithKeyValues:body];
            
            self.replyRequest = replyRequest;
            
             [self sendMessageInfos:nil];
            
//            [TYLoadingHub showLoadingWithMessage:nil];
//
//            [JLGHttpRequest_AFN PostWithApi:@"v2/quality/replyMessage" parameters:body success:^(id responseObject) {
//
//                [JGJHistoryText saveWithKey:@"sendDetail" andContent:@""];
//                self.chatInputView.placeholder = @"请输入回复内容";
//
//                self.jgjChatListModel.reply_uid = nil;
//
//                [_MainCollectionview reloadData];
//                [self HadRecivemasgID:_jgjChatListModel];
//
//                [TYLoadingHub hideLoadingView];
//
//
//            }failure:^(NSError *error) {
//
//                self.jgjChatListModel.reply_uid = nil;
//                [TYLoadingHub hideLoadingView];
//
//            }];
            
        }
        
        
    }else{
        
        
        
        if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
            NSString *keyStr;
            
            keyStr = _chatRoomGo?@"msg_id":@"id";
            
            body = @{
                     keyStr:msg_id
                     };
            //   v2/quality/requestMessage 这个也是 说要改回去
            [TYLoadingHub showLoadingWithMessage:nil];
            
            [JLGHttpRequest_AFN PostWithApi:@"pc/log/receiveHandle" parameters:body success:^(id responseObject) {
                ImageArray = [NSMutableArray array];
                ImageArray = ReplyArray;
                HadReciveArr = [NSMutableArray array];
                HadReciveArr = responseObject[@"members"];
                
                self.detailMemeberModel = [JGJNotifyDetailMembersModel mj_objectWithKeyValues:responseObject];
                self.memberModels = [NSArray array];
                self.memberModels = self.detailMemeberModel.members;
                //                [TYShowMessage hideHUD];
                [_MainCollectionview reloadData];
                [TYLoadingHub hideLoadingView];
                
                
            }failure:^(NSError *error) {
                //                [TYShowMessage hideHUD];
                [TYLoadingHub hideLoadingView];
                
            }];
        }else{
            
            body = @{
                     @"msg_id":msg_id
                     };
            //   v2/quality/requestMessage 这个也是 说要改回去
            [TYLoadingHub showLoadingWithMessage:nil];
            
            [JLGHttpRequest_AFN PostWithApi:@"v2/quality/requestMessage" parameters:body success:^(id responseObject) {
                ImageArray = [NSMutableArray array];
                ImageArray = ReplyArray;
                HadReciveArr = [NSMutableArray array];
                HadReciveArr = responseObject[@"members"];
                
                self.detailMemeberModel = [JGJNotifyDetailMembersModel mj_objectWithKeyValues:responseObject];
                self.memberModels = [NSArray array];
                self.memberModels = self.detailMemeberModel.members;
                //                [TYShowMessage hideHUD];
                [_MainCollectionview reloadData];
                [TYLoadingHub hideLoadingView];
                
                
            }failure:^(NSError *error) {
                //                [TYShowMessage hideHUD];
                [TYLoadingHub hideLoadingView];
                
            }];
            
        }
        
    }
    
}

#pragma mark - JGJSendMessageViewDelegate

- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr {
    
    if ([NSString isEmpty:self.replyRequest.reply_text]) {
        
        [self GetNetDatamasgID:masg_id Action:@"replyMessage" AndReplyext:self.replyRequest.reply_text];
        
    }else {
        
        [self.chatInputView sendMessage];
    }
    
}

#pragma mark - 回复图片

- (void)sendMessageInfos:(NSArray *)imagesArr  {
    
    //收回键盘
    [self.view endEditing:YES];
    
    self.chatInputView.placeholder = @"请输入回复内容";
    
    if ([NSString isEmpty:self.replyRequest.reply_text] && self.imagesArray.count == 0) {
        
        return;
    }
    
    NSDictionary *parameters = [self.replyRequest mj_keyValues];
    
    NSString *api = @"";
    
    if ([self.jgjChatListModel.msg_type isEqualToString:@"log"]) {
        
        api = @"pc/log/replyMessage";
        
    }else if ([self.jgjChatListModel.msg_type isEqualToString:@"notice"]) {
        
        
        api = @"v2/quality/replyMessage";
    }
    
    if ([NSString isEmpty:api]) {
        
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN uploadImagesWithApi:api parameters:parameters imagearray:self.imagesArray success:^(id responseObject) {
        
        [JGJHistoryText saveWithKey:@"sendDetail" andContent:@""];
        
        self.chatInputView.placeholder = @"请输入回复内容";
        
        self.jgjChatListModel.reply_uid = nil;
        
        [_MainCollectionview reloadData];
        
        [self HadRecivemasgID:_jgjChatListModel];
        
        [self.imagesArray removeAllObjects];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        self.jgjChatListModel.reply_uid = nil;
        
        [TYLoadingHub hideLoadingView];
        
        [self.imagesArray removeAllObjects];
        
    }];
}

-(void)ClickButton:(UIButton *)sender
{    switch (sender.tag) {
    case 0:
        break;
    case 1:
        [self GetNetDatamasgID:masg_id Action:@"requestMessage" AndReplyext:@""];
        
        
        break;
        
    default:
        break;
}
    
    if (sender.tag == 1) {
        
        
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (self.jgjChatListModel.chatListType ==JGJChatListNotice) {
        self.navigationItem.title = @"通知详情";
        
    }else if (self.jgjChatListModel.chatListType == JGJChatListSafe)
    {
        self.navigationItem.title = @"安全详情";
        
    }else if (self.jgjChatListModel.chatListType == JGJChatListLog){
        
        //        self.navigationItem.title = @"施工日志详情";
        self.title = [_jgjChatListModel.cat_name stringByAppendingString:@"详情"];

    }else if (self.jgjChatListModel.chatListType == JGJChatListQuality){
        
        self.navigationItem.title = @"质量详情";
        
    }else{
        
        self.navigationItem.title = @"详情";
 
    }
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}




-(void)ScrollBottm
{
    [self.view endEditing:YES];
    if (ReplyArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ReplyArray.count-1 inSection:10];
        [_MainCollectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
    
    
}




- (NSURL *)photoBrowser:(HJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,self.jgjChatListModel.msg_src[index]];
    
    return [NSURL URLWithString:baseUrl];
}

//回复
-(void)ClickDetailLeftnumberButton:(UIButton *)sender
{
    //示例数据不能点击
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        return;
    }
    [self.chatInputView.textView becomeFirstResponder];
}

//收到
- (void)ClickDetailRightnumberButton:(UIButton *)sender
{
    //    rightcell.reciveButton.titleLabel.textColor = AppFont999999Color;
    
    //示例数据不能点击
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        return;
    }
    [self GetNetDatamasgID:masg_id Action:@"requestMessage" AndReplyext:@""];
    [self HadRecivemasgID:_jgjChatListModel];
    
}

-(void)ClickDetailLeftButton:(UIButton *)sender
{
    _unRecived = NO;
    
    [self HadRecivemasgID:_jgjChatListModel];
}
-(void)ClickDetailRightButton:(UIButton *)sender
{
    _unRecived = YES;
    
    self.memberModels = [NSArray array];
    HadReciveArr = UnReciveArr;
    self.memberModels = self.ReciveMembersModelArr;
    [_MainCollectionview reloadData];
}
-(void)getimagSizeWithUrl:(NSString *)urlstr
{
    
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,urlstr]]]];
    imagSizel = image.size;
    [_MainCollectionview reloadData];
}

-(CGSize)retrunImagesize:(CGSize)size
{
    NSArray *imageSizes = @[@(size.width), @(size.height)];
    
    CGSize maxSize = CGSizeMake(TYGetUIScreenWidth*2/3, TYGetUIScreenWidth*2/3);
    
    CGSize imageSize = [JGJImage getFitImageSize:imageSizes maxImageSize:maxSize];
    
    scaleImagesize = imageSize;
    
    return imageSize;
    
}
- (void)loadRightView
{
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [releaseButton setTitle:@"更多" forState:UIControlStateNormal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
    releaseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [releaseButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    releaseButton.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    [releaseButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
}
-(void)releaseInfo:(UIButton *)button
{
//    JGJPlaceEditeView *editeview = [[JGJPlaceEditeView alloc]initWithFrame:CGRectMake(0, TYGetUIScreenHeight , TYGetUIScreenWidth, 160)];
//
//    editeview.delegate = self;
//    [editeview  ShowviewWithVC];
    
    [self showSheetView];
}

- (void)showSheetView{
    
    NSArray *buttons = @[@"修改", @"删除",@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:buttons buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        
        switch (buttonIndex) {
            case 0:{
                
                [weakSelf editeBuilderDaily];
            }
                
                break;
                
            case 1:{
                
                FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"工作日志删除后不能恢复，你确定要删除吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
                //    alert.tag = 1;
                [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
                
                [alert show];
            }
                
                break;
                
            default:
                break;
        }
        
    }];
    
    [sheetView showView];
}

- (NSArray<PopoverAction *> *)JGJChatActions {
    // 扫一扫 action
    PopoverAction *sweepAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"-more_details"] title:@"修改" handler:^(PopoverAction *action) {
        [self editeBuilderDaily];
    }];
    
    PopoverAction *addFriendAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"-more_recorder"] title:@"删除" handler:^(PopoverAction *action) {
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"工作日志删除后不能恢复，你确定要删除吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
        //    alert.tag = 1;
        [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
        
        [alert show];
        
    }];
    return @[sweepAction, addFriendAction];
    
}
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 168) {
        if (buttonIndex == 1) {
            
            [self setIndexProListModel:self.workProListModel];
        }
    }else{
        if (buttonIndex == 1) {
            [self deleteBuilderDaildy];
        }
    }
    alertView.delegate = nil;
    alertView = nil;
}
#pragma mark - 删除施工日志
-(void)deleteBuilderDaildy
{
    
    NSMutableDictionary *paramDIc = [NSMutableDictionary dictionary];
    if (_chatRoomGo) {
        [paramDIc setObject:_jgjChatListModel.msg_id?:@"" forKey:@"msg_id"];
        
    }else{
        [paramDIc setObject:_jgjChatListModel.id?:@"" forKey:@"id"];
        
        
    }
    
    [JLGHttpRequest_AFN PostWithApi:@"/pc/log/delLog" parameters:paramDIc success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        [self freshDataList];
        [TYShowMessage showSuccess:@"删除成功"];
 
    }];
}

#pragma mark - 编辑施工日志
-(void)editeBuilderDaily
{
    JGJBuilderDiaryViewController *builderDailyVC = [JGJBuilderDiaryViewController new];
    builderDailyVC.chatRoomGo = _chatRoomGo;
    JGJSendDailyModel *model = [JGJSendDailyModel new];
    
    model.msg_srcs = _jgjChatListModel.msg_src;
    
    NSMutableDictionary *parmadic = [NSMutableDictionary dictionary];
    for (int index = 0; index < _logDeailModel.element_list.count ; index ++) {
        if ([[_logDeailModel.element_list[index] element_type] isEqualToString:@"dateframe"]) {
            if ([[_logDeailModel.element_list[index] position] isEqualToString:@"1"]) {
                [parmadic setObject:[_logDeailModel.element_list[index] element_value] forKey:[[_logDeailModel.element_list[index] element_key] stringByAppendingString:@"start"]];
                
            }else if ([[_logDeailModel.element_list[index] position] isEqualToString:@"2"]){
                [parmadic setObject:[_logDeailModel.element_list[index] element_value] forKey:[[_logDeailModel.element_list[index] element_key] stringByAppendingString:@"end"]];
            }
            [parmadic setObject:[[[_logDeailModel.element_list[index] element_value] stringByAppendingString:@","] stringByAppendingString:[_logDeailModel.element_list[index] element_value]] forKey:[_logDeailModel.element_list[index] element_key]];
            
        }else if ([[_logDeailModel.element_list[index] element_type] isEqualToString:@"select"])
        {
            [parmadic setObject:[_logDeailModel.element_list[index] select_id] forKey:[_logDeailModel.element_list[index] element_key]];
            [parmadic setObject:[_logDeailModel.element_list[index] element_value] forKey:[[_logDeailModel.element_list[index] element_key] stringByAppendingString:@"name"]];
            
        }else if ([[_logDeailModel.element_list[index] element_type] isEqualToString:@"date"])
        {
            
            //            model.time = [_logDeailModel.element_list[index] element_value];
            [parmadic setObject:[_logDeailModel.element_list[index] element_value] forKey:[_logDeailModel.element_list[index] element_key]];
            
            
        }else if ([[_logDeailModel.element_list[index] element_type] isEqualToString:@"weather"]){
            model.weat_am = _weatherModel.weat_am;
            model.weat_pm = _weatherModel.weat_pm;
            model.temp_am = _weatherModel.temp_am;
            model.temp_pm = _weatherModel.temp_pm;
            model.wind_am =_weatherModel.wind_am;
            model.wind_pm = _weatherModel.wind_pm;
        }
        else{
            [parmadic setObject:[_logDeailModel.element_list[index] element_value] forKey:[_logDeailModel.element_list[index] element_key]];
        }
    }
    
    model.car_id = _jgjChatListModel.cat_id;
    model.techno_quali_log = _jgjChatListModel.techno_quali_log;
    
    JGJGetLogTemplateModel *getLogTemplateModel = [[JGJGetLogTemplateModel alloc] init];
    getLogTemplateModel.cat_name = _jgjChatListModel.cat_name;
    
    builderDailyVC.GetLogTemplateModel = getLogTemplateModel;
    builderDailyVC.eidteBuilderDaily = YES;
    builderDailyVC.receiver_uid = _receiver_uid;
    builderDailyVC.WorkCicleProListModel = _workProListModel;
    builderDailyVC.sendDailyModel = model;
    builderDailyVC.chatMsgListModel = _jgjChatListModel;
    builderDailyVC.logEditeModel = _logDeailModel;
    builderDailyVC.MoreparmDic = parmadic;
    
    //接收人
    builderDailyVC.logDetailModel = _logDeailModel;
    
    [self.navigationController pushViewController:builderDailyVC animated:YES];
}

-(void)clickdeleteButton
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"工作日志删除后不能恢复，你确定要删除吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
    //    alert.tag = 1;
    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
    
    [alert show];
    
    
}
-(void)clickEditeButton
{
    [self editeBuilderDaily];
}

- (void)freshDataList {
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[JGJChatListBaseVc class]]) {
            
            JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)vc;
            
            if (![self isKindOfClass:NSClassFromString(@"JGJChatListAllVc")]) {
                
                [baseVc.tableView.mj_header beginRefreshing];
                
                break;
            }
            
        }
        
    }
    
}
#pragma 点击切换项目
-(void)tapFromLable
{
//    //    [self setIndexProListModel:self.workProListModel];
//    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"你确定要切换到该项目首页吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
//    alert.tag = 168;
//    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
//
//    [alert show];
    
    [self setIndexProListModel:self.workProListModel];
}

- (void)setIndexProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
//    __weak typeof(self) weakSelf = self;
//
//    [JGJChatGetOffLineMsgInfo http_gotoTheGroupHomeVCWithGroup_id:self.jgjChatListModel.group_id?:@"" class_type:self.jgjChatListModel.class_type?:@"" isNeedChangToHomeVC:YES isNeedHttpRequest:YES success:^(BOOL isSuccess) {
//
//        [TYShowMessage showSuccess:@"已切换到该项目首页，你可以在首页进行各模块的使用"];
//
//        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//
//    }];
    
    JGJSwitchMyGroupsTool *tool = [JGJSwitchMyGroupsTool switchMyGroupsTool];
    
    [tool switchMyGroupsWithGroup_id:self.jgjChatListModel.group_id?:@"" class_type:self.jgjChatListModel.class_type?:@"" targetVc:self];
    
}
-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    return responseJSON;
}
-(void)ClicknameLable
{
    
    if (self.workProListModel.isClosedTeamVc) {
        return;
    }
    if (self.jgjChatListModel) {
        
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        if ( [NSString isEmpty:self.jgjChatListModel.uid]) {
            perInfoVc.jgjChatListModel.uid = self.jgjChatListModel.msg_sender;
        }else{
            perInfoVc.jgjChatListModel.uid = self.jgjChatListModel.uid;
        }
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
    
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    if (section == 1) {
        return 5;
    }else if (section == 8)
    {
        
        return 10;
    }
    return 0;
    
}

- (void)taskDetailCell:(JGJTaskDetailCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index{
    
    [self.view endEditing:YES];
    
    [JGJCheckPhotoTool browsePhotoImageView:cell.listModel.msg_src selImageViews:imageViews didSelPhotoIndex:index];
    
}

- (void)taskDetailCell:(JGJTaskDetailCell *)cell  didSelectedUserInfoModel:(JGJQualityDetailReplayListModel *)userInfoModel {
    
    [self clickDetailPublishManInfo];
}

#
#pragma mark - 发送emoji表情
-(void)sendEmoji:(UIButton *)sender
{
    _emojiButton.selected = !sender.selected;
    
}

- (JGJSendMessageView *)sendMessageView {
    
    if (!_sendMessageView) {
        
        _sendMessageView = [JGJSendMessageView sendMessageView];
        
        _sendMessageView.delegate = self;
        
        TYWeakSelf(self);
        _sendMessageView.sendMessageBlock = ^(JGJSendMessageView *sendMessageView, NSString *changeText) {
            
            
            //            strongself.requstModel.reply_text = changeText;
        };
    }
    
    return _sendMessageView;
}

#pragma mark - JGJChatInputViewDelegate

- (void)changeHeight:(JGJChatInputView *)chatInputView addHeight:(CGFloat )addHeight{
    
    if (addHeight < 10) {
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(ChatInputViewH);
            
        }];
        
    }else {
        
        
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(ChatInputViewH + addHeight);
            
        }];
        
    }
    
    [self.chatInputView layoutIfNeeded];
    
    
}

#pragma mark - 发送图片
- (void)sendPic:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo {
    
    self.replyRequest.reply_text = chatInputView.textView.text;
    
    [self.imagesArray removeAllObjects];
    
    [self.sheet showInView:self.view];
}

#pragma mark - 发送文字

- (void)sendText:(JGJChatInputView *)chatInputView text:(NSString *)text {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        return;
        
    }
    
    [self.chatInputView.textView resignFirstResponder];
    
    [self GetNetDatamasgID:masg_id Action:@"replyMessage" AndReplyext:text];
    
    rightcell.hadClick = @"1";
    
}

- (JGJChatInputView *)chatInputView {
    
    if (!_chatInputView) {
        
        _chatInputView = [[JGJChatInputView alloc] init];
        
//        _chatInputView.chatInputViewKeyBoardType = JGJChatInputViewKeyBoardChatType;
        
        _chatInputView.chatInputViewKeyBoardType = JGJChatInputViewKeyBoardChangeStatusType;
        
        _chatInputView.delegate = self;
        
        _chatInputView.placeholder = @"请输入回复内容";
        
        __weak typeof(self) weakSelf = self;
        
        _chatInputView.emojiKeyboardBlock = ^(JGJChatInputView *chatInputView) {
            
            [UIView animateWithDuration:0.25 animations:^{
                //显示
                
                [weakSelf.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.bottom.mas_equalTo(weakSelf.view).offset(-EmotionKeyboardHeight);
                    
                }];
                
                [weakSelf.chatInputView layoutIfNeeded];
                
            }completion:^(BOOL finished) {
                
                
            }];
        };
        
    }
    
    return _chatInputView;
}
#pragma mark - 跳转链接地址

-(void)openUrlWithWebViewAndUrl:(NSURL *)url
{
    JGJMyWebviewViewController *webView = [[JGJMyWebviewViewController alloc]init];
    webView.url = url;
    [self.navigationController pushViewController:webView animated:YES];
    
}
#pragma mark - 点击发布者头像
- (void)clickDetailPublishManInfo
{
    if (_jgjChatListModel) {
        
        JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
        perInfoVc.jgjChatListModel.group_id = _workProListModel.group_id;
        perInfoVc.jgjChatListModel.class_type = _workProListModel.class_type;
        if ( [NSString isEmpty:_jgjChatListModel.uid]) {
            perInfoVc.jgjChatListModel.uid = _jgjChatListModel.msg_sender;
        }else{
            perInfoVc.jgjChatListModel.uid = _jgjChatListModel.uid;
        }
        [self.navigationController pushViewController:perInfoVc animated:YES];
    }
}

-(void)changeText:(JGJChatInputView *)chatInputView text:(NSString *)text
{
    
    
}

- (JGJQualityReplyRequestModel *)replyRequest {
    
    if (!_replyRequest) {
        
        _replyRequest = [[JGJQualityReplyRequestModel alloc] init];
    }
    
    return _replyRequest;
}

@end

