//
//  JGJMultipleAvatarView.h
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMultipleAvatarView : UIView
@property (nonatomic, strong) NSArray<NSString *> *imageURLs;
@property (nonatomic, assign) CGFloat avatarWH;
+(CGFloat)inset;
@end
