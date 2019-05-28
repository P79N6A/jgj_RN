//
//  JGJChatListBaseCell.m
//  mix
//
//  Created by Tony on 2016/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseCell.h"
#import "UILabel+GNUtil.h"
#import "JGJChatListPhotoCell.h"
#import "JGJTime.h"
#import "NSString+Extend.h"
#import "UIButton+JGJUIButton.h"
#import "JGJChatListBaseCell.h"

#import "YYText.h"

#import "JGJQuaSafeTool.h"

#import "NSDate+Extend.h"

#import "AFNetworkReachabilityManager.h"

#import "JGJChatMsgDBManger.h"

#import "JGJCheckPhotoTool.h"

static const CGFloat kChatListAudioMinWith = 55.0;

@interface JGJChatListBaseCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

//当消息超过2行的时候离边框的最远距离
@property (nonatomic, assign) CGFloat messageMaxBorderMargin;

//collectionCell的间距
@property (nonatomic, assign) CGFloat collectionViewMargin;

//显示图片的cell
@property (nonatomic, copy) NSString *idPhotoStr;

@property (nonatomic, assign) BOOL Show;

//显示图片的imageView
@property (weak, nonatomic) IBOutlet UIImageView *cellTypeImageView;

//泡泡图
@property (weak, nonatomic) IBOutlet UIImageView *POPImageView;

@property (weak, nonatomic) IBOutlet UIView *middleView;


@property (weak, nonatomic) IBOutlet UILabel *cellTypeLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *sendFailImage;

@property (weak, nonatomic) IBOutlet JGJChatDetailNextButton *detailNextButton;

//constraints
//默认是38
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTypeViewConstraintH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraintH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMarginViewConstraintLR;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintT;

@property (strong, nonatomic) UIButton *headButton;

@property (strong, nonatomic)  UIImageView *SendPicFailView;

//自定义撤回按钮

@property (strong, nonatomic) UIButton *cusMenuBtn;

@property (strong, nonatomic) NSMutableArray *menuControlArr;

@property (weak, nonatomic) IBOutlet UIImageView *sendPicFailImage;


@end

@implementation JGJChatListBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit{
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    BOOL isMineCell = [self isKindOfClass:NSClassFromString(@"JGJChatListMineCell")];
    self.messageMaxBorderMargin = TYIS_IPHONE_5_OR_LESS?40.0:76.0;
    self.messageMaxBorderMargin += isMineCell?0:-10;
    
    self.bottomMarginViewConstraintLR.constant = self.messageMaxBorderMargin;
#pragma mark - 文字行数适配  原代码   self.contentLabel.numberOfLines = 2;  LYQ
    self.contentLabel.numberOfLines = 0;
    
    CGFloat maxW = TYIS_IPHONE_5_OR_LESS?202:(TYIS_IPHONE_6 || TYIST_IPHONE_X ? 220 : 260);

    self.contentLabelMaxW = maxW;
    
    self.contentLabel.preferredMaxLayoutWidth = maxW;
    
    self.contentLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.sendFailImage.hidden = YES;
    
    //失败的图片的手势
    self.sendFailImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *failTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resendAlertClick:)];

    failTap.numberOfTapsRequired = 1;

    [self.sendFailImage addGestureRecognizer:failTap];
    
    self.indicatorView.hidden = YES;
    
    [self.audioButton addTarget:self.audioButton action:@selector(playAutioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.avatarImageView.layer setLayerCornerRadius:JGJCornerRadius];//2.1.0-yj修改为方形头像
    
    [self setCollection];
    
    [self subClassInit];
    
    self.headButton = [UIButton new];
    
    [self.avatarImageView addSubview:self.headButton];
    
    self.headButton.frame = CGRectMake(0, 0, self.avatarImageView.width, self.avatarImageView.height);
    
    UITapGestureRecognizer *checkDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCheckInfo:)];
    
    checkDetailTap.numberOfTapsRequired = 1;
    
    [self.middleView addGestureRecognizer:checkDetailTap];
    
    self.middleView.backgroundColor = AppFontf1f1f1Color;
    
    self.POPImageView.backgroundColor = AppFontf1f1f1Color;
    
    self.topTitleView.backgroundColor = AppFontf1f1f1Color;
    
    if (!self.SendPicFailView) {
        
        self.SendPicFailView = [UIImageView new];
        
        self.SendPicFailView.contentMode = UIViewContentModeRight;
        
        [self.contentView addSubview:self.SendPicFailView];
        
        self.SendPicFailView.image = [UIImage imageNamed:@"Chat_sendFail"];
        
        self.SendPicFailView.hidden = YES;
        
    }
}

#pragma mark - 进入详情页
- (void)handleCheckInfo:(UITapGestureRecognizer *)tap {
    
    if (_jgjChatListModel.sendType == JGJChatListSendFail && [_jgjChatListModel.msg_type isEqualToString:@"text"]) {
        
        CGSize size = _jgjChatListModel.imageSize;
        
        CGPoint point = [tap locationInView:self.contentView];
        
        CGFloat maxW = size.width;
        
        CGFloat isContainPoint = ((TYGetUIScreenWidth - point.x) < maxW + 40 + 27 + 40) && point.x < TYGetUIScreenWidth - 50;
        
        if (isContainPoint) {
            
           [self resendFailMsgClick];
            
        }
        
        return;
    }
    
    // 隐藏菜单UIMenuController
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
    
    //特定的类型才能点击进入详情页
    JGJChatListType chatListType = _jgjChatListModel.chatListType;
    
    if (chatListType == JGJChatListNotice||
        chatListType == JGJChatListSafe||
        chatListType == JGJChatListQuality||
        chatListType == JGJChatListLog ||
        chatListType == JGJChatPostcardType ||
        chatListType == JGJChatLocalPostcardType ||
        chatListType == JGJChatRecruitmentType ||
        chatListType == JGJChatLocalRecruitmentType ||
        chatListType == JGJChatListLinkType) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(detailNextBtnClick:indexPath:)]) {
            [self.delegate detailNextBtnClick:self indexPath:self.indexPath];
        }
    }
    
    
}

