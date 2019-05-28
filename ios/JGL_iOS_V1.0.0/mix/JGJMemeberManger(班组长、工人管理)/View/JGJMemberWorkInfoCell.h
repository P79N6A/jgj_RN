//
//  JGJMemberWorkInfoCell.h
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMemberWorkInfoModel: NSObject

@property (copy, nonatomic) NSString *imageStr;

@property (copy, nonatomic) NSString *typeDes;

@property (copy, nonatomic) NSString *changeColorStr;

@end

@interface JGJMemberWorkInfoCell : UITableViewCell

@property (nonatomic, strong) JGJMemberWorkInfoModel *infoModel;

@end
