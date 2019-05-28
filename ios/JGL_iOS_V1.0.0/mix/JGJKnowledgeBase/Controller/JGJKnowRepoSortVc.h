//
//  JGJKnowRepoSortVc.h
//  mix
//
//  Created by yj on 17/4/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYTextField.h"

#import "JGJSearchResultView.h"

@interface JGJKnowRepoSortVc : UIViewController

@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel; //知识库顶部模型，外面主要用id

@property (nonatomic, strong) NSMutableArray *knowRepos;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong, readonly) JGJCustomSearchBar *searchbar;

@property (strong ,nonatomic, readonly) JGJSearchResultView *searchResultView;

//已下载列表子类使用选择
- (void)registerCellTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