//设置collectionView
- (void)setCollection{
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.idPhotoStr = @"JGJChatListPhotoCell";

    //注册一般显示的照片collection
    UINib *nib = [UINib nibWithNibName:self.idPhotoStr
                                bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:self.idPhotoStr];
}

#pragma mark - 子类用的
- (void)subClassInit{
    //添加长按手势
    [self addLongTapHandler];
}

- (void)setCellTypeViewConstant:(CGFloat )constant{
    if (constant == 0) {
        self.cellTypeLabel.text = nil;
        self.cellTypeImageView.image = nil;
    }
    
    self.cellTypeLabel.hidden = constant == 0;
    self.cellTypeImageView.hidden = constant == 0;

    if (self.cellTypeViewConstraintH.constant != constant) {
        self.cellTypeViewConstraintH.constant = constant;
    }

}

- (void)setContentLabelConstraint:(CGFloat )constant{
    if (self.contentLabelConstraintW.constant == constant) {
        return;
    }
    self.contentLabelConstraintW.constant = constant;
}

- (void)setCollectionViewHConstant:(CGFloat )constant{
    constant = ceil(constant);
    
    
    self.collectionView.hidden = constant == 0;

    self.collectionViewConstraintH.constant = constant == 0?0.01:constant;
    [self.collectionView reloadData];
}

- (void)setCollectionViewBConstant:(CGFloat )constant{
    if (self.collectionViewConstraintB.constant == constant) {
        return;
    }
    
    self.collectionViewConstraintB.constant = constant;
}

- (void)setContentLabelTBConstraint:(CGFloat )constant{
    if (self.contentLabelConstraintT.constant == constant) {
        return;
    }
    
    self.contentLabelConstraintT.constant = constant;
    if (self.contentLabelConstraintB.constant == constant) {
        return;
    }
    self.contentLabelConstraintB.constant = constant;

}
//后期添加新版的日志
-(void)setLogModel:(JGJLogSectionListModel *)logModel
{
    
    _Show = YES;
    
    
    _logModel = logModel;
    
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //    if ([jgjChatListModel.msg_type isEqualToString:@"text"]) {
    //        self.contentLabel.numberOfLines = 0;
    //    }else{
    //
    //        if (jgjChatListModel.msg_src.count==0) {
    //            self.contentLabel.numberOfLines = 4;
    //
    //        }else{
    //            self.contentLabel.numberOfLines = 2;
    //        }
    //    }
    //设置标题
    [self setTitle:_jgjChatListModel.belongType];
    
    //设置头像
    //    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:_jgjChatListModel.head_pic]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];
    
    UIColor *backGroundColor = [NSString modelBackGroundColor:logModel.user_info.real_name];
    [self.headButton setMemberPicButtonWithHeadPicStr:logModel.user_info.head_pic memberName:logModel.user_info.real_name memberPicBackColor:backGroundColor];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    self.headButton.userInteractionEnabled = NO;//拦截了touch事件
    
    //添加手势
    
    self.avatarImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(avatarLongHandleTap:)];
    
    [self.avatarImageView addGestureRecognizer:longTouch];
    //单击进入详情页
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarHandleTap:)];
    [self.avatarImageView addGestureRecognizer:tapGesture];
    [self subLogClassWithModel:logModel];
    
    [self setDetailNextButtonType];
    
    
}
- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    _Show = YES;

    _jgjChatListModel = jgjChatListModel;
    
#pragma mark - 限制通知信息为两排
    if ([jgjChatListModel.msg_type isEqualToString:@"text"]) {
        self.contentLabel.numberOfLines = 0;
    }else{
    
        self.contentLabel.numberOfLines = 2;
        
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
     
//    //设置标题
    [self setTitle:_jgjChatListModel.belongType];
//    //设置头像
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:_jgjChatListModel.head_pic]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"] options:SDWebImageRefreshCached];
    
    UIColor *backGroundColor = [NSString modelBackGroundColor:jgjChatListModel.user_name];
    [self.headButton setMemberPicButtonWithHeadPicStr:jgjChatListModel.user_info.head_pic memberName:jgjChatListModel.user_name?:@"" memberPicBackColor:backGroundColor];
    
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    self.headButton.userInteractionEnabled = NO;//拦截了touch事件
    
    //添加手势
    self.avatarImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(avatarLongHandleTap:)];
    
    [self.avatarImageView addGestureRecognizer:longTouch];
    
    //单击进入详情页
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarHandleTap:)];
    [self.avatarImageView addGestureRecognizer:tapGesture];
    
    [self subClassSetWithModel:_jgjChatListModel];
    
    [self setDetailNextButtonType];
    
    //设置图片发送失败的图标
    
    [self setSendfailureWithjgjChatListModel:jgjChatListModel];

    //强制隐藏对方失败的状态
    
    if (jgjChatListModel.belongType != JGJChatListBelongMine) {
        
        self.sendFailImage.hidden = YES;
    }

}

