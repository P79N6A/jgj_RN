//
//  JGJlLogChoiceClassfyViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJlLogChoiceClassfyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;
@property (strong, nonatomic) selectvaluelistModel *selectListModel;
@property (strong, nonatomic) NSArray <selectvaluelistModel *> *dateArr;
@property (strong, nonatomic) NSString  *element_Key;

@end
