//
//  YZGAudioAndPicTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGAudioAndPicTableViewCell.h"
#import "NSString+Extend.h"
#import "TYShowMessage.h"
#import "TYPermission.h"
#import "YZGAudioCallView.h"
#import "YZGPhoneCollectionViewCell.h"
#import "UILabel+GNUtil.h"
static const NSInteger collectionViewLineMaxNum = 4;//collection每行最多多少张图片
//static const CGFloat collectionViewMaxMargin = 10;//collection每行最大间距
static const CGFloat differenceValue = 50;//用于判断2个点之间的像素

@implementation AudioAndPicDataModel
@end

@interface YZGAudioAndPicTableViewCell ()
<
    TYTextViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    YZGAudioCallViewDelegate,
    AudioRecordingServicesDelegate,
    JLGPhoneCollectionViewCellDelegate
>
{
    CGFloat _audioViewLayoutWidth;
    NSString *_identifierStr;
    CGFloat _collectionCellMaxWH;//collectionCell最大的宽和高
    NSInteger _collectionViewMaxMargin;//collectionCell最大的间距
    
    //语音
    NSTimer *_timer;//定时器定时修改音量的值
    NSInteger _timerTime;//定时器的时长
    CGPoint _tempPoint;//用于判断是否上划
    NSInteger _endState;//结束时候的状态，是否需要发送

    AudioRecordingServices *_audioRecordingServices;
}

@property (nonatomic,assign) CGFloat audioButtonOldT_float;

@property (nonatomic,strong) YZGAudioCallView *callView;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPresssRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *picSingleTap;

@property (weak, nonatomic) IBOutlet UIView *longPressView;
@property (weak, nonatomic) IBOutlet UILabel *audioTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPicButton;
@property (weak, nonatomic) IBOutlet UIButton *addAudioButton;
@property (weak, nonatomic) IBOutlet UIButton *playAudioButton;

@property (weak, nonatomic) IBOutlet UILabel *audioDefaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraDefaultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *findHelper_deletePhone;
//constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewLayoutW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addAudioLayoutWH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesCollectionLayoutW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playAudioButtonLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playAudioButtonLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTVLayoutH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioButtonLayoutW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioButtonLayoutT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteLableH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addPicH;

@property (strong, nonatomic)  UIButton *backImageBtn;

@end

@implementation YZGAudioAndPicTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];

    [self registerNib];
    self.detailTV.TYTextDelegate = self;
    [self.detailTV setPlaceholderStr:@"此处请填写备注，也可以用下面照片记录" placeholderColor:AppFontccccccColor];
    [self.NoteLabel markText:@"(该备注信息仅对你自己可见)" withColor:AppFont999999Color];

    self.audioInfo = [NSMutableDictionary dictionary];
    _audioRecordingServices = [[AudioRecordingServices alloc] initWithDelegate:self];

    self.audioButtonOldT_float = self.audioButtonLayoutT.constant;
    
    //    self.detailTV.returnKeyType = UIReturnKeySend;
    self.detailTV.canReturn = YES;

    //添加长按事件
    self.longPresssRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.longPresssRecognizer.minimumPressDuration = 0.1;
    
    UILongPressGestureRecognizer *longPresssRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPresssRecognizer.minimumPressDuration = 0.1;
    [self.addAudioButton addGestureRecognizer:longPresssRecognizer];
    
    if(TYiOS8Later){
        self.playAudioButtonLayoutH.constant -= 0.3*TYGetViewH(self.audioView);
    }

    self.imagesCollection.delegate = self;
    self.imagesCollection.dataSource = self;
    
    //添加播放手势
    [self.longPressView addGestureRecognizer:self.longPresssRecognizer];
    
    //添加图片单击手势
    self.picSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picSingleTap:)];
    [self.addPicButton addSubview:self.backImageBtn];
}