- (void)setDetailNextButtonType{
    //特定的类型才能点击进入详情页
    JGJChatListType chatListType = _jgjChatListModel.chatListType;
    
    if (chatListType == JGJChatListNotice||
        chatListType == JGJChatListSafe||
        chatListType == JGJChatListQuality||
        chatListType == JGJChatListLog) {
        
    }else{
        self.detailNextButton.userInteractionEnabled = NO;
    }
}

- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    JGJChatListBelongType belongType = _jgjChatListModel.belongType;
    NSInteger imgCount = _jgjChatListModel.msg_src.count;
    
    if(jgjChatListModel.sendType == JGJChatListSendFail){
        [self sendMessageFail];
    }else if(jgjChatListModel.sendType == JGJChatListSendStart){
        [self sendMessageStart];
    }else{
        [self sendMessageSuccess];
    }
    
    //对方的消息接收到就是成功状态
    
    if (belongType != JGJChatListBelongMine) {
        
        [self sendMessageSuccess];
    }
    
    //设置子类
    [self setSubClass:belongType];

    //设置消息
    [self setContentText:belongType imgsCount:imgCount];
    
    //设置不同类型的消息
    [self setMsgsType:belongType imgsCount:imgCount];

    //设置底部的照片
    [self setCollectionImgs:imgCount chatListType:_jgjChatListModel.chatListType];
    
    //设置查看详情
    self.detailNextButton.chatListType = jgjChatListModel.chatListType;
}

#pragma mark - 设置标题等
-(void)setTitle:(JGJChatListBelongType) belongType{
    
    JGJChatListCellTopTimeModel *topTimeModel = [JGJChatListCellTopTimeModel new];
    
    NSString *normalStr;
    ;

    //设置头像等
    if (belongType == JGJChatListBelongMine) {//我的
        normalStr = _jgjChatListModel.displayDate;
        
        //未读人不为0的情况
        if (_jgjChatListModel.unread_members_num > 0) {
            NSString *highlightString = [NSString stringWithFormat:@"%@人未读",@(_jgjChatListModel.unread_members_num)];
                        
            if ([_jgjChatListModel.class_type isEqualToString:@"singleChat"]) {
                
//                NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
//
//                highlightString = @"未读";
//
//                //单聊自己不需要已读未读
//                if ([myUid isEqualToString:_jgjChatListModel.group_id ?:@""]) {
//
//                    highlightString = @"";
//                }
                
                 highlightString = @"";
                
            }
            
            //除图片外，其他类型失败的消息，没有未读数。图片自动重发一次
            
            if (_jgjChatListModel.sendType == JGJChatListSendFail && ![_jgjChatListModel.msg_type isEqualToString:@"pic"]) {
                
                highlightString = @"";
            }
            
            topTimeModel.highlightString = highlightString;
            
        } else if ([_jgjChatListModel.class_type isEqualToString:@"singleChat"] && _jgjChatListModel.unread_members_num == 0 && ![NSString isEmpty:_jgjChatListModel.msg_id]) {
            
//            NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
//
//            topTimeModel.highlightString = @"已读";
//
////            //单聊自己不需要已读未读
//            if ([myUid isEqualToString:_jgjChatListModel.group_id ?:@""]) {
//
//                topTimeModel.highlightString = @"";
//            }
            
            topTimeModel.highlightString = @"";
            
        }
        
        
        topTimeModel.listType = JGJChatListReadInfo;
    }else if(belongType == JGJChatListBelongOther || belongType == JGJChatListBelongGroupOut){
//         normalStr = [NSString stringWithFormat:@"%@ %@",_jgjChatListModel.user_name,_jgjChatListModel.displayDate];
#pragma mark - 修改没有拼接时间和名字造成没显示名字
        
        NSString *topTimeDes = [NSDate chatMsgListShowDateWithTimeStamp:_jgjChatListModel.send_time];
        
        normalStr = [NSString stringWithFormat:@"%@ %@",_jgjChatListModel.user_name, topTimeDes];

        if( belongType == JGJChatListBelongGroupOut){
            normalStr = [@"来自班组外成员 " stringByAppendingString:normalStr];
        }
        
        if (_jgjChatListModel.chatListType == JGJChatListRecord) {
            topTimeModel.highlightString = [_jgjChatListModel.myself_group isEqualToString:@"1"]?@"查看详情":nil;
            topTimeModel.listType = JGJChatListRecord;
        }
    }
    topTimeModel.normalString = normalStr;
    topTimeModel.belongType = belongType;
    topTimeModel.chatMsgListModel = _jgjChatListModel;
    
    self.topTitleView.topTimeModel = topTimeModel;
}

#pragma mark  设置子类
-(void)setSubClass:(JGJChatListBelongType) belongType{
    //设置头像等
    if (belongType == JGJChatListBelongMine) {//我的
        [self setMineData];
    }else if(belongType == JGJChatListBelongOther || belongType == JGJChatListBelongGroupOut){
        [self setOtherData];
    }
}

#pragma mark 子类设置"我的"数据
- (void)setMineData{
    
}

#pragma mark 子类设置"别人"数据
- (void)setOtherData{
}


