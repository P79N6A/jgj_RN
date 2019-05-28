//
//  JGJAddProNameView.h
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJAddProNameViewDefaultType, //项目名

} JGJAddProNameViewType;

@class JGJAddProNameView;

@protocol JGJAddProNameViewDelegate <NSObject>

@optional

- (void)addProNameView:(JGJAddProNameView *)view name:(NSString *)name;

@end

@interface JGJAddProNameView : UIView

@property (nonatomic, assign) JGJAddProNameViewType type;

@property (nonatomic, weak) id <JGJAddProNameViewDelegate> delegate;
@end
