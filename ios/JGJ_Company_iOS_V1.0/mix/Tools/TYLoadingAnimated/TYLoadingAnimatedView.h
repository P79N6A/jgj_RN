//
//  TYLoadingAnimatedView.h
//  uiimage-from-animated-gif
//
//  Created by Tony on 16/1/13.
//
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
@interface TYLoadingAnimatedView : UIView
@property (nonatomic,strong) FLAnimatedImageView *gifImageView;//gif图
@property (nonatomic,strong) UILabel *lable;//gif图
@property (nonatomic,assign) BOOL defultBool;//gif图

@end
