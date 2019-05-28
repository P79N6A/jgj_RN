//
//  JGJProicloudListCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProicloudListCell.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

#import "UIButton+WebCache.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

#import "UIView+GNUtil.h"

#import "JGJProListBottomView.h"

#define ExpandViewHeight 50

@interface JGJProicloudListCell ()

@property (weak, nonatomic)  UIButton *fileTypeButton;

@property (weak, nonatomic)  UILabel *fileNameLable;

@property (weak, nonatomic)  UILabel *fileTimeLable;

@property (weak, nonatomic)  UIButton *downloadButton;
@property (weak, nonatomic)  UIButton *shareButton;
@property (weak, nonatomic)  UIButton *renameButton;
@property (weak, nonatomic)  UIView *topView;
@property (weak, nonatomic)  JGJProListBottomView *bottomView;
@property (weak, nonatomic)  UIButton *selButton;
@property (weak, nonatomic)  UIImageView *expandImageView;

@property (weak, nonatomic)  UILabel *fileSizeLable;

@property (weak, nonatomic)  UIView *tapView;

@property (weak, nonatomic)  NSLayoutConstraint *selButtonW;

@property (weak, nonatomic)  NSLayoutConstraint *topViewH;

@end

@implementation JGJProicloudListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *cellIdentifier = @"JGJProicloudListCell";
    JGJProicloudListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[JGJProicloudListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style
                      reuseIdentifier:(nullable NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initialSubViews];
    
    }
    
    return self;
}

