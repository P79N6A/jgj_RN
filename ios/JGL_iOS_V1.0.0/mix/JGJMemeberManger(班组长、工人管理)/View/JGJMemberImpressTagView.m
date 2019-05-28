//
//  JGJMemberImpressTagView.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberImpressTagView.h"

#define btnH 24

#define margin 10

#define offsetY 20

#define selOffsetY 15 //选中类型偏移

#define selBtnH 28 //选中类型按钮高度

@interface JGJMemberImpressTagView ();

//保存最后此添加的按钮位置
@property (nonatomic, strong) JGJCusButton *lastButton;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) CGFloat btnX;

@property (nonatomic, assign) CGFloat btnY;

@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) CGFloat buttonH;

@end

@implementation JGJMemberImpressTagView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;
}

- (void)setTagViewType:(JGJMemberImpressTagViewType)tagViewType {
    
    _tagViewType = tagViewType;
    
    if (tagViewType == JGJMemberImpressComselTagViewType || tagViewType == JGJMemberImpressRemarkselTagViewType || tagViewType == JGJMemberImpressAgencyselTagViewType) {
        
        _padding =  TYIS_IPHONE_5 ? 12 : 15.0;
        
        _btnX = _padding;
        
        _btnY = offsetY;
        
        _offsetX = _padding;
        
        _offset = _offsetX * 2;
        
        _buttonH = 30.0;
        
    }
    
    if (!_textColor) {
        
        _textColor = AppFont333333Color;
        
    }
    
    if (!_backColor) {
        
        _backColor = AppFontFDEDEDColor;
    }
    
    if (!_layerColor) {
        
        _layerColor = AppFontF5A6A6Color;
    }
}

#pragma mark - 设置数据
- (void)setTags:(NSMutableArray *)tags {
    
    //有数据就不添加了，然后单个添加
    if (self.tags.count > 0) {
        
        return;
    }
    
    _tags = tags;

    switch (self.tagViewType) {
            
        case JGJMemberImpressShowTagViewType:{
            
            [self showTagViewTypeWithTags:tags];
            
        }
            
            break;
            
        case JGJMemberImpressSelTagViewType:{
            
            [self selTagViewTypeWithTags:tags];
        }
            
            break;
            
        case JGJMemberImpressAgencyselTagViewType:
        case JGJMemberImpressRemarkselTagViewType:
            
        case JGJMemberImpressComselTagViewType:{
            
            [self comSelTagViewTypeWithTags:tags];
            
            //传出当前的View用于保存数据
            if ([self.delegate respondsToSelector:@selector(tagView:sender:)]) {
                
                [self.delegate tagView:self sender:nil];
                	
            }
        }
            
            break;
            
        default:
            break;
    }
    
}

-(void)showTagViewTypeWithTags:(NSArray *)tags {
    
    CGFloat btnX = margin;
    
    CGFloat btnY = offsetY;
    
    JGJCusButton *btn = [[JGJCusButton alloc] init];
    
    for(int i = 0; i < tags.count; i++){
        
        JGJMemberImpressTagViewModel *tagModel = tags[i];
        
        tagModel.tagViewType = JGJMemberImpressShowTagViewType;
        
        //宽度自适应
        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont22Size]};
        
        CGRect frame_W = [tagModel.tag_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
        
        if ([NSString isEmpty:tagModel.tag_name]) {
            
            frame_W = CGRectZero;
        }
        
        if (btnX + frame_W.size.width + margin * 2 > TYGetUIScreenWidth - margin * 2) {
            
            btnX = margin;
            
            btnY = TYGetMaxY(btn) + margin;
        }
        
        btn = [[JGJCusButton alloc]initWithFrame:CGRectMake(btnX, btnY, frame_W.size.width + margin * 2, btnH)];
        
        btn.tagModel = tagModel;
        
        [btn setTitle:tagModel.tag_name forState:UIControlStateNormal];
        
        [btn setTitleColor:_textColor?:AppFont333333Color forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:AppFont22Size];
        
        btn.backgroundColor = _backColor?:AppFontFDEDEDColor;
        
        [btn.layer setLayerBorderWithColor:_layerColor?:AppFontF5A6A6Color width:0.5 radius:btnH / 2.0];
        
        [self addSubview:btn];
        
        btnX = CGRectGetMaxX(btn.frame) + margin;
        
        self.lastButton = btn;
        
    }
        
    if ([self.delegate respondsToSelector:@selector(tagView:sender:)]) {
        
        [self.delegate tagView:self sender:self.lastButton];
        
    }
    
    self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetMaxY(btn.frame) + offsetY);
}

