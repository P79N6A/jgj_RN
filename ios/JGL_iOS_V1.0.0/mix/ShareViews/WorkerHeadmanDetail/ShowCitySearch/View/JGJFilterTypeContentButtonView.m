//
//  JGJFilterTypeContentButtonView.m
//  mix
//
//  Created by celion on 16/4/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJFilterTypeContentButtonView.h"

@interface JGJFilterTypeContentButtonView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *cityNameLine;
@property (weak, nonatomic) IBOutlet UIView *workTypeLine;
@end
@implementation JGJFilterTypeContentButtonView

+ (instancetype)filterTypeContentButtonView {

    return [[[NSBundle mainBundle] loadNibNamed:@"JGJFilterTypeContentButtonView" owner:self options:nil] lastObject];
}

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
    [[[NSBundle mainBundle] loadNibNamed:@"JGJFilterTypeContentButtonView" owner:self options:nil] lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.cityName.textColor = AppFont999999Color;
    self.workTypeName.textColor = AppFont999999Color;
    self.cityButton.backgroundColor = AppFontfafafaColor;
    self.workTypeButton.backgroundColor = AppFontfafafaColor;
    [self.workTypeButton addObserver:self forKeyPath:@"selected" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.cityButton addObserver:self forKeyPath:@"selected" options:(NSKeyValueObservingOptionNew) context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIButton *)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    object.backgroundColor = object.selected ? [UIColor whiteColor] : AppFontfafafaColor;
    if (object.tag == 100) {
        self.cityNameLine.hidden = object.selected;
        self.workTypeLine.hidden = self.workTypeButton.selected;
        self.cityName.textColor = self.cityButton.selected ? AppFont333333Color : AppFont999999Color;
    }
    if (object.tag == 101) {
        self.workTypeLine.hidden = object.selected;
        self.cityNameLine.hidden = self.cityButton.selected;
        self.workTypeName.textColor = self.workTypeButton.selected ? AppFont333333Color : AppFont999999Color;
    }
}

- (void)dealloc {

    [self.workTypeButton removeObserver:self forKeyPath:@"selected"];
    [self.cityButton removeObserver:self forKeyPath:@"selected"];
}

- (IBAction)cityButtonPressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(filterCityTypeMenuButtonPressed:)]) {
        [self.delegate filterCityTypeMenuButtonPressed:sender];
    }
}

- (IBAction)workTypeButtonPressed:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(filterWorkTypeButtonPressed:)]) {
        [self.delegate filterWorkTypeButtonPressed:sender];
    }
}


@end
