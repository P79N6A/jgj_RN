//
//  JGJMemberSelTypeCell.h
//  mix
//
//  Created by yj on 2017/9/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMemberSelTypeModel:NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *icon;

@end

@interface JGJMemberSelTypeCell : UITableViewCell

@property (nonatomic, strong) JGJMemberSelTypeModel *selTypeModel;

@end
