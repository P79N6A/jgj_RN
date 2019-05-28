//
//  YZGMateWorkitemsTableViewCell.h
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUITableViewCell.h"
#import "UITableViewCell+Extend.h"

@class MateWorkitemsItems,YZGMateWorkitemsTableViewCell;

@protocol YZGMateWorkitemsTableViewCellDelegate <NSObject>
@optional
- (void)MateWorkitemsDeleteBtnClick:(YZGMateWorkitemsTableViewCell *)cell;
- (void)MateWorkitemsRemoveBtnClick:(YZGMateWorkitemsTableViewCell *)cell;
@end

@interface YZGMateWorkitemsTableViewCell : JGJUITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *recordNameLable;
@property (strong, nonatomic) IBOutlet UILabel *departLable;
@property (strong, nonatomic) IBOutlet UILabel *proNameLabler;
@property (nonatomic , weak) id<YZGMateWorkitemsTableViewCellDelegate> yzdelegate;
@property (nonatomic,strong) MateWorkitemsItems *mateWorkitemsValue;
@property (nonatomic, strong) JGJDayCheckingModel *DayCheckingModel;
@property (strong, nonatomic) IBOutlet UIImageView *amoutDiffImageview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *amoutConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *diffCenterConstance;
@property (nonatomic, assign) NSInteger showType;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerContence;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleCenterConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subTitleCenterConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *manTopConstance;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *proTopconstance;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeImageCenterY;
@property (weak, nonatomic) IBOutlet UIImageView *remarkImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remakrCenterY;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@end
