//
//  JGJTaskViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskViewController.h"
#import "JGJHeadCollectionViewCell.h"
#import "JGJDescriptionCollectionViewCell.h"
#import "JGJImageCollectionViewCell.h"
#import "JGJNewsCollectionViewCell.h"
#import "JGJHadReciveCollectionViewCell.h"
#import "JGJNewDetailCollectionViewCell.h"
#import "JGJGetViewFrame.h"
#import "JGJWaitTaskVc.h"
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
#import "JGJBuilderDiaryViewController.h"
#import "JGJHoldCollectionViewCell.h"
#import "NSString+Extend.h"
#import "UIImageView+WebCache.h"
#import "JGJBuilderDiaryViewController.h"
#import "JGJconstrunCollectionViewCell.h"
#import "JGJCustomProInfoAlertVIew.h"
#import "JGJConstructDetailCollectionViewCell.h"
#import "PopoverView.h"
#import "JGJTaskRightFromCollectionViewCell.h"
#import "JGJTaskRootVc.h"
#import "JGJTaskTypeCollectionViewCell.h"
#import "JGJFromProCollectionViewCell.h"
#import "JGJEiditeTaskPeopleCollectionViewCell.h"
#import "JGJTaskPrincipalVc.h"
#import "JGJTaskTracerVc.h"
#import "JGJHistoryText.h"
#import "JGJTabBarViewController.h"
#import "JGJCheckPhotoTool.h"
#import "JGJImage.h"
#pragma mark - 修改键盘
#import "JGJChatInputView.h"

#import "JGJSendMessageView.h"

#import "JGJMyWebviewViewController.h"
#import "JGJCusActiveSheetView.h"
#import "CFRefreshStatusView.h"

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

static NSString *taskCellid     = @"taskindentifer";

static NSString *taskrightCellid     = @"taskrightCellindentifer";

static NSString *taskTypecellid     = @"tasktypeCellidentifer";

static NSString *fromproCellID     = @"fromProindentifer";

static NSString *editeTaskCellID     = @"editeTaskCellID";

static NSString *systemNoticeCellId     = @"systemNoticeCellId";

static NSString *JGJTaskDetailCellID     = @"JGJTaskDetailCell";

//

#define MainScreen    [UIScreen mainScreen].bounds.size

#define NumRow    1

//#define ChatInputViewH 56.5

@interface JGJTaskViewController ()

<UICollectionViewDelegate,

UICollectionViewDataSource,

UITextViewDelegate,

HJPhotoBrowserDelegate,

UITextFieldDelegate,

ClickreciveButtondelesgate,

ClickDetailButtondelegate,

clickTaskcellButtondelegate,

tapCollectionDelegate,

tapProdelegate,

ClickHeadWaitDodelegate,

JGJTaskPrincipalVcDelegate,

FDAlertViewDelegate,

JGJNewDetailCollectionViewCellDelegate,

JGJChatInputViewDelegate,

JGJSendMessageViewDelegate,

JGJTaskDetailCellDelegate


>
{
    JGJDescriptionCollectionViewCell *Descell;
    
    UIView *topView;
    
    float Keyheight;
    
    NSMutableArray *ImageArray;
    
    NSString *masg_id;
    
    NSMutableArray *ReplyArray;
    
    NSMutableArray *HadReciveArr;
    
    UILabel *departlable;
    
    NSArray *_ChatMsgArray;
    
    UIButton *replybutton;
    
    NSMutableArray *UnReciveArr;
    
    NSString *hadStr;
    
    JGJReciveHeadCollectionViewCell *recivecell;
    
    CGSize imagSizel;
    
    CGSize scaleImagesize;
    
    //    JGJRightFromCollectionViewCell *rightcell;
    
    JGJTaskRightFromCollectionViewCell *rightcell;
}
@property(nonatomic ,assign)CGFloat textFieldOldHeight;

@property(nonatomic ,strong)UITextView *TextView;

@property(nonatomic ,assign)UIButton *HadButton;

@property (nonatomic, strong) NSArray *modelsArray;

@property (nonatomic, strong) UIView  *HoldView;

@property(nonatomic ,strong)UITextField *NTextView;

@property (nonatomic, assign) BOOL ReplyState;

@property (nonatomic, strong)JGJNotifyDetailMembersModel *detailMemeberModel;

@property (nonatomic, strong) NSArray *ReciveMembersModelArr;

@property (nonatomic, strong) NSArray *memberModels;

@property (nonatomic, assign) BOOL joinMan;//是不是参与者 不是的画就是负责人

@property (nonatomic, strong) UIButton *emojiButton;

//@property (nonatomic, strong) JGJChatInputView *chatInputView;

@property (nonatomic, strong) JGJSendMessageView *sendMessageView;

//我是否是负责人
@property (nonatomic, assign) BOOL is_my_pri;

@property (nonatomic, strong) NSMutableArray *replyList;

@property (nonatomic, strong) JGJQualityReplyRequestModel *replyRequest;

@end



@implementation JGJTaskViewController

