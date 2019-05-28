//
//  JGJNewAddProlistVC.h
//  mix
//
//  Created by celion on 16/5/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJNewAddProlistBlock)(NSArray *);
@interface JGJNewAddProlistVC : UIViewController
@property (nonatomic, strong)  JGJSynBillingModel *synBillingModel;
@property (nonatomic, copy) JGJNewAddProlistBlock addProlistBlock;
@property (strong, nonatomic) NSArray *dataSource;
@end
