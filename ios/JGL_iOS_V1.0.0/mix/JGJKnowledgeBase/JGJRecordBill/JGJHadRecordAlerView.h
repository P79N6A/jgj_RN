//
//  JGJHadRecordAlerView.h
//  mix
//
//  Created by Tony on 2017/5/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHadRecordAlerView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIButton *lookButton;

+(void)showAlerInwindown;
@end
