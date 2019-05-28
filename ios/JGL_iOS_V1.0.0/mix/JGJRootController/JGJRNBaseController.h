//
//  JGJRNBaseController.h
//  mix
//
//  Created by Json on 2019/4/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCTRootView;
@interface JGJRNBaseController : UIViewController
@property (nonatomic, weak) RCTRootView *rootView;
@property (nonatomic, copy) NSString *moudleName;
@property (nonatomic, strong) NSURL *jsCodeLocation;
@end


