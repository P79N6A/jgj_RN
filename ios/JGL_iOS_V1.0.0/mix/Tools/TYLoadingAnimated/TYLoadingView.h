//
//  TYLoadingView.h
//  uiimage-from-animated-gif
//
//  Created by Tony on 16/1/13.
//
//

#import <UIKit/UIKit.h>
#import "TYLoadingAnimatedView.h"
@interface TYLoadingView : UIView
//需要显示的问题
@property (nonatomic,copy)   NSString *title;

@property (nonatomic,assign)   BOOL defultBool;


@property (nonatomic,assign) NSInteger lineNum;

@property (nonatomic,strong) UIImageView *shadowImageView;


@property (strong, nonatomic) IBOutlet TYLoadingAnimatedView *animationView;

//初始化方法
- (id)initWithTitle:(NSString *)title WithFrame:(CGRect )frame;

- (id)initNodataDefultWithTitle:(NSString *)title WithFrame:(CGRect )frame;

@end
