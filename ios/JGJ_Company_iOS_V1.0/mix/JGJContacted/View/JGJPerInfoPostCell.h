//
//  JGJPerInfoPostCell.h
//  JGJCompany
//
//  Created by yj on 2017/8/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJPerInfoPostCell : UITableViewCell

@property (nonatomic, strong) JGJChatPerInfoModel *perInfoModel;

+ (CGFloat)postCellMaxLayoutWidth;

+ (CGFloat)postCellMaxRowHeight;
@end
