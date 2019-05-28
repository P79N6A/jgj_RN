//
//  JGJChatSignVc.m
//  JGJCompany
//
//  Created by Tony on 16/9/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignVc.h"
#import "NSDate+Extend.h"
#import "JGJChatRootVc.h"
#import "NSString+Extend.h"
#import "JGJChatSignTimeCell.h"
#import "JGJChatSignAddressCell.h"
#import "YZGAudioAndPicTableViewCell.h"
#import "JLGBaseBMapView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "JGJChatSignMapCell.h"

#import "JGJSignRemarkCell.h"

#import "JGJAdjustSignLocaVc.h"

#import "JGJAdjustButtonSignCell.h"

#import "IQKeyboardManager.h"

#import "NSString+Extend.h"

#import "AFNetworkReachabilityManager.h"

#import "JLGAddProExperienceTableViewCell.h"

#import "JGJCommonTitleCell.h"

typedef enum : NSUInteger {
    JGJSignCellTimeType,
    JGJSignCellAddressType,
    JGJSignCellAddressAdjustType,
    JGJSignCellMapCellType,
    JGJSignCellRemarkTitleType,
    JGJSignCellRemarkTextType,
    JGJSignCellRemarkMediaCellType
} JGJSignCellType;

@interface JGJChatSignVc ()
<
UICollectionViewDelegate,
YZGAudioAndPicTableViewCellDelegate,
BMKMapViewDelegate,
BMKLocationServiceDelegate,
JGJSignRemarkCellDelegate,
BMKGeoCodeSearchDelegate,
JGJSignRemarkCellDelegate,

JLGMYProExperienceTableViewCellDelegate

>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKPointAnnotation *_pointAnnotation;
    CLLocationCoordinate2D coor;
    YZGAudioAndPicTableViewCell *audioPicCell ;
    
    //    int Cellheight;
    
}
@property (nonatomic,strong) YZGAudioAndPicTableViewCell *audioCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutH;

@property (nonatomic,strong) CustomAlertView *alertView;
@property (nonatomic,strong) JLGBaseBMapView *mapview;
@property (nonatomic, strong) JGJChatSignMapCell *signMapCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JGJCreatTeamModel *desModel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation JGJChatSignVc

@synthesize tableView = _tableView;