#pragma mark - sendMessage
#pragma mark  发送消息菊花要转
- (void)sendMessageStart{
    self.sendFailImage.hidden = YES;
    self.indicatorView.hidden = NO;
    
    [self.indicatorView startAnimating];
}

- (void)sendMessageSuccess{
    self.sendFailImage.hidden = YES;
    self.indicatorView.hidden = YES;
    
    [self.indicatorView stopAnimating];
    
}

- (void)sendMessageFail{
    self.sendFailImage.hidden = NO;
    self.indicatorView.hidden = YES;
    
    [self.indicatorView stopAnimating];
}

#pragma mark 设置消息
- (void)setContentText:(JGJChatListBelongType) belongType imgsCount:(NSInteger )imgsCount{
    
    //设置消息
    self.contentLabel.text = _jgjChatListModel.msg_text;
    
    JGJChatListType chatListType = _jgjChatListModel.chatListType;
    
    UIColor *contentColor = TYColorHex(0x000000);
    
    if (chatListType == JGJChatListText) {
        if (belongType == JGJChatListBelongMine) {//我的
            
            contentColor = imgsCount?TYColorHex(0x000000):[UIColor whiteColor];
            
            self.contentLabel.textColor = contentColor;
            
        }else{//其他的
            
            contentColor = TYColorHex(0x000000);
            
            self.contentLabel.textColor = TYColorHex(0x000000);
            
        }
    }else{
        
        contentColor = TYColorHex(0x000000);
        
        self.contentLabel.textColor = TYColorHex(0x000000);
        
    }
    
    //
    if (![NSString isEmpty:_jgjChatListModel.msg_text]) {
        
        [self setContentTextlinkAttWith:_jgjChatListModel contentColor:contentColor];
    }
}

#pragma mark 设置不同类型的消息
- (void)setMsgsType:(JGJChatListBelongType) belongType imgsCount:(NSInteger )imgsCount{
    //设置消息类型
    JGJChatListTypeModel *chatListTypeModel = [JGJChatListTypeModel sharedchatListTypeModel];
    JGJChatListType chatListType = _jgjChatListModel.chatListType;
//    JGJChatListNotice,//通知
//    JGJChatListSafe,//安全
//    JGJChatListQuality,//质量
    if (chatListType < chatListTypeModel.listTypePOPImgsMine.count) {
        
        if (belongType == JGJChatListBelongMine) {//我的
            //设置POP
            self.POPImageView.image = chatListTypeModel.listTypePOPImgsMine[chatListType];
            
        }else if(belongType == JGJChatListBelongOther || belongType == JGJChatListBelongGroupOut){
            //设置POP
            self.POPImageView.image = chatListTypeModel.listTypePOPImgsOther[chatListType];
        }
        
    }
    
    self.audioButton.hidden = YES;
    //先统一设置成4.0
    [self setCollectionViewBConstant:4.0];
    
    //先统一设置成0.0
    [self setContentLabelTBConstraint:0.0];
    if (chatListType == JGJChatListText) {
        
        //文字
        [self setCellTypeViewConstant:0.0];

        [self setContentLabelConstraint:(imgsCount?self.contentLabelMaxW:0)];
        
        //plus手动算高度，因为有换行符的时候有点问题。
        if (TYIS_IPHONE_6P) {

            self.contentLabelConstraintW.constant = _jgjChatListModel.norMsgWidth + 5;

        }
        
    }else if(chatListType == JGJChatListAudio){
        //语音
        [self setCellTypeViewConstant:0.0];
        self.audioButton.hidden = NO;
        
        //计算长度
        CGFloat audioTime = [_jgjChatListModel.voice_long floatValue];

        [self setContentLabelConstraint:kChatListAudioMinWith + ceil(audioTime/60.0 * (self.contentLabelMaxW - kChatListAudioMinWith))];
        
        ChatListAudioType audioType = belongType == JGJChatListBelongMine?ChatListAudioMine:ChatListAudioOther;
        
        NSString *amrFilePath = @"";
        
        if (_jgjChatListModel.msg_src.count > 0) {
            
            amrFilePath = _jgjChatListModel.msg_src[0];
        }
        
        NSDictionary *audioInfo = @{@"fileTime":_jgjChatListModel.voice_long?:@"",@"filePath":_jgjChatListModel.voice_filePath?:@"",@"amrFilePath":amrFilePath};
        [self setAudioType:audioType audioInfo:audioInfo];
        
    }else{
        [self setCellTypeViewConstant:38.0];
        if (chatListType == JGJChatListRecord || chatListType == JGJChatListSign) {
            CGFloat recordMaxW = chatListType == JGJChatListRecord?((belongType == JGJChatListBelongMine)?150.0:130.0):((belongType == JGJChatListBelongMine)?170.0:150.0);
            [self setContentLabelConstraint:recordMaxW];
            
            //如果是记账设置成0.0
            [self setCollectionViewBConstant:0.0];
        }else{
            [self setContentLabelConstraint:self.contentLabelMaxW];
            
            //如果是其他通知设置成8.0
            [self setCollectionViewBConstant:8.0];
            
            //如果是其他通知设置成4.0
            [self setContentLabelTBConstraint:4.0];
        }
        
        if (chatListType < chatListTypeModel.listTypeImgs.count) {
            
            self.cellTypeImageView.image = chatListTypeModel.listTypeImgs[chatListType];
        }

        NSString *extrStr = [NSString string];
        if ((belongType == JGJChatListBelongMine) && (chatListType == JGJChatListRecord)) {
            extrStr = @"我";
        }
        
        if (chatListType < chatListTypeModel.listTypeTitles.count) {
            
            self.cellTypeLabel.text = [extrStr stringByAppendingString:chatListTypeModel.listTypeTitles[chatListType]];
            
            
            self.cellTypeLabel.textColor = chatListTypeModel.listTypeColor[chatListType];
        }
        
        if(chatListType == JGJChatListRecord || chatListType == JGJChatListSign){
            //记账,只显示字，不显示图片
            self.contentLabel.text = nil;
        }
    }
}

