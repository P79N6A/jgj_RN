//
//  JGJAddProNameVc.h
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJAddProNameVc;

@protocol JGJAddProNameVcDelegate <NSObject>

@optional

- (void)addProNameVc:(JGJAddProNameVc *)vc requestResponse:(NSDictionary *)requestResponse;

@end

@interface JGJAddProNameVc : UIViewController

@property (nonatomic, weak) id <JGJAddProNameVcDelegate> delegate;

@end
