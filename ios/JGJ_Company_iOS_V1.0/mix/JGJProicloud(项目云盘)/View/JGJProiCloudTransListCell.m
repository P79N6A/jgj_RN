//
//  JGJProiCloudTransListCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudTransListCell.h"

#import "HWProgressView.h"

#import "JGJProiCloudTool.h"

#import "UILabel+GNUtil.h"

#import "CustomView.h"

#import "UIButton+WebCache.h"

#define ExpandViewHeight 50

@interface JGJProiCloudTransListCell ()

@property (weak, nonatomic) IBOutlet HWProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *fileTypeButton;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLable;

@property (weak, nonatomic) IBOutlet UILabel *fileTimeLable;

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *renameButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selButton;
@property (weak, nonatomic) IBOutlet UIImageView *expandImageView;

@property (weak, nonatomic) IBOutlet UILabel *fileSizeLable;

@property (weak, nonatomic) IBOutlet UIView *tapView;

@property (weak, nonatomic) IBOutlet UILabel *loadingFileSizeLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileNameCenterY;


@end

@implementation JGJProiCloudTransListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.bottomView.backgroundColor = AppFontf1f1f1Color;
    
    self.fileNameLable.textColor = AppFont333333Color;
    
    [self.renameButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.shareButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.downloadButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    self.renameButton.backgroundColor = AppFontf1f1f1Color;
    
    self.shareButton.backgroundColor = AppFontf1f1f1Color;
    
    self.downloadButton.backgroundColor = AppFontf1f1f1Color;
    
    self.fileTimeLable.textColor = AppFont999999Color;
    
    self.fileSizeLable.textColor = AppFont999999Color;
    
    self.loadingFileSizeLable.textColor = AppFont999999Color;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExpandButtonPressed)];
    
    
    [self.tapView addGestureRecognizer:tap];
}

- (void)setCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    _cloudListModel = cloudListModel;
    
    //根据文件类型显示
    
    [self setContentWithCloudListModel:_cloudListModel];
    
    //选择按钮显示
    [self proicloudListMoreOperaCellListModel:_cloudListModel];
    
    //展开按钮处理
    [self confExpandButtonWithCloudListModel:_cloudListModel];
    
    //进度显示
    [self showProgressWithCloudListModel:cloudListModel];
    
    [self hiddenBottomButton];
    
    self.lineView.hidden = _cloudListModel.isExpand || _cloudListModel.isHiddenLineView;
    
    //计算高度
    [self containtSizeWithCloudListModel:cloudListModel];
    
    //传输成功居中显示
    [self transSuccessCenterCloudListModel:cloudListModel];
        
}

#pragma mark - 传输成功文件名字和时间间距调整
- (void)transSuccessCenterCloudListModel:(JGJProicloudListModel *)cloudListModel {

    CGFloat centerY = 15.0;
    
    if (cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
        
        centerY = 10.0;
        
    }else {
    
        centerY = 15.0;
    }
    
    
    self.fileNameCenterY.constant = -centerY;
    
    [self.fileTimeLable mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.fileTypeButton.mas_centerY).mas_offset(centerY);
    }];
    
    
}

- (void)containtSizeWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
//    CGFloat preMaxW = TYGetUIScreenWidth - 110;
//    
//    if (cloudListModel.cloudListCellType == ProicloudListMoreOperaCellType) {
//        
//        preMaxW = TYGetUIScreenWidth - 160;
//        
//    }
//    
//    self.fileNameLable.preferredMaxLayoutWidth = preMaxW;
//    
//    CGFloat fileNameH = [self.fileNameLable contentSizeFixWithWidth:preMaxW].height;
    
//    self.topViewH.constant = 52.1 + fileNameH;
    
//    if (_cloudListModel.isExpand) {
//        
//        _cloudListModel.cellHeight = 40 + self.topViewH.constant;
//        
//    }else {
//        
//        _cloudListModel.cellHeight = self.topViewH.constant;
//        
//    }
    
    self.topViewH.constant = 70.0;
    
    if (_cloudListModel.isExpand) {
        
        _cloudListModel.cellHeight = ExpandViewHeight + 70.0;
        
    }else {
        
        _cloudListModel.cellHeight = self.topViewH.constant;
        
    }
    
}

