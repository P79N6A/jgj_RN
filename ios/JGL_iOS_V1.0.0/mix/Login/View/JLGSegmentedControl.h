//
//  JLGSegmentedControl.h
//  mix
//
//  Created by Tony on 16/1/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JLGSegmentedBaseTag 11
#define JLGSegmentedRadius 12.0

@protocol JLGSegmentedControlDelegate <NSObject>
- (void)SegmentedControlSelectedIndex:(NSInteger )index;
@end

@interface JLGSegmentedControl : UIView

@property (nonatomic , weak) id<JLGSegmentedControlDelegate> delegate;

@property (nonatomic,copy) NSArray *titlesArray;
@property (nonatomic,assign) NSInteger segmentAtIndex;//选中的索引

- (void)changeSelectButtonByIndex:(NSInteger )index;//改变选中的按钮
- (void)titlesBy:(NSArray *)titlesArray forSegmentAtIndex:(NSInteger )index;

@end
