//
//  JGJPersonDetailWageListModel.h
//  mix
//
//  Created by Tony on 2016/7/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class PersonDetailWageListList,PersonDetailWageListWorkday,PersonDetailWageListAccounts_Type;
@interface JGJPersonDetailWageListModel : TYModel


@property (nonatomic, strong) NSArray<PersonDetailWageListList *> *pro_list;

@property (nonatomic, assign) CGFloat total_month;

@property (nonatomic, copy) NSString *total_month_txt;

@end

@interface PersonDetailWageListList : NSObject

@property (nonatomic, strong) NSArray<PersonDetailWageListWorkday *> *workday;

@property (nonatomic, copy) NSString *pro_name;

@end

@interface PersonDetailWageListWorkday : NSObject

@property (nonatomic, copy) NSString *overtime;

@property (nonatomic, copy) NSString *date_turn;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger modify_marking;

@property (nonatomic, copy) NSString *manhour;

@property (nonatomic, copy) NSString *date_txt;

@property (nonatomic, strong) PersonDetailWageListAccounts_Type *accounts_type;

@property (nonatomic, assign) CGFloat amounts;

@end

@interface PersonDetailWageListAccounts_Type : NSObject

@property (nonatomic, copy) NSString *txt;

@property (nonatomic, assign) NSInteger code;

@end

