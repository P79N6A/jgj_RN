//
//  JGJProiCloudTransListCell.h
//  JGJCompany
//
//  Created by yj on 2017/7/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJProiCloudTransListCell;

@protocol JGJProiCloudTransListCellDelegate <NSObject>

@optional

- (void)proicloudListCell:(JGJProiCloudTransListCell *)cell didSelectedModel:(JGJProicloudListModel *)cloudListModel;

//点击下载、分享、重命名按钮
- (void)proicloudListCell:(JGJProiCloudTransListCell *)cell buttonType:(JGJProicloudListCellButtonType)buttonType;

@end

@interface JGJProiCloudTransListCell : UITableViewCell

@property (nonatomic, strong) JGJProicloudListModel *cloudListModel;

@property (nonatomic, weak) id <JGJProiCloudTransListCellDelegate> delegate;

//包含上传、下载请求
@property (nonatomic, strong) JGJProiCloudUploadFilesModel *transRequestModel;

@property (nonatomic, assign) ProiCloudDataBaseType baseType;

@end
