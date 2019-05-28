//
//  JGJBottomVIewAndButton.h
//  mix
//
//  Created by Tony on 2017/3/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickBottombutton <NSObject>

- (void)clickBottomButtonevent;

@end
@interface JGJBottomVIewAndButton : UIView
@property (nonatomic ,strong)id <clickBottombutton>delegate;
@property (nonatomic ,strong)UIButton *button;
@end