- (void)initialSubViews {

    UIView *topView = [UIView new];
    
    self.topView = topView;
    
    [self.contentView addSubview:topView];
    
    //选择按钮
    UIButton *selButton = [UIButton new];
    
    selButton.userInteractionEnabled = NO;
    
    self.selButton = selButton;
    
    [selButton setImage:[UIImage imageNamed:@"EllipseIcon"] forState:UIControlStateNormal];
    
    [selButton setImage:[UIImage imageNamed:@"MultiSelected"] forState:UIControlStateSelected];
    
    [topView addSubview:selButton];
    
    //手势点击展开视图
    UIView *tapView = [UIView new];
    
    self.tapView = tapView;
    
    UILabel *fileSizeLable = [UILabel new];
    
    fileSizeLable.textAlignment = NSTextAlignmentCenter;
    
    fileSizeLable.textColor = AppFont999999Color;
    
    fileSizeLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    self.fileSizeLable = fileSizeLable;
    
    [tapView addSubview:fileSizeLable];
    
    UIImageView *expandImageView = [UIImageView new];
    
    self.expandImageView = expandImageView;
    
    expandImageView.image = [UIImage imageNamed:@"cloud_down_icon"];
    
    [tapView addSubview:expandImageView];
    
    [topView addSubview:tapView];
    
    //文件类型
    
    UIButton *fileTypeButton = [UIButton new];
    
    fileTypeButton.userInteractionEnabled = NO;
    
    self.fileTypeButton = fileTypeButton;
    
    [topView addSubview:fileTypeButton];
    
    //文件名字
    UILabel *fileNameLable = [UILabel new];
    
    fileNameLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    fileNameLable.textColor = AppFont333333Color;
    
    self.fileNameLable = fileNameLable;
    
    [topView addSubview:fileNameLable];
    
    //文件创建时间
    UILabel *fileTimeLable = [UILabel new];
    
    self.fileTimeLable = fileTimeLable;
    
    fileTimeLable.font = [UIFont systemFontOfSize:AppFont24Size];
    
    fileTimeLable.textColor = AppFont999999Color;
    
    [topView addSubview:fileTimeLable];
    
    LineView *lineView = [LineView new];
    
    self.lineView = lineView;
    
    [topView addSubview:lineView];
    
    //底部视图
    JGJProListBottomView *bottomView = [[JGJProListBottomView alloc] init];
    
    bottomView.backgroundColor = AppFontf1f1f1Color;
    
    self.bottomView = bottomView;
    
    [self.contentView addSubview:bottomView];
    
    for (UIView *subView in self.bottomView.subviews) {
        
        for (UIButton *subButton in subView.subviews) {
            
            if ([subButton isKindOfClass:[UIButton class]]) {
                
                if (subButton.tag == 100) {
                    
                    self.downloadButton = subButton;
                }else if (subButton.tag == 101) {
                    
                    self.shareButton = subButton;
                    
                }else if (subButton.tag == 102) {
                    
                    self.renameButton = subButton;
                }
                
                [subButton addTarget:self action:@selector(handleCellBottomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExpandButtonPressed)];
    
    [self.tapView addGestureRecognizer:tap];
}

- (void)configViewFrameWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    CGFloat padding = 10;
    
    CGFloat trail = 10;
    
    CGFloat lead = 10;
    
    CGFloat tapViewWH = 60;
    
    CGFloat selButtonW = 0;
    
    self.expandImageView.frame = TYSetRect((tapViewWH - 12) / 2.0, tapViewWH / 2.0 - 5, 12, 7);
    
    self.fileSizeLable.frame = TYSetRect(0, tapViewWH / 2.0 + 5, tapViewWH, 18);
    
    //选择按钮
    self.selButton.frame = TYSetRect(0, 0, 40, 40);
    
    if (_cloudListModel.cloudListCellType == ProicloudListMoreOperaCellType) {
        
        selButtonW = 40;
        
        tapViewWH = 0;
    }
    
    //展开View
    self.tapView.x = TYGetUIScreenWidth - tapViewWH - trail;
    
    self.tapView.width = tapViewWH;
    
    self.tapView.height = tapViewWH;
    
    
    self.selButton.width = selButtonW;
    
    //文件类型
    
    self.fileTypeButton.x = TYGetMaxX(self.selButton) + lead;
    
    self.fileTypeButton.width = 40;
    
    self.fileTypeButton.height = 40;
    
    //文件名
    
    CGFloat preMaxW = TYGetUIScreenWidth - TYGetMaxX(self.fileTypeButton) - tapViewWH - 2 * padding;
    
    if (cloudListModel.cloudListCellType == ProicloudListMoreOperaCellType) {
        
        preMaxW = TYGetUIScreenWidth - 160;
        
    }
    
    self.fileNameLable.preferredMaxLayoutWidth = preMaxW;
    
//    CGFloat fileNameH = [self.fileNameLable contentSizeFixWithWidth:preMaxW].height;
    
    CGFloat fileNameH = 18.0; //只需要一行
    
    CGFloat fileNameX = TYGetMaxX(self.fileTypeButton) + padding;
    
    self.fileNameLable.frame = TYSetRect(fileNameX, 16, preMaxW, fileNameH);
    
    self.fileTimeLable.frame = TYSetRect(fileNameX, TYGetMaxY(self.fileNameLable) + 6.5, preMaxW, 15);
    
    //分割线
    CGFloat lineViewX = TYGetMinX(self.fileTypeButton) + 10;
    
    self.lineView.frame = TYSetRect(lineViewX, TYGetMaxY(self.fileTimeLable) + 12, TYGetUIScreenWidth - lineViewX - trail, 0.5);
    
    CGFloat bottomViewH = ExpandViewHeight;
    
    self.bottomView.frame = TYSetRect(0, TYGetMaxY(self.lineView), TYGetUIScreenWidth, bottomViewH);
    
    self.topView.frame = TYSetRect(0, 0, TYGetUIScreenWidth, TYGetMaxY(self.lineView));
    
    
    self.selButton.centerY = self.topView.centerY;
    
    self.fileTypeButton.centerY = self.topView.centerY;
    
    self.tapView.centerY = self.topView.centerY;

//    if (_cloudListModel.isExpand) {
//        
//        _cloudListModel.cellHeight = TYGetViewH(self.bottomView) + TYGetMaxY(self.lineView);
//        
//    }else {
//        
//        _cloudListModel.cellHeight = TYGetMaxY(self.lineView);
//        
//    }
    
    if (_cloudListModel.isExpand) {
        
        _cloudListModel.cellHeight = bottomViewH + 68.0;;
        
    }else {
        
        _cloudListModel.cellHeight = 68.0;
        
    }
    
}

- (void)setCloudListModel:(JGJProicloudListModel *)cloudListModel {

    _cloudListModel = cloudListModel;
    
    //根据文件类型显示
        
    [self setContentWithCloudListModel:_cloudListModel];
    
    //选择按钮显示
    [self proicloudListMoreOperaCellListModel:_cloudListModel];
    
    //展开按钮处理
    [self confExpandButtonWithCloudListModel:_cloudListModel];
    
    //回收站使用
    
    self.tapView.hidden = NO;
    
    if (self.isHiddenButton) {
        
        [self hiddenRecycleCellBottomButtonWithCloudListModel:_cloudListModel];
        
    }else {
    
        [self hiddenBottomButton];
    }
    
    self.lineView.hidden = _cloudListModel.isExpand || _cloudListModel.isHiddenLineView;
    
    //计算高度
//    [self containtSizeWithCloudListModel:cloudListModel];
    
    [self configViewFrameWithCloudListModel:cloudListModel];
}

- (void)containtSizeWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    CGFloat preMaxW = TYGetUIScreenWidth - 110;
    
    if (cloudListModel.cloudListCellType == ProicloudListMoreOperaCellType) {
        
        preMaxW = TYGetUIScreenWidth - 160;
        
    }
    
    self.fileNameLable.preferredMaxLayoutWidth = preMaxW;
    
    CGFloat fileNameH = [self.fileNameLable contentSizeFixWithWidth:preMaxW].height;
    
    self.topViewH.constant = 52.1 + fileNameH;
    
    if (_cloudListModel.isExpand) {
        
        _cloudListModel.cellHeight = 50 + self.topViewH.constant;
        
    }else {
    
        _cloudListModel.cellHeight = self.topViewH.constant;
        
    }

}

#pragma mark - 设置显示内容
- (void)setContentWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    self.fileNameLable.text = cloudListModel.file_name;
    
    NSString *upDateDes = [NSString stringWithFormat:@"%@%@%@",cloudListModel.opeator_name?:@"", cloudListModel.opeator_name?@" ":@"",[NSString isEmpty:cloudListModel.update_time]?cloudListModel.date:cloudListModel.update_time];
    
    self.fileTimeLable.text = upDateDes;
    
    self.fileSizeLable.text = cloudListModel.file_size;
    
    self.fileSizeLable.text = [cloudListModel.type isEqualToString:@"dir"] ? @"" : cloudListModel.file_size;
    
    self.selButton.selected = cloudListModel.isSelected;
    
    cloudListModel.imageView = self.fileTypeButton.imageView;
    
    [self setFileTypeIconWithCloudListModel:cloudListModel];
    
   // [self.fileNameLable markText:self.searchValue withColor:AppFontEB4E4EColor];
    
    if ([NSString isEmpty:self.searchValue]) {
        
        self.searchValue = @"";
        
        self.fileNameLable.textColor = AppFont333333Color;
        
    }else {
        
        [self.fileNameLable markattributedTextArray:@[self.searchValue] color:AppFontEB4E4EColor font:[UIFont systemFontOfSize:AppFont30Size] isGetAllText:YES];
    }
    
    [self setBottomButtonContentWithCloudListModel:cloudListModel];
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
    
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -18, 19);
    
    if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        self.downloadButton.hidden = YES;
        
        self.shareButton.hidden = NO;
        
        [self.shareButton setImage:[UIImage imageNamed:@"cloud_rename_icon"] forState:UIControlStateNormal];
        
        [self.shareButton setTitle:@"重命名" forState:UIControlStateNormal];
        
        self.shareButton.imageEdgeInsets = UIEdgeInsetsMake(-17, 0, 0, -40);
    
        self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -18, 19);
        
        self.renameButton.hidden = YES;
        
    }
    
}

