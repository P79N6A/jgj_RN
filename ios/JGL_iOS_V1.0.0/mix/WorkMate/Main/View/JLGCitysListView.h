//
//  JLGCitysListView.h
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGCitysListTableViewCell.h"

@protocol JLGCitysListViewDelegate <NSObject>
- (void)selectedCity:(NSString *)cityCode cityName:(NSString *)cityName;
@end
@interface JLGCitysListView : UIView

@property (nonatomic , weak) id<JLGCitysListViewDelegate> delegate;
@property (nonatomic , copy) NSArray <JLGCitysListModel *> *dataArr;
@property (nonatomic, strong) NSArray<NSDictionary *> *worktypeArr;

- (void)hidden;
- (void)tableViewReloadData;
- (void)showInView:(UIViewController *)Vc;
- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray <JLGCitysListModel *>*)dataArr;
@end