-(void)sendMessageView:(JGJSendMessageView *)messageView sendMessageViewButtonType:(JGJSendMessageViewType)buttonType
{

}
-(UIImage *)photoBrowser:(HJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@""];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTaskView];
    
    
    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
}
-(void)setTaskView
{
    
    [self.MainCollectionview registerNib:[UINib nibWithNibName:@"JGJTaskRightFromCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:taskrightCellid];
    
    [self.MainCollectionview registerNib:[UINib nibWithNibName:@"JGJTaskTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:taskTypecellid];
    
    [self.MainCollectionview registerNib:[UINib nibWithNibName:@"JGJFromProCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:fromproCellID];
    
    [self.MainCollectionview registerNib:[UINib nibWithNibName:@"JGJEiditeTaskPeopleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:editeTaskCellID];
    
    [self.MainCollectionview registerNib:[UINib nibWithNibName:JGJTaskDetailCellID bundle:nil] forCellWithReuseIdentifier:JGJTaskDetailCellID];

    
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.MainCollectionview];
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        self.TextView.userInteractionEnabled = NO;
        
        self.NTextView.userInteractionEnabled = NO;
    }
    ImageArray = [NSMutableArray array];
    
    if ( !self.jgjChatListModel.IsCloseTeam) {
        
        if (![self.jgjChatListModel.task_status isEqualToString:@"1"]) {
            
            
        }else{
            
            [self.MainCollectionview setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70)];
            
        }
    }else{
        [self.view addSubview:self.closeTeamImage];
    }
    
    _NTextView.text = [JGJHistoryText readWithkey:@"sendtask"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideAndHidtextfile:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShowAndshowtextfile:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    masg_id = self.jgjChatListModel.msg_id;

    [self taskEmojiKeyBoard];
    
    self.maxImageCount = 9;
    
//    [TYNotificationCenter addObserver:self selector:@selector(clickUrl:) name:JLGcontentOpenUrl object:nil];

}
-(void)clickUrl:(NSNotification *)notification
{
    NSDictionary *urlDic = notification.object;
    JGJMyWebviewViewController *webVc = [[JGJMyWebviewViewController alloc]init];
    webVc.url = urlDic[@"url"];
    [self.navigationController pushViewController:webVc animated:YES];
    
}
#pragma mark - 更换键盘
-(void)taskEmojiKeyBoard{
    

    [self.view addSubview:self.chatInputView];
    
    
    
}


-(void)keyboardWillHideAndHidtextfile:(NSNotification *)obj
{
//    if ([NSString isEmpty: self.chatInputView.textView.text ]) {
//        self.chatInputView.placeholder = @"请输入回复内容";
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
        
//        [self.MainCollectionview mas_updateConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.mas_equalTo(self.view).offset(-yEndOffset);
//            
//        }];
//        
//        [self.MainCollectionview layoutIfNeeded];
        
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
    [ IQKeyboardManager sharedManager].enable = YES;
    [JGJHistoryText saveWithKey:@"sendtask" andContent:_TextView.text?:@""];

}


-(void)clickColeection
{
    [self hiddenEmojiKeyboard];
    
    [self.view endEditing:YES];
    if (topView) {
        [topView removeFromSuperview];
        topView = nil;
        _TextView.text = @"";
        [_TextView removeFromSuperview];
        _TextView = nil;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //头部
        if (indexPath.row == 0) {
            JGJHeadCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:headIdentifer forIndexPath:indexPath];
            cell.closeTeam = self.workProListModel.isClosedTeamVc;
            cell.delegate = self;
            cell.backgroundColor = AppFontfafafaColor;
            cell.model = self.jgjChatListModel;
            hadStr = self.jgjChatListModel.task_status;
            
            return cell;
        }else if (indexPath.row == 1){
            
            JGJTaskTypeCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:taskTypecellid forIndexPath:indexPath];
            cell.backgroundColor = AppFontfafafaColor;
            cell.model = self.jgjChatListModel;
            
            return cell;
      
        }
    }else if (indexPath.section == 1){
        Descell =[collectionView dequeueReusableCellWithReuseIdentifier:DesCriptionid forIndexPath:indexPath];
        Descell.taskType = YES;
        Descell.model = self.jgjChatListModel;
        return Descell;
        
    }else if(indexPath.section == 2){
        //大图
        JGJImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:Imagecellid forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.jgjChatListModel;
        
        if (self.jgjChatListModel.msg_src.count>0) {
            cell.Url_str = self.jgjChatListModel.msg_src[indexPath.row];
            
        }
        
        return cell;
        
    }else if(indexPath.section == 3){
        JGJFromProCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:fromproCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.jgjChatListModel = self.jgjChatListModel;
        cell.delegate = self;
        
        return cell;
    }else if(indexPath.section == 4){
        
        //来自
        rightcell =[collectionView dequeueReusableCellWithReuseIdentifier:taskrightCellid forIndexPath:indexPath];
        rightcell.isClosedTeamVc = self.workProListModel.isClosedTeamVc;//是否已关闭项目i
        
        rightcell.jgjChatListModel = self.jgjChatListModel;
        rightcell.delegate = self;
        rightcell.taskType = YES;
        hadStr = self.jgjChatListModel.task_status;
        if ([self.jgjChatListModel.task_status intValue] ) {
            rightcell.replyButton.hidden = YES;
 
        }
        return rightcell;
    

        
    }else if(indexPath.section == 5){
        JGJHoldCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:HoldCellid forIndexPath:indexPath];
        
        return cell;
        
    }

    else if(indexPath.section == 6){
        //已收到lab了
        
        JGJHadReciveCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:hadreciveLableid forIndexPath:indexPath];
        cell.delegate = self;
        cell.HadStr = @"他们已收到：";
        cell.taskType = YES;
        [cell.hadRecive setTitle:@"负责人" forState:UIControlStateNormal];
        [cell.DontReply setTitle:@"参与者" forState:UIControlStateNormal];
        cell.numpepole =[NSString stringWithFormat:@"%lu",(unsigned long)UnReciveArr.count];
        //        [cell setTaskTypeButton];
        
        
        if (_buttonType == clickPrincipalType) {
           cell.DontReply.selected = NO;
            cell.hadRecive.selected = YES;
            cell.rightlable.hidden = YES;
            cell.leftlable.hidden = NO;
        }else{
            cell.DontReply.selected = YES;
            cell.hadRecive.selected = NO;
            cell.rightlable.hidden = NO;
            cell.leftlable.hidden = YES;
        }
        
        return cell;

           }

    else if(indexPath.section ==7 ){
        //已收到lab了
        
        recivecell = [collectionView dequeueReusableCellWithReuseIdentifier:reciveHead forIndexPath:indexPath];

        if ((indexPath.row == self.memberModels.count && ([self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]] || self.is_my_pri))) {
            JGJEiditeTaskPeopleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:editeTaskCellID forIndexPath:indexPath];
            if (self.memberModels.count > 0) {
                cell.bottomDistance.constant = 0;
            }else{
                cell.bottomDistance.constant = 7;
            }
            if (_buttonType == clickPrincipalType ) {
   
                if ([self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                    
                        cell.editeImageview.image = [UIImage imageNamed:@"editePeopletask"];
                        
                    }else{
                        
                        cell.editeImageview.image = nil;
                    }
            }else{
                
                if ([self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]] || _is_my_pri) {
                    cell.editeImageview.image = [UIImage imageNamed:@"addtaskJoin"];
                }else{
                    
                    cell.editeImageview.image = nil;
                }
                
            }
            return cell;
            //切换项目负责人
        }else{
            
            
            if (self.memberModels.count) {
                recivecell.headImageView.layer.masksToBounds = YES;
                recivecell.headImageView.layer.cornerRadius = JGJCornerRadius;
                if (self.memberModels.count != indexPath.row) {
                recivecell.detailMemeberModel = self.memberModels[indexPath.row];
                }

                recivecell.headButton.hidden = NO;
                recivecell.holdLable.hidden = YES;
                recivecell.headImageView.hidden = YES;
            }else{
                recivecell.headImageView.layer.masksToBounds = YES;
                recivecell.headImageView.layer.cornerRadius = JGJCornerRadius;
                recivecell.headButton.hidden = YES;
                recivecell.holdLable.hidden = NO;
                recivecell.headImageView.hidden = NO;
            }
    
            
        }
        
 
        return recivecell;

        
        
    }
    else if(indexPath.section ==8 ){

        JGJDepartLableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:departcellid forIndexPath:indexPath];
        cell.color = AppFontdbdbdbColor;
        return cell;
    }else if (indexPath.section == 9){

        JGJQualityDetailReplayListModel *listModel = self.replyList[indexPath.row];

        if (ReplyArray.count) {
            if ([ReplyArray[indexPath.row][@"is_system_reply"]?:@"0" intValue]) {
                
                JGJDetailNoticesCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:systemNoticeCellId forIndexPath:indexPath];
                
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
        
        cell.delegate = self;
        
        cell.NameLbale.tag = indexPath.row;
        
        if (ReplyArray) {
            
            cell.NameLbale.textColor = AppFont628ae0Color;
            
            cell.DataArray = ReplyArray[indexPath.row];
            
        }
        return cell;
        
    }
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (self.jgjChatListModel.task_finish_time.length || [self.jgjChatListModel.task_level intValue] > 1) {
                
                return 2;
            }

            return NumRow;
            break;
        case 1:
            if ([NSString isEmpty:self.jgjChatListModel.msg_text]) {
                return 0;
            }
            return NumRow;
            break;
        case 2:
            if (self.jgjChatListModel.msg_src.count <= 0) {
                
                return 0;
            }
            return 1;
            break;

        case 3:
            return 1;
   
            break;
        case 4:
            return 0;
            break;
        case 5:
            return NumRow;
            break;
 
        case 6:
            if (!HadReciveArr.count) {
                return 1;
                
            }else{
                return NumRow;
            }
            break;
        case 7:

            if (_buttonType == clickPrincipalType) {
                
                if (!self.memberModels.count &&![self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]){
                    
                    return 1;
                    
                }else if ([self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]]) {
                    
                    return self.memberModels.count + 1;
                    
                }
                
            }else {
                
                if ([self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]] || _is_my_pri) {
                    
                    return self.memberModels.count + 1;
                    
                }
            }
            return self.memberModels.count ;
            break;
            /*
             case 4:
             return NumRow;
             break;
             */
        case 8:
            return NumRow;
            break;
        case 9:
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
-(void)getimagSizeWithUrl:(NSString *)urlstr
{
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,urlstr]]]];
    imagSizel = image.size;
    [self.MainCollectionview reloadData];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 1) {
                if (self.jgjChatListModel.task_finish_time.length || [self.jgjChatListModel.task_level intValue] > 1) {
                    return CGSizeMake(MainScreen.width, 25);
                }else{
                    return CGSizeZero;
                }
            }
            return CGSizeMake(MainScreen.width, 65);;
            break;
        case 1:
            return CGSizeMake(MainScreen.width, [self RowHeight:self.jgjChatListModel.msg_text?:@""] + 10);
            break;
        case 2:
            if (self.jgjChatListModel.msg_src.count == 1) {
                [self getimagSizeWithUrl:self.jgjChatListModel.msg_src[0]];
                return [self retrunImagesize:imagSizel];
            }else{
                if (self.jgjChatListModel.msg_src.count <=0) {
                    return CGSizeMake(TYGetUIScreenWidth,1);
                    
                }else{
                    return CGSizeMake(TYGetUIScreenWidth, ((self.jgjChatListModel.msg_src.count - 1)/3 +1)*((250.00/375*TYGetUIScreenWidth -5 * 4) /3 ) + ((self.jgjChatListModel.msg_src.count - 1)/3 +1)*3);
                }
            }
            break;
            
        case 3:
