//
//  JGJTechniqueTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editeTextviewAndBuilderDailyTechDelegate <NSObject>
-(void)BuilderDailyTechTextViewEndEidting:(NSString *)text;

@end
@interface JGJTechniqueTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *titlelable;
@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) id<editeTextviewAndBuilderDailyTechDelegate>delegate;
@end
