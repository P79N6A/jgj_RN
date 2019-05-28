//
//  YZGWageBestDetailTableView.h
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const wageBestDetailCellHegith = 33;

@class WageBestDetailPro_List,YZGWageBestDetailTableView,WageMoreDetailList;
@protocol YZGWageBestDetailTableViewDelegate <NSObject>

- (void)YZGWageBestDetailTableViewSelected:(YZGWageBestDetailTableView *)tableView index:(NSInteger )index;
@end

@interface YZGWageBestDetailTableView : UIView
@property (nonatomic , weak) id<YZGWageBestDetailTableViewDelegate> delegate;

@property (nonatomic,strong) WageMoreDetailList *wageMoreDetailValues;
@property (nonatomic, strong) NSArray<WageBestDetailPro_List *> *dateArray;
@end
