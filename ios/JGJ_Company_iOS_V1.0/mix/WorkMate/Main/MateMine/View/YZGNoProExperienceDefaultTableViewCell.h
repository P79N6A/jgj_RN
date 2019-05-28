//
//  YZGNoProExperienceDefaultTableViewCell.h
//  mix
//
//  Created by Tony on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGNoProExperienceDefaultTableViewCell;
@protocol YZGNoProExperienceDefaultTableViewCellDelegate <NSObject>

- (void )NoProExperienceAddProExperience:(YZGNoProExperienceDefaultTableViewCell *)noProExperienceCell;

@end
@interface YZGNoProExperienceDefaultTableViewCell : UITableViewCell

@property (nonatomic , weak) id<YZGNoProExperienceDefaultTableViewCellDelegate> delegate;

@end
