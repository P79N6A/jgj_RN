//
//  JLGMYProExperienceTableViewCell.h
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGProjectModel.h"
#import "JLGPhoneCollection.h"

static const CGFloat LastCellExtraHeight = 30;

@protocol JLGMYProExperienceTableViewCellDelegate <NSObject>
- (void )CollectionCellDidSelected:(NSUInteger )cellIndex imageIndex:(NSUInteger )imageIndex;
@optional
- (void )CollectionCellEdit:(NSUInteger )cellIndex;

- (void )CollectionCellTouch;
@end

@interface JLGMYProExperienceTableViewCell : UITableViewCell
<
    JLGPhoneCollectionDelegate
>
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL hiddenTopLine;
@property (nonatomic,assign) BOOL isGetCellHeight;
@property (nonatomic,assign) BOOL showBottomPointView;
@property (nonatomic,assign) BOOL hiddenEditButton;
@property (nonatomic,assign) BOOL hiddenAddButton;
@property (nonatomic,strong) JLGProjectModel *jlgProjectModel;

//继承用的
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (nonatomic , weak) id<JLGMYProExperienceTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet JLGPhoneCollection *imagesCollectionCell;
@end