#pragma mark 设置图片
- (void)setCollectionImgs:(NSInteger )imgsCount chatListType:(JGJChatListType) chatListType{
    //没有就不用计算
    if (![self filterSubClassSetCollectionImgs:imgsCount chatListType:chatListType]) {
        self.collectionViewMargin = 0;
        self.collectionCellWH = 0;
        
        [self setCollectionViewHConstant:0.0];
        return;
    }
    
    //设置图片
    if (imgsCount == 1) {//只有1张图片
        self.collectionViewMargin = 0;
        self.collectionCellWH = self.contentLabelMaxW;
        
        [self setCollectionViewHConstant:self.contentLabelMaxW];
        return;
    }
    
    //2张以上的图片
    self.collectionViewMargin = kChatListCollectionCellMargin;
    self.collectionCellWH = (self.contentLabelMaxW - self.collectionViewMargin*4.0)/3.0;

    NSInteger rowNum = (imgsCount - 1)/3 + 1;
    [self setCollectionViewHConstant:rowNum*(self.collectionCellWH + kChatListCollectionCellMargin) - kChatListCollectionCellMargin];

}

- (BOOL )filterSubClassSetCollectionImgs:(NSInteger )imgsCount chatListType:(JGJChatListType) chatListType{
    //没有就不用结算
    if (imgsCount == 0 || chatListType == JGJChatListAudio || chatListType == JGJChatListRecord || chatListType == JGJChatListSign) {
        return NO;
    }
    
    return YES;
}

#pragma mark - 设置声音
- (void)setAudioType:(ChatListAudioType )audioType audioInfo:(NSDictionary *)audioInfo{
    
    [self.audioButton setAudioType:audioType  audioInfo:audioInfo chatListModel:_jgjChatListModel];
}

#pragma mark ---- UICollectionViewDataSource
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.collectionViewMargin?:0.01;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.collectionViewMargin?:0.01;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#pragma mark - 刘远强修改只显示四个

    NSInteger count = self.jgjChatListModel.msg_src.count;
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(self.collectionCellWH?:0.01,self.collectionCellWH?:0.01);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJChatListPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.idPhotoStr forIndexPath:indexPath];
    
    if (indexPath.row <= self.jgjChatListModel.msg_src.count) {
        [cell setIndex:indexPath image:self.jgjChatListModel.msg_src[indexPath.row]];
    }
    
    
    //点击了图片
    __weak typeof(self) weakSelf = self;
    cell.didSelectedPhotoBlock = ^(JGJChatListPhotoCell *photoCell,UIImage *image){
        
        [self checkPhotoWithIndx:indexPath.row image:image];
        
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(DidSelectedPhoto:index:image:)]) {
//            [strongSelf.delegate DidSelectedPhoto:strongSelf index:indexPath.row image:image];
//            
//            
////#pragma mark - 添加点击图片跳转到详情页面
////            if (self.delegate && [self.delegate respondsToSelector:@selector(tapImageGoWithtag:)]) {
////                [self.delegate tapImageGoWithtag:_indexPath];
////            }
//        }
    };

    return cell;
}

- (void)checkPhotoWithIndx:(NSInteger)index image:(UIImage *)image {
    
    NSMutableArray *imageArray = [NSMutableArray new];
    
    for (NSInteger index = 0; index < self.jgjChatListModel.msg_src.count; index++) {
        
        UIImageView *imageView = [UIImageView new];
        
        imageView.image = [UIImage imageNamed:@"defaultPic"];
        
        [imageArray addObject:imageView];
        
    }
    
    [self.window endEditing:YES];
    
    [JGJCheckPhotoTool chatViewWebBrowsePhotoImageView:self.jgjChatListModel.msg_src selImageViews:imageArray didSelPhotoIndex:index];
}

- (IBAction)detailNextBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailNextBtnClick:indexPath:)]) {
        [self.delegate detailNextBtnClick:self indexPath:self.indexPath];
    }
}

#pragma mark - 长按手势
-(BOOL)canBecomeFirstResponder {
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action ==@selector(copyClick:)){
        
        return YES;
        
    }else if (action == @selector(forwardClick:)) {
        
        return YES;
    }
    else if (action==@selector(resendClick:)){
        
        return YES;
        
    }else if (action==@selector(deleteClicked:)){
        
        return YES;
    }else if (action==@selector(revocationClicked:)){
        
        return YES;
        
    }
//    return NO;
    return [super canPerformAction:action withSender:sender];
}

//复制
- (void)copyClick:(id)sender {
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.contentLabel.text;
}

- (void)forwardClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(forwardChatListModelWithBaseCell:)]) {
        
        [self.delegate forwardChatListModelWithBaseCell:self];
    }
}
//重发
- (void)resendAlertClick:(UITapGestureRecognizer *)tapGesture{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重发该消息?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//
//    UIAlertAction *resendAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//        [self resendClick:nil];
//
//    }];
//
//    [alertController addAction:cancelAction];
//    [alertController addAction:resendAction];
//
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    
    [self longHandleTap:tapGesture];
}

