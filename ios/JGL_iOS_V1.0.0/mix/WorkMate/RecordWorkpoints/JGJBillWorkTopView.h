//
//  JGJBillWorkTopView.h
//  mix
//
//  Created by Tony on 2017/4/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJBillWorkTopView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
- (void)setContentLabletext:(NSString *)content;
@end