-(void)selTagViewTypeWithTags:(NSMutableArray *)tagModels {
    
    CGFloat btnX = margin;
    
    CGFloat btnY = offsetY;
    
    CGFloat offsetX = 4 + margin;
    
    CGFloat offset = offsetX * 2;
    
    JGJCusButton *btn = [[JGJCusButton alloc] init];
    
    for(int i = 0; i < tagModels.count; i++){
        
        JGJMemberImpressTagViewModel *tagModel = tagModels[i];
        
        tagModel.tagViewType = JGJMemberImpressSelTagViewType;
        
        offset += tagModel.selected ? 22 : 0; //单个选中宽度增加
        
        //宽度自适应
        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont28Size]};
        
        CGRect frame_W = [tagModel.tag_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
        
        if (btnX + frame_W.size.width + offset > TYGetUIScreenWidth - margin * 2) {
            
            btnX = margin;
            
            btnY = TYGetMaxY(btn) + selOffsetY; //上下间距
        }
        
        btn = [[JGJCusButton alloc]initWithFrame:CGRectMake(btnX, btnY, frame_W.size.width + offset, selBtnH)];
        
        btn.tagModel = tagModel;
        
        btn.selected = tagModel.selected;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
        
        btn.backgroundColor = [UIColor whiteColor];
                
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        btnX = CGRectGetMaxX(btn.frame)+ offsetX;
        
        //保存最后一次的按钮用于添加单个按钮
        self.lastButton = btn;
    }
    
    self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetMaxY(btn.frame) + offsetY);
}

#pragma mark - 常用选中标签
-(void)comSelTagViewTypeWithTags:(NSMutableArray *)tagModels {
    
    JGJCusButton *btn = [[JGJCusButton alloc] init];
    
    _offset = 0;
    
    for(int i = 0; i < tagModels.count; i++){
        
        JGJMemberImpressTagViewModel *tagModel = tagModels[i];
        
        tagModel.tagViewType = self.tagViewType;
        
        if (![NSString isEmpty:tagModel.tag_name]) {
            
            _offset = tagModel.tag_name.length > 3 ? 20 : 0; //单个选中宽度增加
            
        }
        
        CGFloat frame_W = (TYIS_IPHONE_5 ? 70.0 : 90.0) + _offset;
        
        if (_btnX + frame_W + _offset > TYGetUIScreenWidth - 40) {
            
            _btnX = _padding;
            
            _btnY = TYGetMaxY(btn) + selOffsetY; //上下间距
        }
        
        btn = [[JGJCusButton alloc]initWithFrame:CGRectMake(_btnX, _btnY, frame_W, _buttonH)];
        
        btn.tagModel = tagModel;
        
        btn.selected = tagModel.selected;
        
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(comTagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnX = CGRectGetMaxX(btn.frame)+ _offsetX;
        
        //保存最后一次的按钮用于添加单个按钮
        self.lastButton = btn;
    }
    
    self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetMaxY(btn.frame) + offsetY);
}

-(void)setTagModel:(JGJMemberImpressTagViewModel *)tagModel {
    
    _tagModel = tagModel;
    
    //包含就返回不添加
    if ([self.tags containsObject:tagModel]) {
        
        return;
    }
    
    [self.tags addObject:tagModel];
    
    if (tagModel.selected && ![self.selTagModels containsObject:tagModel]) {
        
        [self.selTagModels addObject:tagModel];
    }
    
    CGFloat btnX = margin + CGRectGetMaxX(self.lastButton.frame);
    
    CGFloat btnY = offsetY + CGRectGetMaxY(self.lastButton.frame);
    
    CGFloat offsetX = 4 + margin;
    
    CGFloat offset = offsetX * 2;
    
    NSArray *tagModels = @[tagModel];
    
    JGJCusButton *btn = [[JGJCusButton alloc] init];
    
    for(int i = 0; i < tagModels.count; i++){
        
        JGJMemberImpressTagViewModel *tagModel = tagModels[i];
        
        offset += tagModel.selected ? 22 : 0; //单个选中宽度增加
        
        //宽度自适应
        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont28Size]};
        
        CGRect frame_W = [tagModel.tag_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
        
        if (btnX + frame_W.size.width + offset > TYGetUIScreenWidth - margin * 2) {
            
            btnX = margin;
            
            btnY = TYGetMaxY(btn) + selOffsetY; //上下间距
        }
        
        btn = [[JGJCusButton alloc]initWithFrame:CGRectMake(btnX, btnY, frame_W.size.width + offset, selBtnH)];
        
        btn.selected = tagModel.selected;
        
        [btn setImage:[UIImage imageNamed:@"appraise_sel_icon"] forState:UIControlStateSelected];
        
        [btn setTitle:tagModel.tag_name forState:UIControlStateNormal];
        
        [btn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
        
        btn.backgroundColor = [UIColor whiteColor];
        
        [btn.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:btnH / 2.0];
        
        [self addSubview:btn];
        
        tagModel.tagNameW = frame_W.size.width;
        
        btn.tagModel = tagModel;
        
        [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        btnX = CGRectGetMaxX(btn.frame)+ offsetX;
        
        self.lastButton = btn;
        
    }
    
    self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetMaxY(btn.frame) + margin * 2);
    
    //更新位置
    [self updateSubControlFrame];
    
    if ([self.delegate respondsToSelector:@selector(tagView:sender:)]) {
        
        [self.delegate tagView:self sender:self.lastButton];
        
    }
}

