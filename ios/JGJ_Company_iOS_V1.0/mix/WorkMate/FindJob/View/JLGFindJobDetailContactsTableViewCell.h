//
//  JLGFindJobDetailContactsTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/18.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockContactButtonPressed)();
@interface JLGFindJobDetailContactsTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *friendsInfoArray;

@property (nonatomic, copy) NSString *frontString;//数字前面的字符串
@property (nonatomic, copy) NSString *behindString;//数字后面的字符串
@property (nonatomic, copy) BlockContactButtonPressed blockContactButtonPressed;
@end