//重发失败的消息
- (void)resendFailMsgClick {
    
    [self longHandleTap:nil];
}

-(void)resendClick:(id)sender {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    
    if (isReachableStatus) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenuType:)]) {
        
        [self.delegate chatListBaseCell:self showMenuType:JGJShowMenuResendType];
    }
    
    self.super_textView.inputNextResponder = nil;
    
}
//删除
-(void)deleteClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenuType:)]) {
        
        [self.delegate chatListBaseCell:self showMenuType:JGJShowMenuDelType];
    }
    self.super_textView.inputNextResponder = nil;
}


//撤回
-(void)revocationClicked:(id)sender {
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    BOOL isReachableStatus = status == AFNetworkReachabilityStatusNotReachable;
    
    if (isReachableStatus) {
        
        [TYShowMessage showHUDOnly:JGJNetErrorTips];
        
        return;
    }
    
    NSInteger cell_local_id_int = [self.jgjChatListModel.local_id integerValue];
    NSInteger now_locl_id_int = [[JGJChatListTool localID] integerValue];
    
    BOOL moreThan2Min = (now_locl_id_int - cell_local_id_int) < 120 * 1000;
    BOOL isMine = self.jgjChatListModel.belongType == JGJChatListBelongMine;
    if (isMine && !moreThan2Min&&self.jgjChatListModel.sendType != JGJChatListSendFail) {
        [TYShowMessage showPlaint:@"不能撤回2分钟之前发送的消息"];
        return;
    }
    
    //图片撤回隐藏自定义撤回
    
    if ([_jgjChatListModel.msg_type isEqualToString:@"pic"]) {
        
        [self hiddenCusMenuBtn];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenuType:)]) {
        
        [self.delegate chatListBaseCell:self showMenuType:JGJShowMenuReCallType];
        
    }
    
    NSString *parameters = @{@"ctrl":@"message",
                             @"action":@"recallMessage",
                             @"msg_id":self.jgjChatListModel.msg_id,
                             @"msg_type":self.jgjChatListModel.msg_type
                             }.copy;

    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
//        self.jgjChatListModel.msg_text =  responseObject[@"msg_text"];
//        self.jgjChatListModel.chatListType = JGJChatListRecall;
//        self.jgjChatListModel.cellHeight = 0; //撤回后重新计算高度
//        if (self.delegate && [self.delegate respondsToSelector:@selector(modifyMsg:indexPath:)]) {
//            [self.delegate modifyMsg:self indexPath:self.jgjChatListModel.msgIndexPath];
//        }
        
        
    } failure:nil];
    self.super_textView.inputNextResponder = nil;
}


-(void)addLongTapHandler {
    self.middleView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHandleTap:)];
   [self.middleView addGestureRecognizer:touch];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillshow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}
-(void)keyboardWillHide
{
    _Show = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _Show = YES;
        
    });
    
    [self hiddenCusMenuBtn];
    
}
-(void)keyboardWillshow
{
    _Show = YES;
    
    [self hiddenCusMenuBtn];
    
}

- (void)hiddenCusMenuBtn {
    
    [UIView animateWithDuration:0.1 animations:^{
       
        self.cusMenuBtn.alpha = 0;
        
        if (self.cusMenuBtn) {
            
            if (!self.cusMenuBtn.isHidden) {
                
                self.cusMenuBtn.hidden = YES;
                
            }
            
            [self.cusMenuBtn removeFromSuperview];
            
        }
        
    }];
}

