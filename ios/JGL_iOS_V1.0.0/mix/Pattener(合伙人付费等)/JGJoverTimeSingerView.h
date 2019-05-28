//
//  JGJoverTimeSingerView.h
//  JGJCompany
//
//  Created by Tony on 2017/8/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IkownBlock)(NSString *buttonTitle);

@interface JGJoverTimeSingerView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *IkownButton;
@property (copy, nonatomic)  IkownBlock cancelBlock;
+(void)showOverTimeViewWithModel:(JGJOverTimeModel *)timeModel andClickIkwonButton:(IkownBlock)cancelBlock ;

@end
