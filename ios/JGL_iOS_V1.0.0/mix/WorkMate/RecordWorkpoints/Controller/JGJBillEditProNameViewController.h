//
//  JGJBillEditProNameViewController.h
//  mix
//
//  Created by yj on 16/7/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifyTheProjectNameSuccess)(NSIndexPath *indexPath,NSString *changedName);
@interface JGJBillEditProNameViewController : UIViewController
@property (nonatomic,copy) ModifyTheProjectNameSuccess modifyThePorjectNameSuccess;
@property (nonatomic, strong) NSArray *dataArray;
@end
