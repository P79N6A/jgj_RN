//
//  JGJSelectProViewController.h
//  mix
//
//  Created by Tony on 2017/6/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSelectProViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *proTableview;
/*
 *已经选中了的项目id
 */
@property (strong, nonatomic) NSString *pidStr;
@end