- (void)commonInit{
    [super commonInit];
    
    self.isNeedWatermark = YES;
    self.addSignModel = [[JGJAddSignModel alloc] init];
    self.maxImageCount = 9;
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [TYNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];

    [TYNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //如果存在sign_id说明是查看，不用修改的
    if (![NSString isEmpty:self.sign_id]) {
        
        //查看类型
        self.signVcType = JGJChatSignVcCheckType;
        self.title = @"签到详情";
        self.bottomViewLayoutH.constant = 0.0;
        
        self.bottomView.hidden = YES;
        
        
        NSDictionary *parameters = @{
                                     @"sign_id":self.sign_id?:@""
                                     };
        
        [JLGHttpRequest_AFN PostWithNapi:@"sign/sign-record-detaill" parameters:parameters success:^(id responseObject) {
            
            self.addSignModel = [JGJAddSignModel mj_objectWithKeyValues:responseObject];
            
            self.imagesArray = self.addSignModel.sign_pic.mutableCopy;
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            
        }];

        
    }else{
        self.addSignModel.sign_time = [NSDate stringFromDate:[NSDate date] format:@"HH:mm"];

        
    }
    
    [self startLocation];
    
    self.bottomDistance.constant = 150;
    
//    [IQKeyboardManager sharedManager].enable = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        for (NSInteger indx = 0; indx < 5; indx++) {
            
            if ([NSString isEmpty:self.addSignModel.sign_addr] && [NSString isEmpty:self.addSignModel.sign_addr2]) {
                
                [_locService startUserLocationService];
                
            }else {
                
                break;
                
            }
        }
        
    });
    
}
//地图启动定位
- (void)startLocation{
    
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    CGPoint point = [tap locationInView:self.tableView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    
    BOOL isContain = CGRectContainsPoint(rectInTableView, point);

    if (!isContain) {
        
        [self.view endEditing:YES];
    }

}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 7;
    return count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 40.0;
    JGJSignCellType signCellType = indexPath.row;
    switch (signCellType) {
        case JGJSignCellTimeType:
            height = 40.0;
            break;
        case JGJSignCellAddressType:{
            
            height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 100 content:self.addSignModel.sign_addr font:AppFont28Size] + 35;
        }
            break;
            
        case JGJSignCellAddressAdjustType:{
            
            height = self.signVcType == JGJChatSignVcUseType ? 40.0 : 0;
        }
            break;
            
        case JGJSignCellMapCellType:{
            
            height = TYGetUIScreenWidth * 0.7;
            
            if (self.signVcType == JGJChatSignVcCheckType && [NSString isEmpty:self.addSignModel.coordinate]) {
                
                height = 10;
            }
            
        }
            
            break;
            
        case JGJSignCellRemarkTitleType:{
            
            height = (![NSString isEmpty:_addSignModel.sign_desc] || [NSString isEmpty:self.sign_id]) || self.imagesArray.count > 0 ? 20 : CGFLOAT_MIN;
        }
            break;
            
        case JGJSignCellRemarkTextType:{
            
            if (self.signVcType == JGJChatSignVcCheckType) {
                
                height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 30 content:self.addSignModel.sign_desc font:AppFont28Size lineSpace:0] + 30;
                
                height = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 25 font:AppFont28Size lineSpace:3 content:self.addSignModel.sign_desc] + 35;
                
                if ([NSString isEmpty:self.addSignModel.sign_desc]) {
                    
                    height = CGFLOAT_MIN;
                }
                
            }else {
                
                height = 100;
            }
            
        }
            break;

            
        case JGJSignCellRemarkMediaCellType:{
            
            JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
            
            NSInteger count = self.imagesArray.count;
            
            CGFloat offset = CGFLOAT_MIN;
            
            if (TYIS_IPHONE_5) {
                
                offset = (count == 3 || count == 6) ? 113 : CGFLOAT_MIN;
                
            }else {
                
                offset = (count == 4 || count == 8) ? 113 : CGFLOAT_MIN;
                
            }
            
            CGFloat imagesH = [cell getHeightWithImagesArray:self.imagesArray];
            
            if (self.signVcType == JGJChatSignVcCheckType) {
                
                height =  self.imagesArray.count > 0 ? imagesH - offset : CGFLOAT_MIN;
                
            }else {
                
                height = imagesH;
            }

        }
            break;
        default:
            break;
    }
    
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    JGJSignCellType signCellType = indexPath.row;
    switch (signCellType) {
        case JGJSignCellTimeType:{
            JGJChatSignTimeCell *chatSignTimeCell = [JGJChatSignTimeCell cellWithTableView:tableView];
            chatSignTimeCell.addSignModel = self.addSignModel;
            
            cell = chatSignTimeCell;
        }
            
            break;
        case JGJSignCellAddressType:{
            JGJChatSignAddressCell *chatSignAddressCell = [JGJChatSignAddressCell cellWithTableView:tableView];
            chatSignAddressCell.addSignModel = self.addSignModel;
            
            chatSignAddressCell.lineView.hidden = self.signVcType == JGJChatSignVcUseType;
            
            cell = chatSignAddressCell;
            
        }
            
            break;
            
        case JGJSignCellAddressAdjustType:{
            
            JGJAdjustButtonSignCell *adjustButtonSignCell = [JGJAdjustButtonSignCell cellWithTableView:tableView];
            
            adjustButtonSignCell.adjustButton.hidden = self.signVcType != JGJChatSignVcUseType;
            
            adjustButtonSignCell.retryLocalButton.hidden = self.signVcType != JGJChatSignVcUseType;
            
            __weak typeof(self) weakSelf = self;
            
            adjustButtonSignCell.handleAdjustButtonSignCellBlock = ^(JGJAdjustButtonSignCell *cell) {
                
                if (cell.buttonSignType == JGJRetryButtonSignType) {
                    
                    [weakSelf handleRetryButtonSignAction];
                    
                }else {
                    
                   [weakSelf handleAdjustButtonPressed:weakSelf.addSignModel];
                }
            
            };
            
            return adjustButtonSignCell;
        }
            
            break;
        case JGJSignCellMapCellType:{
            JGJChatSignMapCell *signMapCell = [JGJChatSignMapCell cellWithTableView:tableView];
            self.signMapCell = signMapCell;
            self.signMapCell.mapView.delegate = self;
            if (![NSString isEmpty:self.addSignModel.coordinate]) {
                NSArray *coordinates = [self.addSignModel.coordinate componentsSeparatedByString:@","];
                if (coordinates.count == 2) {
                    NSString *longitude = coordinates[0];
                    NSString *latitude = coordinates[1];
                    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]);//纬度，经度
                    _pointAnnotation.coordinate = coords;
                    self.signMapCell.mapView.centerCoordinate = coords;
                    
                    [self mapAddAnnotationWithAnnotation:_pointAnnotation];
                }
            }
            
            signMapCell.hidden = NO;
            if (self.signVcType == JGJChatSignVcCheckType && [NSString isEmpty:self.addSignModel.coordinate]) {
                signMapCell.hidden = YES;
            }
            
            signMapCell.addSignModel = self.addSignModel;
            cell = signMapCell;
            
        }
            
            break;
            
        case JGJSignCellRemarkTitleType:{
            
            JGJCommonTitleCell *remarkTitleCell = [JGJCommonTitleCell cellWithTableView:tableView];
            
            remarkTitleCell.desModel = self.desModel;

            remarkTitleCell.textInsets = UIEdgeInsetsMake(0, 0, -12, 0);
            
            cell = remarkTitleCell;
        }
            
            break;
            
        case JGJSignCellRemarkTextType:{
            
            JGJSignRemarkCell *remarkCell = [JGJSignRemarkCell cellWithTableView:tableView];
            
            remarkCell.delegate = self;
            
            remarkCell.isCheckSignInfo = ![NSString isEmpty:self.sign_id];
            
            remarkCell.addSignModel = self.addSignModel;
            
            cell = remarkCell;
            
        }
            break;
            
        case JGJSignCellRemarkMediaCellType: {
            
            cell = [self registerSignSelImageTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)registerSignSelImageTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLGAddProExperienceTableViewCell *mulImageCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
    
    mulImageCell.delegate = self;
    
    mulImageCell.hiddenEditButton = self.signVcType == JGJChatSignVcCheckType;
    
    mulImageCell.imagesCollectionCell.hiddenAddButton = self.signVcType == JGJChatSignVcCheckType;
    
    mulImageCell.imagesCollectionCell.showDeleteButton = self.signVcType == JGJChatSignVcUseType;
    
    mulImageCell.imagesArray = self.imagesArray.mutableCopy;
    
    __weak typeof(self) weakSelf = self;
    mulImageCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
        [weakSelf removeImageAtIndex:index];
        
        //取出url
        __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
        [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [deleteUrlArray addObject:obj];
            }
        }];
        
        [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    return  mulImageCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.imagesArray.count) {
        return ;
    }
    
    self.imageSelectedIndex = indexPath.row;
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
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
    if (textStr.length>150) {
        self.addSignModel.sign_desc = [textStr substringToIndex:150];
    }else{
        self.addSignModel.sign_desc = textStr;
    }
}



