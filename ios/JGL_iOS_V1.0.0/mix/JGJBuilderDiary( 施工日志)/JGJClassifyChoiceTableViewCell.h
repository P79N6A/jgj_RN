//
//  JGJClassifyChoiceTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editeTextfiledBuilderDailyClassFyDelegate <NSObject>
-(void)BuilderDailyTextfiledClassFyEndEidting:(NSString *)text andTag:(NSInteger)tag;

@end
@interface JGJClassifyChoiceTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *deaprtConstance;
@property (strong, nonatomic) IBOutlet UILabel *topLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;
@property (strong, nonatomic) id <editeTextfiledBuilderDailyClassFyDelegate>delegate;

@end
