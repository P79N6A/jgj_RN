//
//  JGJSynAddressBookCell.h
//  mix
//
//  Created by celion on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddSynModelBlock)(JGJSynBillingModel *);
@interface JGJSynAddressBookCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSynBillingModel *addressBookModel;
@property (nonatomic, copy) AddSynModelBlock addSynModelBlock;

@property (nonatomic, copy) NSString *searchValue; //搜索的文字，改变显示的颜色

@end
