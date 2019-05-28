//
//  JGJNoDataDefultView.h
//  JGJCompany
//
//  Created by Tony on 2017/11/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickHelpBtnBlock)(NSString *title);
typedef void(^clickpubBtnBlock)(NSString *title);

@interface JGJNoDataDefultView : UIView
-(instancetype)initWithFrame:(CGRect)frame andSuperView:(UIView *)view andModel:(JGJNodataDefultModel *)model helpBtnBlock:(clickHelpBtnBlock)helpBlock pubBtnBlock:(clickpubBtnBlock)pubBlock;
@property (assign, nonatomic) JGJNodataDefultModel *defultModel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *contentLbale;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;
@property (strong, nonatomic) IBOutlet UIButton *pubButton;
@property (copy, nonatomic)  clickHelpBtnBlock helpBlock;
@property (copy, nonatomic)  clickpubBtnBlock pubBlock;

@end
