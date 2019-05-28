//
//  JGJTabHeaderAvatarView.m
//  mix
//
//  Created by yj on 2018/7/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTabHeaderAvatarView.h"

#import "JGJAvatarView.h"

@interface JGJTabHeaderAvatarView ()

@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *numLable;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@end

@implementation JGJTabHeaderAvatarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonSet];
        
    }
    
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJTabHeaderAvatarView" owner:self options:nil] lastObject];
        
    self.containView.frame = self.bounds;
    
    self.titleLable.textColor = AppFont333333Color;
    
    [self addSubview:self.containView];
    
    self.titleLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 125;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerAvatarViewPressed)];
    
    [self.containView addGestureRecognizer:tap];
    
    self.numLable.textColor = AppFont333333Color;
    
    self.numLable.font = [UIFont systemFontOfSize:AppFont28Size];
    
    self.desLable.textColor = AppFont333333Color;
    
    self.desLable.font = [UIFont systemFontOfSize:AppFont30Size];
}

- (void)setAvatars:(NSArray *)avatars {
    
    _avatars = avatars;
    
    [self.avatarView getRectImgView:_avatars];
    
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.titleLable.text = _title;
    
}

- (void)setNum:(NSString *)num {
    
    _num = num;
    
    if (![NSString isEmpty:num]) {
        
        self.numLable.text = [NSString stringWithFormat:@"%@人", num];
        
    }
    
}

- (void)headerAvatarViewPressed {
    
    if ([self.delegate respondsToSelector:@selector(tabHeaderAvatarView:)]) {
        
        [self.delegate tabHeaderAvatarView:self];
        
    }
}

+ (CGFloat)headerHeight {
    
    return 89;
}

@end
