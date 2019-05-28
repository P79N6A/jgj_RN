//
//  YZGGetIndexRecordTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGMateWorkitemsModel.h"

@interface YZGGetIndexRecordTableViewCell : UITableViewCell

/**
 *  是否将删除的imageView设置为高亮显示
 *
 *  @param highlighted YES:设置为高亮(删除) ,NO,设置不为高亮(不删除)
 */
- (void)setDeleteImageViewHighlighted:(BOOL )highlighted;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet UILabel *overLable;
@property (strong, nonatomic) IBOutlet UILabel *workTimeLable;

@property (strong, nonatomic) IBOutlet UILabel *workLable;
@property (nonatomic,strong) MateWorkitemsItems *mateWorkitemsItems;
@property (nonatomic,assign) BOOL isFirstCell;//是否是最后一个cell
@property (nonatomic,assign) BOOL isLastCell;//是否是最后一个cell
@property (nonatomic,assign) BOOL isDeleting;//是否是删除状态
@property (strong, nonatomic) IBOutlet UILabel *proNameLable;
@property (nonatomic,assign) BOOL needAnimate;//是否需要动画
@property (strong, nonatomic) IBOutlet UILabel *recordPeopleLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *peoleftConstance;
@property (nonatomic,strong) UIImageView *roleImageview;//工人工头记
@property (strong, nonatomic) IBOutlet UILabel *lineLbale;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *amoutConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstance;

@end
