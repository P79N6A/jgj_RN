//
//  JGJReusableFooterView.h
//  mix
//
//  Created by yj on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockCancel)();
@interface JGJReusableFooterView : UICollectionReusableView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) BlockCancel blockCancel;
@end
