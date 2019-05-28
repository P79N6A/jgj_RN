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
    [self addSubview:self.contentView];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.titleLabel.text = self.title;
}
@end
