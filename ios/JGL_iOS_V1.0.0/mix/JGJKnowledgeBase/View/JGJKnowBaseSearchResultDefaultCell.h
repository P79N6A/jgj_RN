//
//  JGJKnowBaseSearchResultDefaultCell.h
//  mix
//
//  Created by yj on 17/4/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJKnowBaseSearchingResultDefaultCellType = 1, //搜索中
    
    JGJKnowBaseNoResultDefaultCellType //没有搜索结果

} JGJKnowBaseSearchResultDefaultCellType;

@interface JGJKnowBaseSearchResultDefaultCell : UITableViewCell

@property (nonatomic, copy) NSString *searchValue;

//@property (nonatomic, strong) NSArray *results;

@property (nonatomic, assign) JGJKnowBaseSearchResultDefaultCellType searchResultDefaultCellType;

+ (CGFloat)knowBaseSearchResultDefaultCellHeight;
@end