- (UIButton *)backImageBtn
{
    if (!_backImageBtn) {
        _backImageBtn = [[UIButton alloc]initWithFrame:self.addPicButton.bounds];
        _backImageBtn.backgroundColor = AppFontf3f3f3Color;
        [_backImageBtn setImage:[UIImage imageNamed:@"startWork_BaskSkill"] forState:UIControlStateNormal];
        [_backImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        [_backImageBtn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
        _backImageBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _backImageBtn.userInteractionEnabled = NO;
        [self initupImageButton:self.backImageBtn];
    }
    return _backImageBtn;
}
-(void)initupImageButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height + 2 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-23.0, 6.8,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
- (void)setAudioCellType:(AudioCellType)audioCellType{
    _audioCellType = audioCellType;
    
    if (audioCellType == AudioCellTypeSign) {
        [self.detailTV setPlaceholderStr:@"请描述一下今天的工作情况吧，也可使用语音和图片描述" placeholderColor:AppFontccccccColor];
        self.audioDefaultLabel.text = @"按住说话,说说今天的工作情况吧";
        self.cameraDefaultLabel.text = @"点击拍照或者选择照片，分享一下今天的工作成果吧";
    }
}

- (void)setReadOnly:(BOOL)readOnly{
    _readOnly = readOnly;
    self.audioButtonLayoutW.constant = readOnly?0.0:52.0;
    self.findHelper_deletePhone.hidden = readOnly;
    
    [self.detailTV setContentColor:readOnly?TYColorHex(0x999999):TYColorHex(0x333333)];
    self.detailTV.userInteractionEnabled = !readOnly;
    
    self.audioDefaultLabel.hidden = readOnly;
    
    self.cameraDefaultLabel.hidden = readOnly;
}

- (void)donwloadAmr{
    if (_audioFileInfo) {
        __weak typeof(self) weakSelf = self;
        [JLGHttpRequest_AFN downloadWithUrl:_audioFileInfo[@"url"] success:^(NSString *fileURL,NSString *fileName) {
            NSDictionary *dic = [_audioRecordingServices decompressionAudioFileWith:fileURL fileName:fileName];
            [NSString removeFileByPath:fileURL];
            
            self.audioInfo[@"filePath"] = dic[@"filePath"];
            self.audioInfo[@"fileTime"] = _audioFileInfo[@"fileTime"];
            [weakSelf updateAudioViewLength];
        } fail:nil];
    }else if ([self.audioInfo[@"fileTime"] integerValue] != 0) {
        [self updateAudioViewLength];
    }
}

#pragma mark - 长按处理的事件
- (void)longPress:(UILongPressGestureRecognizer *)press {
    if (self.readOnly) {
        return ;
    }
    
    switch (press.state) {
        case UIGestureRecognizerStateBegan : {
            
            [self endEditing:YES];
            if ([TYPermission isCanRecordWithStr:@"请允许访问你的手机麦克风"]) {
                
                _endState = 1;
                [self.callView showAutioCallView];
                
                self.addAudioButton.highlighted = YES;
                [_audioRecordingServices startAudioRecording];
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {//change
            TYLog(@"change");
            CGPoint point = [press locationInView:self.contentView];
            if (point.y < _tempPoint.y - differenceValue) {//上划
                _endState = 0;//修改状态

                if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {//修改坐标
                    _tempPoint = point;
                }
            } else if (point.y > _tempPoint.y + differenceValue) {//下划
                _endState = 1;//修改状态

                if (!CGPointEqualToPoint(point, _tempPoint) && point.y > _tempPoint.y + 8) {//修改坐标
                    _tempPoint = point;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            TYLog(@"cancel, end");
            [_timer invalidate];
            _timer = nil;
            _timerTime = 0;
            
            //最后先结束录音，因为保存文件需要时间
            [_audioRecordingServices stopAudioRecording];
            self.addAudioButton.highlighted = NO;
            break;
        }
        case UIGestureRecognizerStateFailed: {
            TYLog(@"failed");
            break;
        }
        default: {
            break;
        }
    }
}

- (void)endPress {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isDelay = NO;//是否延迟消失
        NSInteger fileTime = [self.audioInfo[@"fileTime"] integerValue];
        if (_endState == 1) {
            if (fileTime > 59) {
                TYLog(@"不正常:时间太长");
                isDelay = YES;
                self.callView.yzgAudioCallRecondType = YZGAudioCallTypeTooLong;
                self.audioInfo[@"amrFilePath"] = [_audioRecordingServices compressionAudioFileWith:self.audioInfo[@"fileName"]][@"filePath"];
                [self updateAudioViewLength];
            }else if(fileTime < 1){
                TYLog(@"不正常:时间太短");
                isDelay = YES;
                self.callView.yzgAudioCallRecondType = YZGAudioCallTypeTooShort;
            }else{
                TYLog(@"正常:发送出去");

                self.audioInfo[@"amrFilePath"] = [_audioRecordingServices compressionAudioFileWith:self.audioInfo[@"fileName"]][@"filePath"];
                [self updateAudioViewLength];
            }
        }
        
        if (isDelay) {//如果时间不在范围内，则显示对应的状态
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.callView hiddenAutioCallView];
                self.callView = nil;
            });
        }else{
            [self.callView hiddenAutioCallView];
            self.callView = nil;
        }
    });
}

- (void)picSingleTap:(UITapGestureRecognizer *)singleRecognizer {
    [self addPicBtnClick:self.addPicButton];
}

#pragma mark - 修改显示的图片
- (void)changeImage {
    if (_timerTime >= 600) {
        _timerTime = 0;
        [_audioRecordingServices stopAudioRecording];
    }
    
    _timerTime++;
    self.callView.yzgAudioCallRecondType = _endState == 0?YZGAudioCallTypeStop:YZGAudioCallTypeReconding;
    
    if (_endState != 0) {
        [self.callView updateAudioLevel:[_audioRecordingServices updateMeters]];
    }
}

#pragma mark - 修改显示的图片
- (void)changePlayImage {
    NSInteger tag;
    if ([_audioRecordingServices isPlaying]) {
        tag = self.playAudioButton.tag/10;
    }else{
        tag = 3;
        [_timer invalidate];
        _timer = nil;
    }
    NSString *picString = [NSString stringWithFormat:@"RecordWorkpoints_Audio_Ear%@",@(tag)];
    [self.playAudioButton setImage:[UIImage imageNamed:picString] forState:UIControlStateNormal];
    tag > 3?tag = 1:++tag;
    self.playAudioButton.tag = tag*10;
}

#pragma mark - 注册collectionCell
- (void)registerNib{
    //设置collectionView
    if (self.imagesCollection.delegate == nil) {
        self.imagesCollection.delegate = self;
    }
    
    if (self.imagesCollection.dataSource == nil) {
        self.imagesCollection.dataSource = self;
    }
    
    //注册一般显示的照片collection
    _identifierStr = NSStringFromClass([YZGPhoneCollectionViewCell class]);
    UINib *nib = [UINib nibWithNibName:_identifierStr
                                bundle: [NSBundle mainBundle]];
    [self.imagesCollection registerNib:nib forCellWithReuseIdentifier:_identifierStr];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //设置collectionView的frame
    self.imagesCollectionLayoutW.constant = (NSInteger )(TYGetUIScreenWidth - 30 - self.addAudioLayoutWH.constant);
    [self.imagesCollection layoutIfNeeded];//修改约束以后，对应的子view的约束也要更新
    
    //重新计算collectionCell的宽度和高度
    _collectionCellMaxWH = TYGetViewH(self.imagesCollection);
    _collectionViewMaxMargin = (self.imagesCollectionLayoutW.constant - _collectionCellMaxWH*collectionViewLineMaxNum)/(collectionViewLineMaxNum - 1);
    
    [self.imagesCollection reloadData];

    _audioViewLayoutWidth = self.imagesCollectionLayoutW.constant;

    //下载amr文件
    [self donwloadAmr];
}

#pragma mark - 点击添加照片
- (IBAction)addPicBtnClick:(UIButton *)sender {
    if (self.readOnly) {
        return ;
    }
    
    if (self.imagesArray.count > 4) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你最多只能选择%4张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioAndPicAddPicBtnClick:)]) {
        [self.delegate AudioAndPicAddPicBtnClick:self];
    }
}

