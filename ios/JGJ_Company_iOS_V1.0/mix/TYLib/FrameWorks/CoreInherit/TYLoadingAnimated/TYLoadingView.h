//
//  TYLoadingView.h
//  uiimage-from-animated-gif
//
//  Created by Tony on 16/1/13.
//
//

#import <UIKit/UIKit.h>

@interface TYLoadingView : UIView
//需要显示的问题
@property (nonatomic,copy) NSString *title;

//初始化方法
- (id)initWithTitle:(NSString *)title WithFrame:(CGRect )frame;
@end
