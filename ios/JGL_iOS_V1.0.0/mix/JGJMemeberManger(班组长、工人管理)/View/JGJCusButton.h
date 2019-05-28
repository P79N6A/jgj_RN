//
//  JGJCusButton.h
//  mix
//
//  Created by yj on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJMemberMangerModel.h"

@interface JGJCusButtonModel : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) BOOL selected;

@end

@interface JGJCusButton : UIButton

@property (nonatomic, strong) JGJMemberImpressTagViewModel *tagModel;

@end