//            return CGSizeMake(MainScreen.width, 40);
            return CGSizeMake(MainScreen.width, [self RowSingerLineHeight:self.jgjChatListModel.from_group_name?:@"" andDepart_W:20] > 25?40:32);
            
            break;
            
        case 4:
            return CGSizeMake(MainScreen.width, 45);
            break;
        case 5:
            return CGSizeMake(MainScreen.width, 10);
            break;
            
        case 6:
            
            return CGSizeMake(MainScreen.width, 45);;
            break;
        case 7:
            
            
            
            if (!self.memberModels.count ) {
                if (![self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]] && !_is_my_pri) {
                    
                return CGSizeMake(TYGetUIScreenWidth, 35);
    
                }else{
                return CGSizeMake(35, 43);
                }
            }else{
                return CGSizeMake(35, 35);
            }
            break;
        case 8:
            return CGSizeMake(MainScreen.width, 1);
            break;
        case 9:
            if (!ReplyArray ||ReplyArray.count <= 0) {
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
                    
                    height = [self RowHeight:ReplyArray[indexPath.row][@"reply_text"]]+50;
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
    return 10;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    if (section == 2){
        if (self.jgjChatListModel.msg_src.count==1) {
            return UIEdgeInsetsMake(8.0f, 10.0f, 1.0f, TYGetUIScreenWidth - 10 -scaleImagesize.width);
        }else{
            
            if (self.jgjChatListModel.msg_src.count == 0) {
                
                return UIEdgeInsetsMake(0.0f, 0.0f, 2.0f, 0.0f);
                
            }else{
                
                return UIEdgeInsetsMake(8.0f, 0.0f, 2.0f, 0.0f);
                
                
            }
        }
    }else if (section == 5){
        return UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    }
    else if (section == 6){
        
         return UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 5.0f);
        
     }else if (section == 7){
         
         if (self.memberModels.count) {
             
        return UIEdgeInsetsMake(5.0f, 10.0f, 10.0f, 10.0f);
             
         }else{
             
        return UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
             
         }
     }
    
    return UIEdgeInsetsZero;
    
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        [TYShowMessage showPlaint:@"这些都是示范数据，无法操作，谢谢"];
        return;
    }
    if (self.jgjChatListModel.IsCloseTeam ) {
        return;
    }
    if (indexPath.section == 7) {
        if (![self.detailMemeberModel.pub_man.uid isEqualToString:[TYUserDefaults objectForKey:JLGUserUid]] && !self.memberModels.count && !_is_my_pri) {
            
            return;
        }
        if (indexPath.row >= self.memberModels.count) {
#pragma mark - 此处切换负责人和责任人
            if (_joinMan) {//参与者
                _taskType = editeJoinType;
                NSLog(@"点击了参与者");
                JGJTaskTracerVc *taskTracerVc = [[UIStoryboard storyboardWithName:@"JGJTask" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJTaskTracerVc"];
                taskTracerVc.taskEditeStatus = YES;
                JGJMyWorkCircleProListModel *model = [JGJMyWorkCircleProListModel new];
                model.class_type = self.jgjChatListModel.class_type;
                model.group_id = self.jgjChatListModel.group_id;
                model.group_name = self.jgjChatListModel.from_group_name;
                model.pro_name = self.jgjChatListModel.pro_name;
                taskTracerVc.proListModel = model;
                taskTracerVc.joinMembers = self.memberModels;
                
                taskTracerVc.taskTracerType = JGJTaskJoinTracerType;
                
                [self.navigationController pushViewController:taskTracerVc animated:YES];
                
            }else{//负责人
                NSLog(@"点击了负责人");
                _taskType = editePrincipalType;
                
                JGJTaskPrincipalVc *principalVc = [JGJTaskPrincipalVc new];
                
                principalVc.delegate = self;
                JGJMyWorkCircleProListModel *model = [JGJMyWorkCircleProListModel new];
                model.class_type = self.jgjChatListModel.class_type;
                model.group_id = self.jgjChatListModel.group_id;
                principalVc.proListModel = model;
                principalVc.memberSelType = JGJModifyTaskPrincipalType;
                
                if (self.memberModels.count > 0) {
                    
                    principalVc.principalModel = self.memberModels.firstObject;
                }
                
                
                [self.navigationController pushViewController:principalVc animated:YES];
            }
            
        }else{
            
            if (self.memberModels.count) {
                
                JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
                JGJSynBillingModel *model = self.memberModels[indexPath.row];
                perInfoVc.jgjChatListModel.uid = model.uid;
                JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
                JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
                memberModel.is_active = model.is_active;
                memberModel.real_name = model.real_name;
                memberModel.telphone = model.telphone;
                commonModel.teamModelModel = memberModel;
                /*
                perInfoVc.jgjChatListModel.uid = HadReciveArr[indexPath.row][@"uid"];
                JGJTeamMemberCommonModel *commonModel = [JGJTeamMemberCommonModel new];
                JGJSynBillingModel *memberModel = [JGJSynBillingModel new];
                memberModel.is_active = [NSString stringWithFormat:@"%@", HadReciveArr[indexPath.row][@"is_active"]];
                memberModel.real_name = HadReciveArr[indexPath.row][@"real_name"];
                memberModel.telphone = HadReciveArr[indexPath.row][@"telphone"];
                commonModel.teamModelModel = memberModel;
                */
                if ([memberModel.is_active isEqualToString:@"0"]) {
                    
                    [self handleClickedUnRegisterAlertViewWithCommonModel:commonModel];
                }else {
                    [self.navigationController pushViewController:perInfoVc animated:YES];
                }
            }
        }
    }
    else if (indexPath.section == 9) {
        if (indexPath.row > ReplyArray.count-1) {
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
        
        
    }else  if (indexPath.section == 2) {

        if (self.jgjChatListModel.msg_src.count == 1) {
            
        
        JGJImageCollectionViewCell *cell = (JGJImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSArray *imageArr = @[cell.ImageView];
        [JGJCheckPhotoTool browsePhotoImageView:self.jgjChatListModel.msg_src selImageViews:imageArr didSelPhotoIndex:0];
            }
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

//点击回复消息的名字Lable
-(void)JGJNewDetailCollectionViewCellTapNameLableAndIndexpathRow:(NSInteger)row
{
    JGJPerInfoVc *perInfoVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJPerInfoVc"];
    if ([ReplyArray[row][@"user_info"] isKindOfClass:[NSDictionary class]]) {
        
        perInfoVc.jgjChatListModel.uid = ReplyArray[row][@"user_info"][@"uid"];
        
    }
    perInfoVc.jgjChatListModel.group_id = self.workProListModel.group_id;
    perInfoVc.jgjChatListModel.class_type = self.workProListModel.class_type;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_ReplyState) {
        _TextView.text = @"";
        _TextView.textColor = AppFont333333Color;
        _ReplyState = NO;
    }
    
    return YES;
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

-(float)RowHeight:(NSString *)Str
{
    if ([NSString isEmpty:Str]) {
        Str = @"";
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
    //    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.1], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    CGSize size = [Str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height + 1;

    
}

#pragma mark - 获取回复列表
-(void)HadRecivemasgID:(JGJChatMsgListModel *)msgListModel{
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        return;
    }
    [self getTaskDetailwithMsgid:msgListModel.msg_id ?:@""];
    [self getreplyList:msgListModel.msg_id?:@""];

}

- (void)setDetailMemeberModel:(JGJNotifyDetailMembersModel *)detailMemeberModel {
    
    _detailMemeberModel = detailMemeberModel;
    [self.MainCollectionview reloadData];
    
}

-(void)GetNetDatamasgID:(NSString *)msg_id Action:(NSString *)actionType AndReplyext:(NSString *)text{
    
    self.replyChat = YES;
    if ([NSString isEmpty: text]) {
        text = @"";
    }
    NSDictionary *body= @{
                          @"id":msg_id?:@"",
                          @"reply_text":text?:@"",
                          @"reply_uid":![NSString isEmpty:self.jgjChatListModel.reply_uid]?self.jgjChatListModel.reply_uid?:@"":@""
                          };
    
    JGJQualityReplyRequestModel *replyRequest = [JGJQualityReplyRequestModel mj_objectWithKeyValues:body];
    
    self.replyRequest = replyRequest;
    
    [self sendMessageInfos:nil];
    
//    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskReply" parameters:body success:^(id responseObject) {
//        
//        [JGJHistoryText saveWithKey:@"sendtask" andContent:@""];
//
//       
//        self.chatInputView.placeholder = @"请输入回复内容";
////        [self.chatInputView resignFirstResponder];
//
//        [self HadRecivemasgID:self.jgjChatListModel];
//        
//        [self.view endEditing:YES];
//        
////        [self ScrollBottm];
//
//        self.jgjChatListModel.reply_uid = nil;
//        
//    }failure:^(NSError *error) {
//        [self.view endEditing:YES];
//
//        self.jgjChatListModel.reply_uid = nil;
//    }];
    
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

    self.navigationItem.title = @"任务详情";
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [IQKeyboardManager sharedManager].enable = NO;
    
//    self.MainCollectionview.hidden = YES;
}



-(void)ScrollBottm
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ReplyArray.count-1 inSection:9];
    [self.MainCollectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
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
    
}
//收到
- (void)ClickDetailRightnumberButton:(UIButton *)sender
{
    
    //示例数据不能点击
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        return;
    }
    
    [self editeTackState:self.jgjChatListModel.msg_id];

}

-(void)ClickDetailLeftButton:(UIButton *)sender
{
    _joinMan = NO;
    _buttonType = clickPrincipalType;
    [self HadRecivemasgID:self.jgjChatListModel];
    
}
-(void)ClickDetailRightButton:(UIButton *)sender
{
    
    _buttonType = clickJoinType;
    _joinMan = YES;
    self.memberModels = [NSArray array];
    HadReciveArr = UnReciveArr;
    self.memberModels = self.ReciveMembersModelArr;
    [self.MainCollectionview reloadData];
}


-(CGSize)retrunImagesize:(CGSize)size
{
    NSArray *imageSizes = @[@(size.width), @(size.height)];
    
    CGSize maxSize = CGSizeMake(TYGetUIScreenWidth*2/3, TYGetUIScreenWidth*2/3);
    
    CGSize imageSize = [JGJImage getFitImageSize:imageSizes maxImageSize:maxSize];
    
    scaleImagesize = imageSize;
    
    return imageSize;
    
    /*
if (size.width == size.height) {    //正方形图片
        if (size.width >TYGetUIScreenWidth*2/3) {
            CGSize newSize = CGSizeMake(TYGetUIScreenWidth*2/5, TYGetUIScreenWidth*2/5);
            scaleImagesize = newSize;
            
            return newSize;
        }else{
            scaleImagesize = size;
            
            return size;
        }
    }else if (size.width > size.height)
    {//横屏
        if (size.width>TYGetUIScreenWidth*2/3) {
            CGSize newSize = CGSizeMake(TYGetUIScreenWidth*2/3, size.height*TYGetUIScreenWidth*2/size.width/3 - 10);
            scaleImagesize = newSize;
            
            return newSize;
        }else{
            scaleImagesize = size;
            
            return size;
        }
        
    }else{
        //竖屏
        if (size.width>TYGetUIScreenWidth*2/3) {
            //            CGSize newSize = CGSizeMake(TYGetUIScreenWidth*2/3, size.height*TYGetUIScreenHeight);
            CGSize newSize = CGSizeMake(TYGetUIScreenWidth*2/3.8 -10, size.height*TYGetUIScreenWidth*2/size.width/3.8 - 35);

            scaleImagesize = newSize;
            return newSize;
        }else{
            scaleImagesize = size;
            
            return size;
        }
    }
    
    return size;*/
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
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:button withActions:[self JGJChatActions]];
}
- (NSArray<PopoverAction *> *)JGJChatActions {
    // 扫一扫 action
    PopoverAction *sweepAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"-more_details"] title:@"修改" handler:^(PopoverAction *action) {
        
        
        [self editeBuilderDaily];
    }];
    
    PopoverAction *addFriendAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"-more_recorder"] title:@"删除" handler:^(PopoverAction *action) {
        [self deleteBuilderDaildy];
    }];
    
    return @[sweepAction, addFriendAction];
    
}