- (void)AudioAndPicCellTextViewDidChange:(UITextView *)textView textViewHeight:(CGFloat )textViewHeight{
    self.addSignModel.sign_desc = textView.text;
    self.addSignModel.textViewHeight = textViewHeight;
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
        self.addSignModel.sign_voice = nil;
        self.addSignModel.sign_voice_amr_file = nil;
        self.addSignModel.sign_voice_time = 0;
    }else{
        self.addSignModel.sign_voice_wav_file = audioInfo[@"filePath"];
        if (audioInfo[@"amrFilePath"]) {
            self.addSignModel.sign_voice_amr_file = audioInfo[@"amrFilePath"];
        }
        
        self.addSignModel.sign_voice_time = audioInfo[@"fileTime"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)releaseNoticeBtnClick:(id)sender {
    
    if(([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
        
        [TYShowMessage showError:@"请进入系统:\n【设置】->【隐私】->【定位服务】\n中开启定位服务"];
        return;
    }
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    AFNetworkReachabilityStatus status = manger.networkReachabilityStatus;
    
    if (status == AFNetworkReachabilityStatusNotReachable) {
        
        [TYShowMessage showPlaint:@"当前网络不可用"];
        
        return;
    }
    
    if (!coor.latitude||!coor.longitude || ([NSString isEmpty:self.addSignModel.sign_addr] && [NSString isEmpty:self.addSignModel.sign_addr2])) {
        
        [TYShowMessage showError:@"获取你的位置失败，请重新定位"];
        
        return;
    }
    
    self.alertView = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
    
    [self.alertView showProgressImageView:@"正在签到..."];
    //图片和语音都有的情况

    //防止重复点击
    
     self.releaseButton.enabled = NO;
    
    [self uploadSignServiceRequest];
    
    //刷新签到列表数据
    [self freshDataList];
}

- (void)uploadSignServiceRequest{
    
    __block NSString *sign_voice = [NSString string];
    __block NSMutableArray *dataArr = [NSMutableArray array];
    
//    if (responseObject) {
//        [responseObject enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj hasSuffix:@"amr"]) {
//                sign_voice = obj;
//            }else{
//                [dataArr addObject:obj];
//            }
//        }];
//    }
    
    NSString *latitude ;
    NSString *longitude;
    if (coor.latitude) {
        latitude = [NSString stringWithFormat:@"%f",coor.latitude];
        longitude = [NSString stringWithFormat:@"%f",coor.longitude];
        
    }else{
        latitude = @"";
        longitude = @"";
    }
    
    //    if ([self.addSignModel.sign_desc isEqualToString:@"请描述一下今天的工作情况吧"]) {
    //        self.addSignModel.sign_desc = @"";
    //    }
    
    if ([NSString isEmpty:self.addSignModel.sign_desc]) {
        
        self.addSignModel.sign_desc = @"";
    }
    
    if ([NSString isEmpty:longitude] && [NSString isEmpty:latitude]) {
        
        [TYShowMessage showPlaint:@"暂未定位成功，请稍候。"];
        
        return;
    }
    
    NSString *sign_pic = [dataArr componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"ctrl":@"team",
                                 @"action":@"signIn",
                                 @"class_type" : self.workProListModel.class_type?:@"team",
                                 @"group_id":self.workProListModel.group_id?:@"",
                                 @"sign_addr":self.addSignModel.sign_addr?:@"",
                                 @"sign_addr2":self.addSignModel.sign_addr2?:@"",
                                 @"sign_desc":self.addSignModel.sign_desc?:@"",
                                 @"sign_voice":sign_voice?:@"",
                                 @"sign_voice_time":self.addSignModel.sign_voice_time?:@"",
                                 @"sign_pic":sign_pic?:@"",
                                 @"coordinate":[NSString stringWithFormat:@"%@,%@",longitude,latitude]
                                 
                                 };
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"sign/sign-in" parameters:parameters imagearray:self.imagesArray otherDataArray:self.imagesArray dataNameArray:nil success:^(NSArray *responseObject) {
        
        [TYShowMessage showSuccess:@"签到成功"];

        [self.alertView dismissWithBlcok:nil];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *res = (NSDictionary *)responseObject;
            
            [self pubSuccessWithResponse:res];
        }
        
         self.releaseButton.enabled = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [self.alertView  dismissWithBlcok:nil];
        
        self.releaseButton.enabled = YES;
        
    }];

//    [JLGHttpRequest_AFN PostWithNapi:@"sign/sign-in" parameters:parameters success:^(id responseObject) {
//
//        [TYShowMessage showSuccess:@"签到成功"];
//
//        [self.alertView dismissWithBlcok:nil];
//
//        [self.navigationController popViewControllerAnimated:YES];
//
//    } failure:^(NSError *error) {
//
//        [self.alertView  dismissWithBlcok:nil];
//    }];
    
}

- (void)pubSuccessWithResponse:(NSDictionary *)response {
    
    //    TYLog(@"插入数据库==========%@", response);
    
    
    //是发质量安全存数据库
    
    JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:response];
    
    if (![NSString isEmpty:msgModel.msg_id] && ![NSString isEmpty:msgModel.msg_type]) {
        
        JGJChatMsgListModel *msgModel = [JGJChatMsgListModel mj_objectWithKeyValues:response];
        
        msgModel.msg_text = @"你已签到";
        
        msgModel.msg_type = @"signIn";
        
        msgModel.local_id = [JGJChatMsgDBManger localID];
        
        //读状态
        [JGJSocketRequest receiveMySendMsgModel:msgModel isReaded:YES];
        
        
        [JGJSocketRequest receiveMySendMsgWithMsgs:@[msgModel] action:@"sendMessage"];
        
        //取消读状态
        [JGJSocketRequest receiveMySendMsgModel:msgModel isReaded:NO];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    if (!self.sign_id) {
        [_mapView updateLocationData:userLocation];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _pointAnnotation = [[BMKPointAnnotation alloc]init];
    _mapView.zoomLevel = 10;
    
    if (![NSString isEmpty:self.sign_id]) {
        NSArray *array = [self.addSignModel.coordinate componentsSeparatedByString:@","];
        if (array.count >= 2) {
            coor.latitude  = [array[1] floatValue];
            coor.longitude = [array[0] floatValue];
            _pointAnnotation.coordinate = coor;
            //显示位置
            _mapView.centerCoordinate = _pointAnnotation.coordinate;
  
            self.signMapCell.mapView.centerCoordinate = _pointAnnotation.coordinate;
            
            [self mapAddAnnotationWithAnnotation:_pointAnnotation];
            
        }else{
            //            Cellheight = 50;
            [self.tableView reloadData];
            [_mapView removeFromSuperview];
            _mapView = nil;
        }
        _mapView.gesturesEnabled = NO;
    }else{
        [_mapView updateLocationData:userLocation];
        
        coor.latitude = userLocation.location.coordinate.latitude;
        coor.longitude = userLocation.location.coordinate.longitude;
        _pointAnnotation.coordinate = coor;
        //显示位置
        _mapView.centerCoordinate = _pointAnnotation.coordinate;
        self.signMapCell.mapView.centerCoordinate = _pointAnnotation.coordinate;
        
        [self mapAddAnnotationWithAnnotation:_pointAnnotation];
        
        [_locService stopUserLocationService];
        
        self.addSignModel.pt = _pointAnnotation.coordinate;
    }
    
    //发起反向地理编码检索
    //初始化检索对象
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    geocodesearch.delegate = self;
    
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    NSString *geoString = flag == YES?@"成功":@"失败";
    TYLog(@"反Geo检索发送%@",geoString);
    
    [TYShowMessage hideHUD];
}

- (void)mapAddAnnotationWithAnnotation:(BMKPointAnnotation *)annotation {
    
    NSArray *annotations = [[NSArray alloc]initWithArray:self.signMapCell.mapView.annotations];
    
    if (annotations.count > 0) {
        
        [self.signMapCell.mapView removeAnnotations:annotations];
    }
    
    [self.signMapCell.mapView addAnnotation:_pointAnnotation];
}

#pragma mark 接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        [TYUserDefaults setObject:[NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district] forKey:JLGCityWebName];
        
        NSString *locationAddress = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
        [TYUserDefaults setObject:locationAddress forKey:JGJLocationAddress];
        
        BMKPoiInfo *poiInfo = (BMKPoiInfo *)[result.poiList firstObject];
        [TYUserDefaults setObject:poiInfo.name forKey:JGJLocationAddressDetail];
        
        TYLog(@"%@ --- %@----- %@", poiInfo.name, locationAddress, [NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district]);
        
        //签到才使用当前位置
        if ([NSString isEmpty:self.sign_id]) {
            
            self.addSignModel.sign_addr = [TYUserDefaults objectForKey:JGJLocationAddress];
            
            self.addSignModel.sign_addr2 = [TYUserDefaults objectForKey:JGJLocationAddressDetail];
            
            [self.tableView reloadData];
        }
    }
}


