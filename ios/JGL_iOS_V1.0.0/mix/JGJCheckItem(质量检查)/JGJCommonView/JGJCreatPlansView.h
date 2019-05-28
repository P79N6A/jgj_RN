//
//  JGJCreatPlansView.h
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickCreatBlock) (NSString *title);

@interface JGJCreatPlansView : UIView
    @property (strong, nonatomic) IBOutlet UIImageView *imageview;
    
    @property (strong, nonatomic) IBOutlet UILabel *contentLable;
+ (JGJCreatPlansView *)showView:(UIView *)view andModel:(JGJNodataDefultModel *)model andBlock:(clickCreatBlock)response;
@property (strong, nonatomic) IBOutlet UIButton *planButton;
    
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (copy, nonatomic)  clickCreatBlock creatBlock;

@property (assign, nonatomic) JGJNodataDefultModel *defultModel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstance;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstance;
@end
