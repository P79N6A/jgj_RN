//
//  JGJPackNumViewController.h
//  mix
//
//  Created by Tony on 2017/3/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FillOutNumSuccessBackBlock)(JGJFilloutNumModel *filloutmodel);
@interface JGJPackNumViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textfiled;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UILabel *numlable;
@property (strong, nonatomic)JGJFilloutNumModel *filloutmodel;

@property (nonatomic, copy) FillOutNumSuccessBackBlock fillBackBlock;
@end
