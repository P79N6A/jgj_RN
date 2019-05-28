//
//  TYTextView.h
//  mix
//
//  Created by Tony on 16/6/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYTextView;
@protocol TYTextViewDelegate <NSObject>

@optional
- (void)TYTextViewDidEndEditing:(NSString *)textStr;
- (void)TYTextViewDidChange:(UITextView *)textView;
- (void)TYTextViewBeginEditing:(UITextView *)textView;
- (void)TYTextViewCurheight:(UITextView *)textView curHeight:(CGFloat )curHeight;

@end

@interface TYTextView : UITextView
@property (nonatomic , assign) BOOL canReturn;
@property (nonatomic , weak) id<TYTextViewDelegate> TYTextDelegate;

- (id)getText;
- (void)startShowTextView;
- (void)setPlaceholderStr:(NSString *)placeholderStr placeholderColor:(UIColor *)placeholderColor;
- (void)setContentColor:(UIColor *)contentColor;
@end
