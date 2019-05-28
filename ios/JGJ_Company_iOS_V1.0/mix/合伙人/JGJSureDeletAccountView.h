//
//  JGJSureDeletAccountView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sureDleteBlock)(BOOL deleteButton);
@interface JGJSureDeletAccountView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)sureDleteBlock sureBlock;
@property (strong, nonatomic) IBOutlet UIView *baseView;
+(void)showDeleteSureButtonAlerViewandBlock:(sureDleteBlock)deleteButtons;
@end