-(void)longHandleTap:(UIGestureRecognizer*) recognizer {

    if ((recognizer.state==UIGestureRecognizerStateBegan&&![recognizer.view isKindOfClass:[UITextView class]]) || (self.jgjChatListModel.sendType == JGJChatListSendFail)) {
        
        // 菜单已经打开不需重复操作
        UIMenuController *shareMenu = [UIMenuController sharedMenuController];
        if (shareMenu.isMenuVisible)return;
        
        if ([self.super_textView isFirstResponder]) {
            self.super_textView.inputNextResponder = self;//关键代码
        }else{
            [self becomeFirstResponder];
        }
        [self.middleView becomeFirstResponder];
        NSMutableArray *menuControlArr = [NSMutableArray array];
        
        self.menuControlArr = menuControlArr;
        
        //如果是文本就添加复制
        if (self.jgjChatListModel.chatListType == JGJChatListText&&![recognizer.view isKindOfClass:[UITextView class]] && self.jgjChatListModel.sendType != JGJChatListSendFail) {
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyClick:)];
            [menuControlArr addObject:copyItem];
            
        }
        
        // 所有类型的消息均增加转发功能，包括：图片、文字、表情、名片、链接
        if ((self.jgjChatListModel.chatListType == JGJChatListText || self.jgjChatListModel.chatListType == JGJChatListPic || self.jgjChatListModel.chatListType == JGJChatPostcardType || self.jgjChatListModel.chatListType == JGJChatListLinkType) && ![recognizer.view isKindOfClass:[UITextView class]] && self.jgjChatListModel.sendType != JGJChatListSendFail) {
            
            UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardClick:)];
            [menuControlArr addObject:forwardItem];
        }
        
        //如果是失败了才重发和删除
        if (self.jgjChatListModel.sendType == JGJChatListSendFail) {
            UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:@"重新发送" action:@selector(resendClick:)];
            [menuControlArr addObject:resendItem];

            UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteClicked:)];
            [menuControlArr addObject:deleteItem];
            
        }
        
        
        //如果自己的消息并且没有超过2分钟
        NSInteger cell_local_id_int = [self.jgjChatListModel.local_id integerValue];
        NSInteger now_locl_id_int   = [[JGJChatListTool      localID] integerValue];
        
        BOOL moreThan2Min = (now_locl_id_int - cell_local_id_int) < 120 * 1000;
        BOOL isMine = self.jgjChatListModel.belongType == JGJChatListBelongMine;
        
        BOOL isCanRevo = [self.jgjChatListModel.msg_type isEqualToString:@"text"] || [self.jgjChatListModel.msg_type isEqualToString:@"voice"] || [self.jgjChatListModel.msg_type isEqualToString:@"pic"] || [self.jgjChatListModel.msg_type isEqualToString:@"postcard"] || [self.jgjChatListModel.msg_type isEqualToString:@"recruitment"] || [self.jgjChatListModel.msg_type isEqualToString:@"link"];
        
        //![NSString isEmpty:self.jgjChatListModel.msg_id] 历史数据或者已成功发送的数据
        if (isMine && moreThan2Min&&![NSString isEmpty:self.jgjChatListModel.msg_id]&&![recognizer.view isKindOfClass:[UITextView class]] && isCanRevo) {
            
//            if ([_jgjChatListModel.msg_type isEqualToString:@"pic"]) {
//
//                _cusMenuBtn = [[UIButton alloc] init];
//
//                self.cusMenuBtn = _cusMenuBtn;
//
//                UIImage *image = [UIImage imageNamed:@"chat_recall_icon"];
//
//                _cusMenuBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//
//                _cusMenuBtn.contentMode = UIViewContentModeCenter;
//
//                [_cusMenuBtn setImage:image forState:UIControlStateNormal];
//
//                [_cusMenuBtn addTarget:self action:@selector(recallActionPressed) forControlEvents:UIControlEventTouchUpInside];
//
//                _cusMenuBtn.hidden = NO;
//
//                UIView *convertView = self.window;
//
//                CGRect coverRect = [self.middleView convertRect:self.middleView.frame toView:convertView];
//
//                CGFloat x = coverRect.origin.x - (_jgjChatListModel.imageSize.width / 2);
//
//                CGFloat y = coverRect.origin.y - JGJ_NAV_HEIGHT - 10;
//
//                if (y < self.cusMenuBtn.height) {
//
//                    y = self.cusMenuBtn.height * 2;
//
//                }
//
//                _cusMenuBtn.frame = CGRectMake(x, y, self.cusMenuBtn.width, self.cusMenuBtn.height);
//
//                [self.window addSubview:_cusMenuBtn];
//
//                if ([self.delegate respondsToSelector:@selector(chatListBaseCell:cusMenuBtn:)]) {
//
//                    [self.delegate chatListBaseCell:self cusMenuBtn:self.cusMenuBtn];
//
//                }
//
//            }else {
//
//                UIMenuItem *revocationItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revocationClicked:)];
//
//                [menuControlArr addObject:revocationItem];
//
//            }
            
            UIMenuItem *revocationItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revocationClicked:)];
            
            [menuControlArr addObject:revocationItem];
            
        }
        
        //设置当前Cell为FirstResponder
        if (!self.super_textView) {
            
            [self becomeFirstResponder];
            
            //保留TextView为FirstResponder，同时其负责Menu显示
        }else {
            
            self.super_textView.targetCell = self;
        }
        
        [shareMenu setMenuItems:menuControlArr];
        [shareMenu setTargetRect:self.middleView.frame inView:self.middleView.superview];
        [shareMenu setMenuVisible:YES animated: YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideCallback:) name:UIMenuControllerDidHideMenuNotification object:shareMenu];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidShowCallback:) name:UIMenuControllerDidShowMenuNotification object:shareMenu];
    }
}

- (void)setMenuItem {
    
    
}

- (void)menuDidHideCallback:(NSNotification *)notify {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    
    ((UIMenuController *)notify.object).menuItems = nil;
    
    self.super_textView.targetCell = nil;
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenu:)]) {
        
        [self.delegate chatListBaseCell:self showMenu:NO];
    }
    
}

- (void)menuDidShowCallback:(NSNotification *)notify {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidShowMenuNotification object:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatListBaseCell:showMenu:)]) {
        
        [self.delegate chatListBaseCell:self showMenu:YES];
    }
    
}

- (void)avatarLongHandleTap:(UIGestureRecognizer*) recognizer {
    
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(longTouchAvatar:)]) {
            [self.delegate longTouchAvatar:self];
        }
    }
}
#pragma mark - 单击进入个人详情页
- (void)avatarHandleTap:(UITapGestureRecognizer *)tapGesture {
    TYLog(@"%s",__FUNCTION__);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tapTouchAvatar:)]) {
        [self.delegate tapTouchAvatar:self];
    }
}

