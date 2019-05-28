//
//  JGJMarkBillRemarkViewController.h
//  mix
//
//  Created by Tony on 2018/1/29.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
#import "UIPhotoViewController.h"
typedef enum: NSUInteger{
    JGJRemarkBillOtherType,
    JGJRemarkBillContractType,
}JGJRemarkType;

@protocol JGJMarkBillRemarkViewControllerDelegate <NSObject>

@optional
- (void)makeRemarkWithImages:(NSMutableArray *)images text:(NSString *)remarkText;
@end

@interface JGJMarkBillRemarkViewController : UIPhotoViewController

@property (strong, nonatomic)YZGGetBillModel *yzgGetBillModel;
@property (assign, nonatomic)JGJRemarkType remarkBillType;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id<JGJMarkBillRemarkViewControllerDelegate> markBillRemarkDelegate;

@property (nonatomic,strong) UIActionSheet *sheet;

@end