#pragma mark - 设置显示内容
- (void)setContentWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    self.fileNameLable.text = cloudListModel.file_name;
    
    NSString *upDateDes = [NSString stringWithFormat:@"%@%@%@",cloudListModel.opeator_name?:@"", cloudListModel.opeator_name?@" ":@"",[NSString isEmpty:cloudListModel.update_time]?cloudListModel.date:cloudListModel.update_time];
    
    self.fileTimeLable.text = upDateDes;
    
  //上传需要单位转换
    
    NSString *file_size = cloudListModel.file_size;
    
    if (self.baseType == ProiCloudDataBaseUpLoadType) {
        
        file_size =  [JGJOSSCommonHelper getFileSizeString:[NSString stringWithFormat:@"%@", cloudListModel.file_size]];
        
    }
    
    self.fileSizeLable.text = [cloudListModel.type isEqualToString:@"dir"] ? @"" : file_size;
    
    self.selButton.selected = cloudListModel.isSelected;
    
    cloudListModel.imageView = self.fileTypeButton.imageView;
    
    [self setFileTypeIconWithCloudListModel:cloudListModel];
    

    [self setBottomButtonContentWithCloudListModel:cloudListModel];
}

#pragma mark - 显示进度
- (void)showProgressWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    CGFloat currentProgress = self.progressView.progress;
    
    if (cloudListModel.totalBytes > 0 && cloudListModel.totalBytesExpected > 0) {
        
        currentProgress = cloudListModel.totalBytes / cloudListModel.totalBytesExpected;
        
    }else {
    
        currentProgress = 0;
    }
    
    if (cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
        
        currentProgress = 1;
    }
    
    NSString *totalBytes = [JGJOSSCommonHelper getFileSizeString:[NSString stringWithFormat:@"%@", @(cloudListModel.totalBytes)]];
    
    NSString *totalBytesExpected = [JGJOSSCommonHelper getFileSizeString:[NSString stringWithFormat:@"%@", @(cloudListModel.totalBytesExpected)]];

    self.loadingFileSizeLable.text = [NSString stringWithFormat:@"%@/%@",totalBytes, totalBytesExpected];
    
    self.loadingFileSizeLable.hidden = YES;
    
    self.progressView.hidden = NO;
    
    switch (_cloudListModel.finish_status) {
            
            //状态是正在下载和开始下载
        case JGJProicloudLoadingStatusType:
        case JGJProicloudStartStatusType:{

            self.fileTimeLable.text = @"下载中";
            
            if (self.baseType == ProiCloudDataBaseUpLoadType) {
                
                self.fileTimeLable.text = @"上传中";
                
            }

            self.loadingFileSizeLable.hidden = NO;
            
            self.progressView.progressColor = AppFontEB4E4EColor;
            
            TYLog(@"正在下载中==== %@", _cloudListModel.file_name);
        }
            
            break;
            
            //状态是暂停
        case JGJProicloudPauseStatusType:{
            
            self.progressView.progressColor = AppFont9D9D9DColor;
            
            NSString *pauseStr = @"暂停";
            
            self.fileTimeLable.text = pauseStr;
            
            self.loadingFileSizeLable.hidden = NO;
            
            TYLog(@"暂停下载了===== %@", _cloudListModel.file_name);
        }
            
            break;
            
            //下载失败了下载
        case JGJProicloudFailureStatusType:{
            
            NSString *failureStr = @"下载失败";
            
            if (self.baseType == ProiCloudDataBaseUpLoadType) {
                
                failureStr = @"上传失败";
                
            }
            
            self.fileTimeLable.text = failureStr;
            
            self.loadingFileSizeLable.hidden = NO;
            
            TYLog(@"下载失败了重新下载");
        }
            
            break;
        
        case JGJProicloudSuccessStatusType:{
            
            self.fileTimeLable.text = cloudListModel.date;
            
            self.loadingFileSizeLable.hidden = YES;
            
            self.progressView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
//异常情况，返回的进度大于当前进度才显示
//    if (cloudListModel.progress >= currentProgress) {
//        
//        self.progressView.progress = cloudListModel.progress;
//        
//    }
    
    self.progressView.progress = cloudListModel.progress;
    
//    TYLog(@"currentProgress ==== %@ progrss = %@ totalBytes === %@  totalBytesExpected == %@", @(currentProgress), @(self.progressView.progress),@(cloudListModel.totalBytes), @(cloudListModel.totalBytesExpected));
//    ;
//    ;
}

#pragma mark - 设置底部按钮
- (void)setBottomButtonContentWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    [self.downloadButton setImage:[UIImage imageNamed:@"cloud_download_icon"] forState:UIControlStateNormal];
    
    [self.shareButton setImage:[UIImage imageNamed:@"cloud_share_icon"] forState:UIControlStateNormal];
    
    [self.renameButton setImage:[UIImage imageNamed:@"cloud_rename_icon"] forState:UIControlStateNormal];
    
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    
    [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
    
    [self.renameButton setTitle:@"重命名" forState:UIControlStateNormal];
    
    self.downloadButton.hidden = NO;
    
    self.shareButton.hidden = NO;
    
    self.renameButton.hidden = NO;
    
    self.shareButton.imageEdgeInsets = UIEdgeInsetsMake(-17, 0, 0, -25);
    
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -18, 17);
    
    if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        self.downloadButton.hidden = YES;
        
        self.shareButton.hidden = NO;
        
        [self.shareButton setImage:[UIImage imageNamed:@"cloud_rename_icon"] forState:UIControlStateNormal];
        
        [self.shareButton setTitle:@"重命名" forState:UIControlStateNormal];
        
        self.shareButton.imageEdgeInsets = UIEdgeInsetsMake(-17, 0, 0, -40);
        
        self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -18, 17);
        
        self.renameButton.hidden = YES;
        
    }
    
    self.downloadButton.hidden = YES;
    
    self.shareButton.hidden = NO;
    
    self.renameButton.hidden = YES;
    
}