#pragma mark - 删除施工日志
-(void)deleteBuilderDaildy
{
    
    
}

#pragma mark - 编辑施工日志
-(void)editeBuilderDaily
{
    JGJBuilderDiaryViewController *builderDailyVC = [JGJBuilderDiaryViewController new];
    JGJSendDailyModel *model = [JGJSendDailyModel new];
    model.weat_am = self.jgjChatListModel.weat_am;
    model.weat_pm = self.jgjChatListModel.weat_pm;
    model.temp_am = self.jgjChatListModel.temp_am;
    model.temp_pm = self.jgjChatListModel.temp_pm;
    model.wind_am = self.jgjChatListModel.wind_am;
    model.wind_pm = self.jgjChatListModel.wind_pm;
    model.msg_srcs = self.jgjChatListModel.msg_src;
    model.msg_text = self.jgjChatListModel.msg_text;
    model.techno_quali_log = self.jgjChatListModel.techno_quali_log;
    builderDailyVC.eidteBuilderDaily = YES;
    builderDailyVC.WorkCicleProListModel = self.workProListModel;
    
    builderDailyVC.sendDailyModel = model;
    [self.navigationController pushViewController:builderDailyVC animated:YES];
}
-(void)getTaskDetailwithMsgid:(NSString *)msgid
{
    NSMutableDictionary *paraDIc = [NSMutableDictionary dictionary];
    [paraDIc setObject:msgid?:@"0" forKey:@"id"];
    
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskDetail" parameters:paraDIc success:^(id responseObject) {
    
        self.MainCollectionview.hidden = NO;
        HadReciveArr = [NSMutableArray array];
        HadReciveArr = responseObject[@"members"];
        //未收到头像
        UnReciveArr = [NSMutableArray array];
        UnReciveArr = responseObject[@"unrelay_members"];
        _ChatMsgArray = [JGJChatMsgListModel mj_objectArrayWithKeyValuesArray:responseObject[@"replyList"]];
        [TYShowMessage hideHUD];
        self.detailMemeberModel = [JGJNotifyDetailMembersModel new];
        self.detailMemeberModel = [JGJNotifyDetailMembersModel mj_objectWithKeyValues:responseObject];
        
        self.jgjChatListModel.create_time = self.detailMemeberModel.create_time;
        self.jgjChatListModel.is_can_deal = [self.detailMemeberModel.is_can_deal?:@"0" intValue];
        self.jgjChatListModel.msg_text = self.detailMemeberModel.task_content;
        
        self.jgjChatListModel.task_level = self.detailMemeberModel.task_level;
        
        self.jgjChatListModel.msg_src = self.detailMemeberModel.task_imgs;
        
        self.jgjChatListModel.task_status = self.detailMemeberModel.task_status;
        self.jgjChatListModel.from_group_name = self.detailMemeberModel.team_or_group_name;
        self.jgjChatListModel.user_name = self.detailMemeberModel.pub_man.real_name;
        
        self.jgjChatListModel.uid = self.detailMemeberModel.pub_man.uid;
        self.jgjChatListModel.head_pic = self.detailMemeberModel.pub_man.head_pic;
        
        self.jgjChatListModel.task_finish_time = self.detailMemeberModel.task_finish_time;
        
        
        self.memberModels = [NSArray array];
        
        self.memberModels = self.detailMemeberModel.members;
        
        NSArray *memebrs = self.detailMemeberModel.members;
        
        if (memebrs.count > 0) {
            
            NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid=%@", myUid];
            
            NSArray *prinMembers = [memebrs filteredArrayUsingPredicate:predicate];
            
            if (prinMembers.count > 0) {
                
                JGJSynBillingModel *prinMember = prinMembers.lastObject;
                
                //自己是否是负责人
                
                self.is_my_pri = [prinMember.uid isEqualToString:myUid];
                
            }
        }
        
        self.ReciveMembersModelArr = [NSArray array];
        self.ReciveMembersModelArr = self.detailMemeberModel.unrelay_members;
        
#pragma mark - 修改参与者回来保持状态
        if (_buttonType == clickJoinType) {
            
            self.memberModels = self.ReciveMembersModelArr;
            
        }
        [self.MainCollectionview reloadData];
        [self closeInputView];
    } failure:^(NSError *error) {
        
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)error;
            [TYShowMessage showError:dic[@"errmsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
//获取回复列表
-(void)getreplyList:(NSString *)msg_id
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:msg_id forKey:@"id"];
    [paramDic setObject:@"" forKey:@"pg"];
    [paramDic setObject:@"" forKey:@"pagesize"];

//    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskReplyList" parameters:paramDic success:^(id responseObject) {

        ReplyArray = [[NSMutableArray alloc]initWithArray:responseObject];
        
        //新添加用模型处理，之前同时用的是字典
        
        self.replyList = [JGJQualityDetailReplayListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        [self.MainCollectionview reloadData];
        
        [self.MainCollectionview reloadData];
        
        if (self.replyChat) {
            
            [self ScrollBottm];
        }
        
        [TYLoadingHub hideLoadingView];
        
        [self.MainCollectionview.mj_header endRefreshing];
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showError:@"服务器错误!"];
        [self.MainCollectionview.mj_header endRefreshing];

    }];
}
#pragma mark - 修改任务状态
-(void)editeTackState:(NSString *)msg_id
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:msg_id forKey:@"id"];
    [paramDic setObject:[hadStr isEqualToString:@"0"]?@"1":@"0" forKey:@"task_status"];//修改的任务状态(0,待处理 ,1，已完成) ，默认为0
    [TYLoadingHub showLoadingWithMessage:@""];

    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskStatusChange" parameters:paramDic success:^(id responseObject) {

        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel new];
        msgModel = self.jgjChatListModel;
        msgModel.task_status = [hadStr isEqualToString:@"0"]?@"1":@"0";
        self.jgjChatListModel = msgModel;
        [ self refreshtaskVC];
        if (![NSString isEmpty:msgModel.task_status]) {
            if ([msgModel.task_status isEqualToString:@"0"]) {

            }
        }
        [self.MainCollectionview reloadData];
        
        [TYLoadingHub hideLoadingView];

        [self closeInputView];
        
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
  
    }];
}
-(void)tapFromLable
{
//    [self setIndexProListModel:self.jgjChatListModel];

//    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"你确定要切换到该项目首页吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
//    [alert setMessageColor:TYColorRGBA(28, 28, 28, 1.0) fontSize:14];
//
//    [alert show];
    
    [self setIndexProListModel:self.jgjChatListModel];
    
}
-(void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self setIndexProListModel:self.jgjChatListModel];
        
    }

}
-(void)refreshtaskVC{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJTaskRootVc class]]) {
            JGJTaskRootVc *taskVC = (JGJTaskRootVc *)vc;
            
            [taskVC freshWaitTask];
            
            break;
        }
    }
    
}
- (void)setIndexProListModel:(JGJChatMsgListModel *)proListModel {
    
//    NSDictionary *body = @{
//                           @"class_type" : proListModel.class_type?:@"",
//                           @"group_id" : proListModel.group_id?:@""
//                           };
//    __weak typeof(self) weakSelf = self;
//
//    [JGJChatGetOffLineMsgInfo http_gotoTheGroupHomeVCWithGroup_id:proListModel.group_id?:@"" class_type:proListModel.class_type?:@"" isNeedChangToHomeVC:YES isNeedHttpRequest:YES success:^(BOOL isSuccess) {
//
//        [TYShowMessage showSuccess:@"已切换到该项目首页，你可以在首页进行各模块的使用"];
//
//        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//
//    }];
    
    JGJSwitchMyGroupsTool *tool = [JGJSwitchMyGroupsTool switchMyGroupsTool];
    
    [tool switchMyGroupsWithGroup_id:self.workProListModel.group_id?:@"" class_type:self.workProListModel.class_type?:@"" targetVc:self];
}