/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error%@",[error description]);
}


- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - JGJSignRemarkCellDelegate
- (void)textViewCell:(JGJSignRemarkCell *)cell didChangeText:(YYTextView *)inputText {
    
    self.addSignModel.sign_desc = inputText.text;
    
    self.bottomDistance.constant = 100;
}

#pragma mark - 微调按钮按下
- (void)handleAdjustButtonPressed:(JGJAddSignModel *)signModel {
    
    __weak typeof(self) weakSelf = self;
    
    JGJAdjustSignLocaVc *adjustSignLocaVc = [[UIStoryboard storyboardWithName:@"JGJQuaSafeCheck" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJAdjustSignLocaVc"];
    
    adjustSignLocaVc.handleSelSignModelBlock = ^(JGJAddSignModel *signModel) {
        
        _pointAnnotation.coordinate = signModel.pt;
        //显示位置
        _mapView.centerCoordinate = _pointAnnotation.coordinate;
        
        weakSelf.signMapCell.mapView.centerCoordinate = _pointAnnotation.coordinate;
        
        [weakSelf.signMapCell.mapView addAnnotation:_pointAnnotation];
        
        [_locService stopUserLocationService];
        
        weakSelf.addSignModel.sign_addr = signModel.sign_addr;
        
        weakSelf.addSignModel.sign_addr2 = signModel.sign_addr2;
        
        weakSelf.addSignModel.pt = _pointAnnotation.coordinate;
        
        [weakSelf.tableView reloadData];
    };
    
    adjustSignLocaVc.addSignModel = self.addSignModel;
    
    [self.navigationController pushViewController:adjustSignLocaVc animated:YES];
}

- (void)handleRetryButtonSignAction {
    
    [TYShowMessage showHUDWithMessage:@"重新获取签到地点"];
    
    [_locService startUserLocationService];

}

- (void)keyboardShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];

    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    
    CGFloat yEndOffset = endKeyboardRect.size.height - (TYGetUIScreenHeight - rect.origin.y) + 200;
    
    if (yEndOffset < 0) {
        
        return;
    }
    
    [UIView animateWithDuration:duration animations:^{
        //显示

        self.view.frame = CGRectMake(0, -yEndOffset, TYGetUIScreenWidth, TYGetUIScreenHeight);

    }completion:^(BOOL finished) {


    }];

}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        
        self.view.frame = CGRectMake(0, JGJ_NAV_HEIGHT, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        
    }completion:^(BOOL finished) {
        
        
    }];

}

- (JGJCreatTeamModel *)desModel {
    
    if (!_desModel) {
        
        _desModel = [[JGJCreatTeamModel alloc] init];
        
        _desModel.title = @"备注:";
    }
    
    return _desModel;
}

@end
