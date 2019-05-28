//
//  JGJCheckContentFooterView.h
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJCheckContentFooterViewdelegate <NSObject>

- (void)JGJCheckContentClickBtn;

@end;
@interface JGJCheckContentFooterView : UIView
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic)  id <JGJCheckContentFooterViewdelegate> delegate;
- (void)buttonTitle:(NSString *)title;

@end