-(void)ClicknameLable
{
    if (self.jgjChatListModel.IsCloseTeam ) {
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
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 7) {
        return 10;
    }
    return 0;
    
}

#pragma mark - 点击切换负责人和参与者
-(void)upEditeTaskPersonAndUID:(NSMutableArray *)uidArr isPrincipal:(BOOL)principal
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.jgjChatListModel.msg_id?:@"" forKey:@"id"];
    if (principal) {
        
        [paramDic setObject:@"" forKey:@"priticipant_uids"];//参与人uids,多个uid用逗号隔开(必须按照这个方式)，实例： 111,222,333
        NSString *uidStr;
        if (uidArr.count) {
            uidStr = uidArr.firstObject;
        }
        [paramDic setObject:uidStr?:@"" forKey:@"principal_uid"];//负责人uid（注意：principal_uid 和 priticipant_uids必须其一）
    }else{
        NSString *uidStr ;
        if (uidArr.count) {
            for (int index = 0; index < uidArr.count; index ++) {
                if ([NSString isEmpty:uidStr ]) {
                    uidStr = uidArr[index];
                }else{
                    uidStr = [[uidStr stringByAppendingString:@","] stringByAppendingString:uidArr[index]];
                }
            }
        }
        [paramDic setObject:uidStr?:@"" forKey:@"priticipant_uids"];//参与人uids,多个uid用逗号隔开(必须按照这个方式)，实例： 111,222,333
        [paramDic setObject:@"" forKey:@"principal_uid"];//负责人uid（注意：principal_uid 和 priticipant_uids必须其一）
    }
    [TYLoadingHub showLoadingWithMessage:nil];

    [JLGHttpRequest_AFN PostWithApi:@"v2/task/taskPersonChange" parameters:paramDic success:^(id responseObject) {
        
//        _buttonType = clickPrincipalType;
        [self HadRecivemasgID:self.jgjChatListModel];//其他列表
        [TYLoadingHub hideLoadingView];

    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
 
    }];
    
}

