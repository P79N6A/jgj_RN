//
//  JGJWorkCircleMiddleTableViewCell.h
//  JGJCompany
//
//  Created by yj on 16/9/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ItemHeight 77
#define WorkCircleCollectiveH (ItemHeight * 2 + 10)

typedef enum : NSUInteger {
    WorkCircleHomeKnowNodataCellType, //知识库
    WorkCircleHomeListTypeCellType //列表类型
} WorkCircleHomeCellType;

@class JGJWorkCircleMiddleTableViewCell;
@protocol JGJWorkCircleMiddleTableViewCellDelegate <NSObject>
@optional
- (void)WorkCircleMiddleTableViewCellType:(WorkCircleCollectionViewCellType)circleCollectionViewCellType infoModel:(JGJWorkCircleMiddleInfoModel *)infoModel;

- (void)workCircleMiddleTableViewCell:(JGJWorkCircleMiddleTableViewCell *)cell didSelectedNetNotReachabeTapAction:(UITapGestureRecognizer *)tapAction;

@end
@interface JGJWorkCircleMiddleTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) id <JGJWorkCircleMiddleTableViewCellDelegate> delegate;
@property (strong, nonatomic) JGJWorkCircleMiddleInfoModel *infoModel; //用于传入未读数
@property (assign, nonatomic) BOOL isNotReachableStatus;//当前网络是否是不可用状态

@property (assign, nonatomic) WorkCircleHomeCellType cellType;
+ (CGFloat)workCircleMiddleTableViewCellHeight;
@end