#pragma mark - 点击录音播放
- (IBAction)playOrStopAudioBtnClick:(id)sender {
    TYLog(@"点击了播放");
    if ([_audioRecordingServices isPlaying]) {
        [_timer invalidate];
        _timer = nil;
        [_audioRecordingServices stopPlay];
    }else{
        self.playAudioButton.tag = 10;//最开始的tag为10,主要是可以设置不同的照片
        [_audioRecordingServices setPlayAudioWithFilePath:self.audioInfo[@"filePath"]];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changePlayImage) userInfo:nil repeats:YES];
    }
}

#pragma mark - 删除录音
- (IBAction)deleteAudioBtnClick:(id)sender {
    if (self.readOnly) {
        return;
    }
    
    [_audioRecordingServices stopPlay];
    self.audioView.hidden = YES;

    self.audioDefaultLabel.hidden = NO;
    [NSString removeFileByPath:self.audioInfo[@"filePath"]];//只删除对应的音频文件
    self.audioInfo[@"fileTime"] = @0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioAndPicAddAudio:audioInfo:)]) {
        [self.delegate AudioAndPicAddAudio:self audioInfo:self.audioInfo];
    }
}


#pragma mark - 语音的代理回调方法
- (void)getRecordAudioInfoDic:(NSDictionary *)audioInfo{
    self.audioInfo = [audioInfo mutableCopy];
    
    [self endPress];
}