#pragma mark - 根据文件类型显示
- (void)setFileTypeIconWithCloudListModel:(JGJProicloudListModel *)cloudListModel {

    if ([cloudListModel.type isEqualToString:@"dir"]) {
        
        cloudListModel.file_type = cloudListModel.type;
    }
    
    NSString *fileType = [cloudListModel.file_broad_type lowercaseString]?:@"";
    
    self.fileTypeButton.imageView.contentMode = UIViewContentModeCenter;
    
    [self.fileTypeButton setImage:nil forState:UIControlStateNormal];
    
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
    
    self.selButtonW.constant = width;
    
    [self.selButton layoutIfNeeded];
}

- (void)hiddenBottomButton {

    self.bottomView.hidden = !_cloudListModel.isExpand;
}

- (void)handleExpandButtonPressed {
    
    _cloudListModel.isExpand = !_cloudListModel.isExpand;
    
    if ([self.delegate respondsToSelector:@selector(proicloudListCell:didSelectedModel:)]) {
        
        [self.delegate proicloudListCell:self didSelectedModel:_cloudListModel];
    }
    
}

#pragma mark -当前回收站使用
- (void)hiddenRecycleCellBottomButtonWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    self.bottomView.hidden = YES;
    
    self.tapView.hidden = YES;
}

- (void)confExpandButtonWithCloudListModel:(JGJProicloudListModel *)cloudListModel {
    
    if (cloudListModel.isExpand) {
        
        self.expandImageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
         self.expandImageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)handleCellBottomButtonPressed:(UIButton *)sender {
    
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