#pragma mark - 根据文件类型显示
- (void)setFileTypeIconWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        cloudListModel.file_type = cloudListModel.type;
    }
    
    NSString *fileType = [cloudListModel.file_broad_type lowercaseString]?:@"";
    
    self.fileTypeButton.imageView.contentMode = UIViewContentModeCenter;
    
    if (cloudListModel.isImage) {
        
        [self.fileTypeButton sd_setImageWithURL:[NSURL URLWithString:cloudListModel.thumbnail_file_path] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pic"]];
        
        self.fileTypeButton.imageView.contentMode = UIViewContentModeScaleToFill;
        
        
    }else if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        [self.fileTypeButton setImage:[UIImage imageNamed:@"dir"] forState:UIControlStateNormal];
        
    } else {
        
        [self.fileTypeButton setImage:[UIImage imageNamed:fileType] forState:UIControlStateNormal];
    }
 
    
}

- (void)proicloudListMoreOperaCellListModel:(JGJProicloudListModel *)cloudListModel{
    
    CGFloat width = _cloudListModel.cloudListCellType == ProicloudListMoreOperaCellType ? 40 : CGFLOAT_MIN;
    
    [self.selButton mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(width);
    }];
    
    [self.selButton layoutIfNeeded];
}

- (void)hiddenBottomButton {
    
    self.bottomView.hidden = !_cloudListModel.isExpand || self.cloudListModel.finish_status != JGJProicloudSuccessStatusType;
    
    self.shareButton.hidden = !_cloudListModel.isExpand || self.cloudListModel.finish_status != JGJProicloudSuccessStatusType;
    
    self.progressView.hidden = self.cloudListModel.finish_status == JGJProicloudSuccessStatusType;
}

- (void)handleExpandButtonPressed {
    
    if (_cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
        
        _cloudListModel.isExpand = !_cloudListModel.isExpand;
        
    }else {
    
        [self handleStartPauseAction];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(proicloudListCell:didSelectedModel:)]) {
        
        [self.delegate proicloudListCell:self didSelectedModel:_cloudListModel];
    }
    
}