- (void)updateAudioViewLength{

    //设置语音的时间
    CGFloat fileTime = [self.audioInfo[@"fileTime"] floatValue];
    self.audioView.hidden = (fileTime == 0);
    self.audioDefaultLabel.hidden = !(fileTime == 0);

    //time范围,20~60s
    CGFloat audioLayoutTime = MAX(20, fileTime);
    audioLayoutTime = MIN(60, audioLayoutTime);
    
    //    NSInteger layoutW = _audioViewLayoutWidth*audioLayoutTime/60.0;//60s
    NSInteger layoutW = 100;
    self.playAudioButtonLayoutW.constant = layoutW*0.8;
    self.audioViewLayoutW.constant = layoutW;
    [self.audioView layoutIfNeeded];
    
    self.audioTimeLabel.text = [NSString stringWithFormat:@"%@\"",@(fileTime)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioAndPicAddAudio:audioInfo:)]) {
        [self.delegate AudioAndPicAddAudio:self audioInfo:self.audioInfo];
    }
}

#pragma mark - collection的delegate
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.imagesArray.count;
    
    if (count > 0) {
        [self.imagesCollection removeGestureRecognizer:self.picSingleTap];
    }else{
        [self.imagesCollection addGestureRecognizer:self.picSingleTap];
    }
    
    self.cameraDefaultLabel.hidden = self.readOnly?YES:!(count == 0);
    count = count >= (collectionViewLineMaxNum + 1) ?collectionViewLineMaxNum:count;
    return count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionCellMaxWH,_collectionCellMaxWH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.imagesArray.count == 0 || self.imagesArray.count < indexPath.row) {
        return nil;
    }
    
    YZGPhoneCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YZGPhoneCollectionViewCell class]) forIndexPath:indexPath];
    
    collectionCell.indexPath = indexPath;
    
    if ([self.imagesArray[indexPath.row] isKindOfClass:[NSString class]]) {
        NSString *url = [JLGHttpRequest_Public stringByAppendingString:self.imagesArray[indexPath.row]];
        collectionCell.picUrl = url;
    }else{
        collectionCell.backImage = self.imagesArray[indexPath.row];
    }
    
    collectionCell.showDeleteButton = !self.readOnly;
    
    if (!collectionCell.delegate) {
        collectionCell.delegate = self;
    }

    return collectionCell;
}

#pragma mark - 点击了collection
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(AudioAndPicCellphoneDidSelected:Index:)]) {
        [self.delegate AudioAndPicCellphoneDidSelected:self Index:indexPath.row];
    }
}

#pragma mark - 点击了每个图片的删除按钮
- (void)deleteBtnClick:(YZGPhoneCollectionViewCell *)phoneCollectionCell{
    if (self.readOnly) {
        return;
    }
    
    //删除以后就重新刷新
    NSInteger deletePicIndex = phoneCollectionCell.indexPath.row;
    
    [self.imagesArray removeObjectAtIndex:deletePicIndex];
    
    [self.imagesCollection reloadData];
    
    if ([self.delegate respondsToSelector:@selector(AudioAndPicCellDelete:Index:)]) {
        [self.delegate AudioAndPicCellDelete:self Index:deletePicIndex];
    }
}

#pragma mark - 编辑
#pragma mark 结束编辑
- (void)TYTextViewDidEndEditing:(NSString *)textStr{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioAndPicCellTextFiledEndEditing:textStr:)]) {
        [self.delegate AudioAndPicCellTextFiledEndEditing:self textStr:textStr];
    }
}

#pragma mark 开始编辑
- (void)TYTextViewBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioAndPicCellTextFiledBeginEditing:textView:)]) {
        [self.delegate AudioAndPicCellTextFiledBeginEditing:self textView:textView];
    }
}

