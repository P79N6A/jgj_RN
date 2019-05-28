//
//  JGJWorkReportSelectedTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectedCollectionViewdelegate <NSObject>
-(void)selectedCollectionViewItem;
@end
@interface JGJWorkReportSelectedTableViewCell : UITableViewCell
@property(nonatomic ,strong)UICollectionView *collectionview;
@property(nonatomic ,strong)id<selectedCollectionViewdelegate> delegate;

@end
