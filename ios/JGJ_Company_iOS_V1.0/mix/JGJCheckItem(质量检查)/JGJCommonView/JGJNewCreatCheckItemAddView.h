//
//  JGJNewCreatCheckItemAddView.h
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickCreatBlock) (NSString *title);

@interface JGJNewCreatCheckItemAddView : UIView
@property (strong, nonatomic) IBOutlet UILabel *placeLable;

@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (copy, nonatomic)  clickCreatBlock creatBlock;

+ (JGJNewCreatCheckItemAddView *)showView:(UIView *)view  andBlock:(clickCreatBlock)response;

@end