- (void)TYTextViewDidChange:(UITextView *)textView{
    self.detailTVLayoutH.constant = MAX(45,textView.contentSize.height);


    if (self.delegate && [self.delegate respondsToSelector:@selector(AudioAndPicCellTextViewDidChange:textViewHeight:)]) {
        [self.delegate AudioAndPicCellTextViewDidChange:textView textViewHeight:self.detailTVLayoutH.constant];
        
        id<UITableViewDelegate> delegate = (id<UITableViewDelegate>)self.tableView.delegate;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
        [delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - 获取音频信息
- (AudioAndPicDataModel *)getNotesInfo{
    AudioAndPicDataModel *audioAndPicModel = [AudioAndPicDataModel new];
    audioAndPicModel.detailTFText = self.detailTV.getText;
    audioAndPicModel.audioInfo = self.audioInfo;
    audioAndPicModel.imagesArray = [self.imagesArray copy];

    return audioAndPicModel;
}

#pragma mark - Audio Recorder
//新增api,获取录音权限. 返回值,YES为可以,NO为拒绝录音.
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    
    return bCanRecord;
}

- (CGFloat )getiAudioHeight:(NSString *)notes_txt textViewHeight:(CGFloat )textViewHeight isreadOnly:(BOOL)isread{
    CGFloat cellHeight = 0;
    self.detailTV.text = [NSString isEmpty:notes_txt]?self.detailTV.getText:notes_txt;
    CGFloat maxNoteY = TYGetMaxY(self.NoteLabel);
    CGFloat buttonH = 2*TYGetViewH(self.addPicButton);
    CGFloat allMargin = (5 + 20*3);//(5 + 20*3)
    CGFloat detailTVH = textViewHeight?:self.detailTVLayoutH.constant;
    //    cellHeight = maxNoteY + buttonH + allMargin + detailTVH;
#pragma mark - 修改
    if (isread) {
    cellHeight =  maxNoteY + buttonH + allMargin + [self RowHeight:self.detailTV.text];
        //        cellHeight = maxNoteY + buttonH + allMargin + detailTVH;
    }else{
        
    cellHeight = maxNoteY + buttonH + allMargin + detailTVH+2;
        //        cellHeight =  maxNoteY + buttonH + allMargin + [self RowHeight:self.detailTV.text]-20;
    }
    
    return cellHeight;
}

- (CGFloat )getMediaHeightWithAddSignModel:(JGJAddSignModel *)addSignModel textViewHeight:(CGFloat )textViewHeight isReadOnly:(BOOL)isRead {
    CGFloat cellHeight = 0;
    self.detailTV.text = [NSString isEmpty:addSignModel.sign_desc]?self.detailTV.getText:addSignModel.sign_desc;
    CGFloat maxNoteY = TYGetMaxY(self.NoteLabel);
    CGFloat buttonH = 2*TYGetViewH(self.addPicButton);
    CGFloat allMargin = (5 + 20*3);//(5 + 20*3)
    CGFloat detailTVH = textViewHeight?:self.detailTVLayoutH.constant;
    //    cellHeight = maxNoteY + buttonH + allMargin + detailTVH;
#pragma mark - 修改
    if (isRead) {
        cellHeight =  maxNoteY + buttonH + allMargin + [self RowHeight:self.detailTV.text];
        //        cellHeight = maxNoteY + buttonH + allMargin + detailTVH;
    }else{
        
        cellHeight = maxNoteY + buttonH + allMargin + detailTVH+2;
        //        cellHeight =  maxNoteY + buttonH + allMargin + [self RowHeight:self.detailTV.text]-20;
    }
    
    
    if (isRead) {
        
        if ([NSString isEmpty:addSignModel.sign_voice]) {
            
            self.addAudioLayoutWH.constant = 0;
            self.addAudioButton.hidden = YES;
            cellHeight -= 52.0;
            self.lineView.hidden = YES;
        }
        
        if ([NSString isEmpty:addSignModel.sign_desc]) {
            
            self.detailTVLayoutH.constant = 0;
            self.detailTV.hidden = YES;
            self.noteLableH.constant = 0;
            self.NoteLabel.hidden = YES;
            cellHeight -= TYGetMaxY(self.lineView);
        }
        
        if (addSignModel.sign_pic.count == 0) {
            
            self.addPicButton.hidden = YES;
            self.addPicH.constant = 0;
            cellHeight -= 52.0;
        }
        
    }
    self.NoteLabel.text = @"q2e23434";
    self.lineView.hidden = YES;
    return cellHeight;
}

-(CGFloat)getiAudioHeight:(NSString *)notes_txt textViewHeight:(CGFloat)textViewHeight
{
    CGFloat cellHeight = 0;
    self.detailTV.text = [NSString isEmpty:notes_txt]?self.detailTV.getText:notes_txt;
    CGFloat maxNoteY = TYGetMaxY(self.NoteLabel);
    CGFloat buttonH = 2*TYGetViewH(self.addPicButton);
    CGFloat allMargin = (5 + 20*3);//(5 + 20*3)
    CGFloat detailTVH = textViewHeight?:self.detailTVLayoutH.constant;
    cellHeight = maxNoteY + buttonH + allMargin + detailTVH + 40;
    return cellHeight;
}
-(float)RowHeight:(NSString *)Str
{
    UILabel *lable = [[UILabel alloc]init];
    lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:15.5];
    lable.text = Str;
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    lable.textColor = [UIColor darkTextColor];
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-10, 1000);
    CGSize expectSize = [lable sizeThatFits:maximumLabelSize];
    
    return expectSize.height;
}