#pragma mark - 开始或者暂停
- (void)handleStartPauseAction {
    
    if (self.cloudListModel.finish_status != JGJProicloudSuccessStatusType) {
        
        switch (_cloudListModel.finish_status) {
                
                //正在下载和开始下载点击 按钮暂停下载
            case JGJProicloudLoadingStatusType:
            case JGJProicloudStartStatusType:{
                
                //取消下载/暂停
                if (_cloudListModel.is_upload == ProiCloudDataBaseDownLoadType) {
                    
                    [self.transRequestModel.request cancel];
                    
                }else {
                    
                    //取消上传/暂停
                    [self.transRequestModel.resumableUpload cancel];
                }
                
                _cloudListModel.finish_status = JGJProicloudPauseStatusType;
                
                TYLog(@"暂停下载了==== %@", _cloudListModel.file_name);
            }
                
                break;
                
                //当前状态时暂停 失败了 点击了 就继续下载
            case JGJProicloudFailureStatusType:
            case JGJProicloudPauseStatusType:{
                
                _cloudListModel.finish_status = JGJProicloudStartStatusType;

                JGJProicloudListCellButtonType buttonType =  _cloudListModel.is_upload == ProiCloudDataBaseDownLoadType ? JGJProicloudListCellStartButtonType : JGJProicloudListCellStartUpLoadButtonType;
                
                //是否开始上传
                if ([self.delegate respondsToSelector:@selector(proicloudListCell:buttonType:)]) {
                    
                    [self.delegate proicloudListCell:self buttonType:buttonType];
                }
                
                
                TYLog(@"开始下载了==== %@", _cloudListModel.file_name);
            }
                
                break;
                
//                //下载失败了下载
//            case JGJProicloudFailureStatusType:{
//                
//                TYLog(@"下载失败了重新下载");
//            }
//                
//                break;
                
            default:
                break;
        }
        
    }
    
    //状态改变后更新数据库
    [JGJProiCloudDataBaseTool updateicloudListModel:self.cloudListModel];
    
}


#pragma mark -当前回收站使用
- (void)hiddenRecycleCellBottomButtonWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    self.bottomView.hidden = YES;
    
    self.tapView.hidden = YES;
}

- (void)confExpandButtonWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    if (cloudListModel.finish_status == JGJProicloudSuccessStatusType) {
      
        self.expandImageView.image = [UIImage imageNamed:@"cloud_down_icon"];
        
        if (cloudListModel.isExpand) {
            
            self.expandImageView.transform = CGAffineTransformMakeRotation(-M_PI);
            
        }else {
            
            self.expandImageView.transform = CGAffineTransformMakeRotation(0);
        }
        
    }else {
    
        
        switch (_cloudListModel.finish_status) {
            
            //正在下载和开始下载点击按钮暂停下载
            case JGJProicloudLoadingStatusType:
            case JGJProicloudStartStatusType:{
                
                self.expandImageView.image = [UIImage imageNamed:@"procloud_pause"];
                
                self.fileSizeLable.text = @"暂停下载";
                
                if (self.baseType == ProiCloudDataBaseUpLoadType) {
                    
                    self.fileSizeLable.text = @"暂停上传";
                    
                }
            }
                
                break;
            
                //下载失败了下载
            case JGJProicloudFailureStatusType:{
                
                TYLog(@"下载失败了重新下载");
            }
            //暂停了就继续下载
            case JGJProicloudPauseStatusType:{
                
                self.expandImageView.image = [UIImage imageNamed:@"procloud_start"];
                
                self.fileSizeLable.text = @"继续下载";
                
                if (self.baseType == ProiCloudDataBaseUpLoadType) {
                    
                    self.fileSizeLable.text = @"继续上传";
                    
                }
                
            }
                
                break;
                
            default:
                break;
        }
        
    }
    
    
}

- (IBAction)handleCellBottomButtonPressed:(UIButton *)sender {
    
    JGJProicloudListCellButtonType buttonType = sender.tag - 100;
    
    //文件夹点击分享转换为重命名，文件夹之后这个功能
    if ([self.cloudListModel.type isEqualToString:@"dir"] && buttonType == JGJProicloudListCellShareButtonType) {
        
        buttonType = JGJProicloudListCellRenameButtonType;
    }
    
    if ([self.delegate respondsToSelector:@selector(proicloudListCell:buttonType:)]) {
        
        [self.delegate proicloudListCell:self buttonType:buttonType];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
