//
//  JGJPayDeailTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^payViewHeight) (float height);
@protocol choicePaytypeDelegate <NSObject>
-(void)choicePaytypeAndtype:(NSString *)type;
@end
@interface JGJPayDeailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *AlipayButton;
@property (strong, nonatomic) IBOutlet UIButton *WXPayButton;
@property (strong, nonatomic) IBOutlet UIImageView *AlipaySelectImage;
@property (strong, nonatomic) IBOutlet UIView *departLable;
@property (strong, nonatomic) IBOutlet UIImageView *WXinPaySelectImage;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;
@property (strong ,nonatomic)id <choicePaytypeDelegate> delegate;
@property (copy ,nonatomic)payViewHeight blockHeight;
@property (strong, nonatomic) IBOutlet UIImageView *wxinHeadimageview;
@property (strong, nonatomic) IBOutlet UILabel *wexinNameLable;

@end