- (void)configAudioData:(YZGGetBillModel *)yzgGetBillModel parametersDic:(NSMutableDictionary *)parametersDic deleteImgsArray:(NSMutableArray *)deleteImgsArray imagesArray:(NSMutableArray *)imagesArray{
    AudioAndPicDataModel *audioAndPicData;
    
    yzgGetBillModel.notes_txt = self.detailTV.getText;
    audioAndPicData = [self getNotesInfo];
    
    if (self.audioView.hidden) {//如果是删除或者没有录
        parametersDic[@"voice_length"] = @0;
    }
    
    //获取音频文件
    NSMutableArray *dataArray = yzgGetBillModel.dataArr;
    NSMutableArray *dataNameArray = yzgGetBillModel.dataNameArr;
    if (audioAndPicData) {
        if (audioAndPicData.audioInfo[@"amrFilePath"]) {
            [dataNameArray addObject:@"voice"];
            [dataArray addObject:audioAndPicData.audioInfo[@"amrFilePath"]];
        }
        
        NSInteger voiceLength = [audioAndPicData.audioInfo[@"fileTime"] integerValue];
        if (voiceLength > 0) {
            //获取音频长度
            parametersDic[@"voice_length"] = @(voiceLength);
        }
    }
    
    //删除的图片
    if (deleteImgsArray.count != 0) {
        parametersDic[@"delimg"] = [deleteImgsArray componentsJoinedByString:@";"];
    }
    
    //提交增加的图片,imagesArray是继承父类的，所以不用修改
    [imagesArray removeAllObjects];
    [audioAndPicData.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            [imagesArray addObject:obj];
        }
    }];
}

- (void )configureAudioAndPicCell:(NSDictionary *)dataDic showVc:(UIViewController <YZGAudioAndPicTableViewCellDelegate,UICollectionViewDelegate>*)showVc imagesArray:(NSMutableArray *)imagesArray{
    
    self.delegate = showVc;
    self.detailTV.text = dataDic[@"notes_txt"];
    

    self.imagesArray = [imagesArray mutableCopy];
    self.imagesCollection.delegate = showVc;
    
    NSString *notes_voice = dataDic[@"notes_voice"];
    NSString *voice_length = dataDic[@"voice_length"];
    if ([notes_voice containsString:@"/Audio/"]) {//说明已经转换成本地音频路径了
        self.audioFileInfo = nil;
        self.audioInfo = [@{@"filePath":notes_voice?:@"",@"fileTime":voice_length?:@"",@"amrFilePath":dataDic[@"amrFilePath"]?:@""} mutableCopy];
    }else if(notes_voice && ![notes_voice isEqualToString:@""]){//是要通过url下载文件
        self.audioFileInfo = @{@"url":notes_voice,@"fileTime":voice_length};
    }
    
    //只是查看的时候
    if (self.readOnly) {
        self.audioButtonLayoutT.constant = [voice_length integerValue] > 0?self.audioButtonOldT_float:-50;
        self.audioView.hidden = !([voice_length integerValue] > 0);
#pragma mark -修改
     self.detailTVLayoutH.constant = MAX(45,self.detailTV.contentSize.height);
        /*
        if (self.readOnly) {
            self.detailTVLayoutH.constant = MAX(45,[self RowHeight:self.detailTV.text]);
        }else{
            self.detailTVLayoutH.constant = MAX(45,self.detailTV.contentSize.height);
        }
         */

    }
}

#pragma mark - 懒加载
- (YZGAudioCallView *)callView
{
    if (!_callView) {
        _callView = [[YZGAudioCallView alloc] init];
        _callView.delegate = self;
    }
    return _callView;
}

- (NSMutableDictionary *)audioInfo
{
    if (!_audioInfo) {
        _audioInfo = [[NSMutableDictionary alloc] init];
    }
    return _audioInfo;
}

- (void)mediaCellStopAudio {

    if (_audioRecordingServices.isPlaying) {
        
        [_audioRecordingServices stopAudioRecording];
        
    }
}

@end
