//
//  TYLoadingView.m
//  uiimage-from-animated-gif
//
//  Created by Tony on 16/1/13.
//
//

#import "TYLoadingView.h"
#import "CALayer+SetLayer.h"
@interface TYLoadingView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end
@implementation TYLoadingView

- (id)initWithTitle:(NSString *)title WithFrame:(CGRect )frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.defultBool = NO;

        [self setupView];
    }
    return self;
}
-(id)initNodataDefultWithTitle:(NSString *)title WithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = @"加载中...";
        self.defultBool = YES;
        [self setupView];
    }
    return self;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    //添加contentView
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    self.animationView.defultBool = _defultBool;
    if (_shadowImageView) {
        [_shadowImageView removeFromSuperview];
    }
    if (_defultBool) {

        _shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 104, 104)];
//        _shadowImageView.image = [UIImage imageNamed:@"BG3"];
        _shadowImageView.backgroundColor = [UIColor whiteColor];
        _shadowImageView.layer.cornerRadius = 5;
        _shadowImageView.layer.shadowColor =  [UIColor blackColor].CGColor;
        _shadowImageView.layer.shadowOffset = CGSizeMake(0, 6);
        _shadowImageView.layer.shadowOpacity = 0.1;//阴影透明度，默认0
        _shadowImageView.layer.shadowRadius = 5;//阴影半径，默认3
        [self addSubview:_shadowImageView];
        
        
//        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;

    }

//    [self.contentView.layer setLayerCornerRadius:4.0];
    [self addSubview:self.contentView];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.titleLabel.text = self.title;
    if (self.lineNum) {
        self.titleLabel.numberOfLines = self.lineNum;
    }
}
@end
