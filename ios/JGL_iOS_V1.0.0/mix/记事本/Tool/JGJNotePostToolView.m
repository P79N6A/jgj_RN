//
//  JGJNotePostToolView.m
//  mix
//
//  Created by yj on 2019/1/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNotePostToolView.h"

@interface JGJNotePostToolView ()

@property (weak, nonatomic) IBOutlet UIButton *markButton;

@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation JGJNotePostToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
       [self initialSubViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self initialSubViews];
    }
    
    return self;
}

- (void)initialSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
}

- (IBAction)markImportButtonPressed:(UIButton *)sender {
    
//    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(notePostToolView:buttonType:button:)]) {
        
        [self.delegate notePostToolView:self buttonType:JGJNotePostMarkImportButtonType button:sender];
    }
    
}

- (IBAction)photoButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(notePostToolView:buttonType:button:)]) {
        
        [self.delegate notePostToolView:self buttonType:JGJNotePostMarkPhotoButtonType button:sender];
    }
    
}

+ (CGFloat)toolViewHeight {
    
    return 44;
}

@end
