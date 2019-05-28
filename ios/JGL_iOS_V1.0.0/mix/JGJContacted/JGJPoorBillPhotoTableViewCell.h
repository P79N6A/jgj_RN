//
//  JGJPoorBillPhotoTableViewCell.h
//  mix
//
//  Created by Tony on 2017/10/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJModifyBillImageCollectionViewCell.h"

@protocol PoorBillPhotoTableViewCelldelegate <NSObject>

-(void)ClickPoorBillPhotoBtn;
-(void)deleteImageAndImageArr:(NSMutableArray *)imageArr andDeletedIndex:(NSInteger)index;


@end

@interface JGJPoorBillPhotoTableViewCell : UITableViewCell
<
UICollectionViewDelegate,

UICollectionViewDataSource,

JGJModifyBillImageCollectionViewDlegate
>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) IBOutlet UILabel *placeLable;

@property (strong, nonatomic) id <PoorBillPhotoTableViewCelldelegate>delegate;

@property (strong, nonatomic)  NSArray *imageArr;

@end
