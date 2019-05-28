//
//  JGJReportViewController.h
//  mix
//
//  Created by Tony on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJReportTableViewCell.h"

@interface JGJReportViewController : UIViewController
@property (copy,nonatomic) NSString *pid;
@property (strong,nonatomic) NSMutableArray<JGJReportModel *> *reportsArray;

@end