- (void)taskDetailCell:(JGJTaskDetailCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index{
    
    [self.view endEditing:YES];
    
    [JGJCheckPhotoTool browsePhotoImageView:cell.listModel.msg_src selImageViews:imageViews didSelPhotoIndex:index];
    
}

- (void)taskDetailCell:(JGJTaskDetailCell *)cell  didSelectedUserInfoModel:(JGJQualityDetailReplayListModel *)userInfoModel {
    
    [self clickDetailPublishManInfo];
}

#pragma mark - 发送emoji表情
-(void)sendEmoji:(UIButton *)sender
{
    _emojiButton.selected = !sender.selected;
    
    
}

#pragma mark - 发送图片
- (void)sendPic:(JGJChatInputView *)chatInputView audioInfo:(NSDictionary *)audioInfo {
    
    self.replyRequest.reply_text = chatInputView.textView.text;
    
    [self.imagesArray removeAllObjects];
    
    [self.sheet showInView:self.view];
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

#pragma mark - 发送文字

- (void)sendText:(JGJChatInputView *)chatInputView text:(NSString *)text {
    
    if (self.workProListModel.workCircleProType == WorkCircleExampleProType) {
        
        return;
        
    }
    
    self.replyRequest.reply_text = text;
    
    [self.chatInputView.textView resignFirstResponder];
    
    [self GetNetDatamasgID:masg_id Action:@"requestMessage" AndReplyext:text];
    
    rightcell.hadClick = @"1";
    
}

- (void)changeText:(JGJChatInputView *)chatInputView text:(NSString *)text {
    
    self.replyRequest.reply_text = chatInputView.textView.text;
    
}

//- (JGJChatInputView *)chatInputView {
//    
//    if (!_chatInputView) {
//        
//        _chatInputView = [[JGJChatInputView alloc] init];
//        
//        _chatInputView.chatInputViewKeyBoardType = JGJChatInputViewKeyBoardHiddenChangeStatusAndAddImageType;
//        
//        _chatInputView.delegate = self;
//        
//        _chatInputView.placeholder = @"请输入回复内容";
//        
//    }
//    
//    return _chatInputView;
//}
//



-(void)closeInputView{

    [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(ChatInputViewH);
    }];

}

#pragma mark - JGJSendMessageViewDelegate

- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr {
    
    if ([NSString isEmpty:self.replyRequest.reply_text]) {
        
        [self GetNetDatamasgID:masg_id Action:@"requestMessage" AndReplyext:self.replyRequest.reply_text];
        
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
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN uploadImagesWithApi:@"v2/task/taskReply" parameters:parameters imagearray:self.imagesArray success:^(id responseObject) {
        
        [JGJHistoryText saveWithKey:@"sendtask" andContent:@""];
        
        
        self.chatInputView.placeholder = @"请输入回复内容";
        //        [self.chatInputView resignFirstResponder];
        
        [self HadRecivemasgID:self.jgjChatListModel];
        
        [self.view endEditing:YES];
        
        //        [self ScrollBottm];
        
        self.jgjChatListModel.reply_uid = nil;
        
        [self.imagesArray removeAllObjects];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        self.jgjChatListModel.reply_uid = nil;
        
        [self.imagesArray removeAllObjects];
        
        [TYLoadingHub hideLoadingView];

    }];
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

-(float)RowSingerLineHeight:(NSString *)Str andDepart_W:(NSInteger )width
{
    if ([NSString isEmpty:Str]) {
        Str = @"";
    }
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

- (JGJQualityReplyRequestModel *)replyRequest {
    
    if (!_replyRequest) {
        
        _replyRequest = [[JGJQualityReplyRequestModel alloc] init];
    }
    
    return _replyRequest;
}

@end