- (void)setContentTextlinkAttWith:(JGJChatMsgListModel *)jgjChatListModel contentColor:(UIColor *)contentColor{
    
    // 转成可变属性字符串
    NSMutableAttributedString * mAttributedString = [NSMutableAttributedString new];
    
    // 调整行间距段落间距
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //    [paragraphStyle setLineSpacing:2];
    //    [paragraphStyle setParagraphSpacing:4];
    
    // 设置文本属性
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[self.contentLabel.font ? : FONT(15), contentColor, paragraphStyle] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName, NSParagraphStyleAttributeName]];
    [mAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:jgjChatListModel.msg_text ? : @"" attributes:attri]];
    
    // 匹配条件
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSError *error = NULL;
    // 根据匹配条件，创建了一个正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!regex) {
        NSLog(@"正则创建失败error！= %@", [error localizedDescription]);
    } else {
        NSArray *allMatches = [regex matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];
        for (NSTextCheckingResult *match in allMatches) {
            NSString *substrinsgForMatch2 = [mAttributedString.string substringWithRange:match.range];
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:substrinsgForMatch2];
            // 利用YYText设置一些文本属性
            one.yy_font = self.contentLabel.font;
            one.yy_underlineStyle = NSUnderlineStyleSingle;
            one.yy_color = AppFont4990e2Color;
            
            UIColor *changeColor = AppFont333333Color;
            
            if (jgjChatListModel.chatListType == JGJChatListText) {
                
                changeColor = AppFont4990e2Color;
                
                [one yy_setTextHighlightRange:one.yy_rangeOfAll color:changeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    
                    [JGJQuaSafeTool linkHandlerWithLinkUrl:text.string curView:self target:nil];
                    
                    TYLog(@"======= %@", text);
                }];
                
                // 根据range替换字符串
                [mAttributedString replaceCharactersInRange:match.range withAttributedString:one];
            }
            
        }
    }
    
    // 使用YYLabel显示
    
    self.contentLabel.userInteractionEnabled = YES;
    
    self.contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    mAttributedString.yy_lineSpacing = 4.0;
    
    self.contentLabel.attributedText = mAttributedString;
    
    //    // 利用YYTextLayout计算高度
    //    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(260, MAXFLOAT)];
    //    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text: mAttributedString];
    //    label.height = textLayout.textBoundingSize.height;
    
}

#pragma mark - 设置发送失败的图片

- (void)setSendfailureWithjgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel {
    
    //自己失败的消息才显示
    
    CGFloat sendTypeViewWH = 40;
    
    if (jgjChatListModel.belongType == JGJChatListBelongMine) {
        
        self.SendPicFailView.frame = CGRectMake(TYGetUIScreenWidth - jgjChatListModel.imageSize.width - 100, (jgjChatListModel.imageSize.height) / 2.0, sendTypeViewWH, sendTypeViewWH);
        
    }
    
    self.SendPicFailView.hidden = jgjChatListModel.sendType != JGJChatListSendFail || jgjChatListModel.belongType != JGJChatListBelongMine;
}

#pragma mark - 撤回图片消息

- (void)recallActionPressed {
    
    [self revocationClicked:nil];
    
}

//- (UIButton *)cusMenuBtn {
//
//    if (!_cusMenuBtn) {
//
//        _cusMenuBtn = [[UIButton alloc] init];
//
//        UIImage *image = [UIImage imageNamed:@"chat_recall_icon"];
//
//        _cusMenuBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//
//        _cusMenuBtn.contentMode = UIViewContentModeCenter;
//
//        [_cusMenuBtn setImage:image forState:UIControlStateNormal];
//
//        [_cusMenuBtn addTarget:self action:@selector(recallActionPressed) forControlEvents:UIControlEventTouchUpInside];
//
//        _cusMenuBtn.hidden = YES;
//    }
//
//    return _cusMenuBtn;
//}

@end


@implementation JGJChatDetailNextButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 图片
    UIImageView *imageView = self.imageView;
    // label
    UILabel *titleLabel = self.titleLabel;
    
    CGPoint center = imageView.center;
    center.x = self.frame.size.width *0.9;
    imageView.center = center;
    
    CGRect frame = titleLabel.frame;
    frame.size.width = self.frame.size.width*0.8;
    frame.origin.x = 0;
    
    // titleLabel的尺寸
    titleLabel.frame = frame;
    titleLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setChatListType:(JGJChatListType)chatListType{
    _chatListType = chatListType;
    
    NSArray *chatTypeArr = self.chatTypeDic[[NSString stringWithFormat:@"%@",@(_chatListType)]];
    
    
    if (chatTypeArr.count) {
        [self setTitle:@"查看详情" forState:UIControlStateNormal];
        [self setTitleColor:[chatTypeArr firstObject] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:(NSString *)[chatTypeArr lastObject]?:@""] forState:UIControlStateNormal];
    }else{
        [self setTitle:nil forState:UIControlStateNormal];
        [self setTitleColor:nil forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
}
#pragma mark - lazy
- (NSDictionary *)chatTypeDic
{
    if (!_chatTypeDic) {
        _chatTypeDic = @{
                         [NSString stringWithFormat:@"%@",@(JGJChatListNotice)]:@[TYColorHex(0x628ae0),@"Chat_listNotice_detailNext"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListLog)]:@[TYColorHex(0x85bf82),@"Chat_listLog_detailNext"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListSafe)]:@[TYColorHex(0xa779d5),@"Chat_listSafe_detailNext"],
                         [NSString stringWithFormat:@"%@",@(JGJChatListQuality)]:@[TYColorHex(0x74bed1),@"Chat_listQuality_detailNext"]
                         };
    }
    return _chatTypeDic;
}
@end
