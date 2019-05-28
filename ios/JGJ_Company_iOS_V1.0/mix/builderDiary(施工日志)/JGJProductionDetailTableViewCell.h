//
//  JGJProductionDetailTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editeTextviewAndBuilderDailyDelegate <NSObject>
-(void)BuilderDailyTextViewEndEidting:(NSString *)text andTag:(NSInteger)tag;

@end
@interface JGJProductionDetailTableViewCell : UITableViewCell
<
UITextViewDelegate

>
@property (strong, nonatomic) IBOutlet UILabel *topTitleLable;
@property (strong, nonatomic) IBOutlet UITextView *TextView;
@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) id <editeTextviewAndBuilderDailyDelegate>delegate;
@property (strong, nonatomic) JGJSelfLogTempRatrueModel *model;

@end
