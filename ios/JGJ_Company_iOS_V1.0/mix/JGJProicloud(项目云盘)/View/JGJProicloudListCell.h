//
//  JGJProicloudListCell.h
//  JGJCompany
//
//  Created by yj on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@class JGJProicloudListCell;

@protocol JGJProicloudListCellDelegate <NSObject>

@optional

- (void)proicloudListCell:(JGJProicloudListCell *)cell didSelectedModel:(JGJProicloudListModel *)cloudListModel;

//点击下载、分享、重命名按钮
- (void)proicloudListCell:(JGJProicloudListCell *)cell buttonType:(JGJProicloudListCellButtonType)buttonType;

@end

@interface JGJProicloudListCell : UITableViewCell

@property (nonatomic, strong) JGJProicloudListModel *cloudListModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (nonatomic, weak) id <JGJProicloudListCellDelegate> delegate;

@property (nonatomic, assign) ProicloudListCellType cloudListCellType;

@property (nonatomic, assign) BOOL isHiddenButton; //隐藏箭头和底部按钮。回收站使用

//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

//包含上传、下载请求
@property (nonatomic, strong) JGJProiCloudUploadFilesModel *transRequestModel;

//取消下载请求
@property (nonatomic, strong) OSSGetObjectRequest * downRequest;

@end