#pragma mark - 计算高度

-(JGJMemberImpressTagView *)tagViewWithTags:(NSArray *)tags tagViewType:(JGJMemberImpressTagViewType)tagViewType {
    
    self.tagViewType = tagViewType;
    
    self.tags = tags.mutableCopy;
    
    return self;
}

- (void)tagButtonPressed:(JGJCusButton *)sender {
    
    JGJMemberImpressTagViewModel *tagModel = sender.tagModel;
    
    //选择后超出5的情况
    if (self.selTagModels.count >= MaxTagCount) {
        
        if ([self.selTagModels containsObject:tagModel]) {
            
            [self.selTagModels removeObject:tagModel];
            
            tagModel.selected = NO;
            
            sender.selected = NO;
            
            sender.tagModel = tagModel;
        }
        
        if (self.selTagModels.count >= MaxTagCount) {
            
           [TYShowMessage showPlaint:@"最多可选中5个标签"];
        }
        
        [self updateSubControlFrame];
        
        return;
    }
    
    tagModel.selected = !tagModel.selected;
    
    sender.selected = !sender.selected;
    
    sender.tagModel = tagModel;
    
    if (tagModel.selected) {
        
        [self.selTagModels addObject:tagModel];
        
    }else {
        
        [self.selTagModels removeObject:tagModel];
    }
    
    [self updateSubControlFrame];
    
    if ([self.delegate respondsToSelector:@selector(tagView:sender:)]) {
        
        [self.delegate tagView:self sender:sender];
        
    }
    
}

- (void)comTagButtonPressed:(JGJCusButton *)sender {
    
    JGJMemberImpressTagViewModel *tagModel = sender.tagModel;
    
    tagModel.selected = !tagModel.selected;
    
    sender.selected = !sender.selected;
    
    sender.tagModel = tagModel;
    
    if (tagModel.selected) {
        
        [self.selTagModels addObject:tagModel];
        
    }else {
        
        [self.selTagModels removeObject:tagModel];
    }
    
    if ([self.delegate respondsToSelector:@selector(tagView:sender:)]) {
        
        [self.delegate tagView:self sender:sender];
        
    }
}

- (void)updateSubControlFrame {
    
    CGFloat btnX = margin;
    
    CGFloat btnY = offsetY;
    
    CGFloat offsetX = 4 + margin;
    
    CGFloat offset = offsetX * 2;
    
    CGFloat offsetW = 0;
    
    CGFloat sumRowOffsetW = 0;
    
    for (JGJCusButton *btn in self.subviews) {
        
        if ([btn isKindOfClass:NSClassFromString(@"JGJCusButton")]) {
            
//            JGJCusButtonModel *buttonModel = self.tagModels[btn.tag - 100];
            
            JGJMemberImpressTagViewModel *tagModel = btn.tagModel;
            
            offsetW = tagModel.selected ? 22 : 0; //单个选中宽度增加
            
            sumRowOffsetW += tagModel.selected ? 22 : 0; //单个选中宽度增加
            
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont28Size]};
            
            CGRect frame_W = [tagModel.tag_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (btnX + frame_W.size.width + offset + sumRowOffsetW > TYGetUIScreenWidth - margin * 2) {
                
                btnX = margin;
                
                btnY += btn.height + selOffsetY; //上下间距 //上下间距20
                
                sumRowOffsetW = 0;
            }
            
            btn.frame = CGRectMake(btnX, btnY, frame_W.size.width + offset + offsetW, selBtnH);
            
            btnX = CGRectGetMaxX(btn.frame) + offsetX;

            self.frame = CGRectMake(self.x, self.y, self.width, CGRectGetMaxY(btn.frame) + offsetY);
            
            [btn addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            TYLog(@"height ===== %@ title = %@", @(self.height), tagModel.tag_name);
            
            if (btn.tag == 116) {
                
                TYLog(@"116 self.height ===== %@", @(self.height));
            }
        }
        
    }
    
    TYLog(@"self.height ===== %@", @(self.height));

}

- (NSMutableArray *)selTagModels {
    
    if (!_selTagModels) {
        
        _selTagModels = [NSMutableArray array];
        
    }
    
    return _selTagModels;
}

#pragma mark - 复位状态
- (void)resetTagView {
    
    for (JGJCusButton *btn in self.subviews) {
        
        if ([btn isKindOfClass:NSClassFromString(@"JGJCusButton")]) {
            
            btn.selected = NO;
            
            JGJMemberImpressTagViewModel *tagModel = btn.tagModel;
            
            tagModel.selected = NO;
            
            btn.tagModel = tagModel;
        }
    }
}

@end
