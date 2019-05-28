//
//  JLGLoadWebViewFailure.m
//  mix
//
//  Created by Tony on 16/1/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGLoadWebViewFailure.h"

@interface JLGLoadWebViewFailure ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation JLGLoadWebViewFailure

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        // Initialization code
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

- (IBAction)refreshButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(LoadWebViewFailureRefresh)]) {
        [self.delegate LoadWebViewFailureRefresh];
    }
}
@end
