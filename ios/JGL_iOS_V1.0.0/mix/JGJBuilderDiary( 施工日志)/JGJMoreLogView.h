//
//  JGJMoreLogView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didselectIndexpath)(NSIndexPath *indexpath);
@interface JGJMoreLogView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)  UICollectionView   *MyCollectionview;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (copy , nonatomic)  didselectIndexpath didSelectIndexpath;
@property (strong, nonatomic) IBOutlet UIView *baseView;
-(instancetype)initWithFrame:(CGRect)frame ishowAddRow:(BOOL)add didSelectedIndexPathBlock:(didselectIndexpath)indexpath initWithArr:(NSMutableArray *)arr;

- (void)show;
@end
