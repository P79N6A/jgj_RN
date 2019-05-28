//
//  JGJClearCacheTableViewCell.h
//  mix
//
//  Created by Tony on 2017/1/3.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJClearCacheTableViewCell : UITableViewCell

@property(nonatomic ,strong)NSString *NumCache;

@property (nonatomic, strong) JGJMineInfoThirdModel *mineInfoThirdModel;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
