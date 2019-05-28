//
//  JGJChatBootomView.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatBootomView.h"
#import "JGJChatBootomTeamButton.h"
#import "Masonry.h"

@interface JGJChatBootomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSMutableArray <NSDictionary *>*dataSourceArr;
@end

@implementation JGJChatBootomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = AppFontfafafaColor;
}

- (void)setDataSource:(NSArray <NSDictionary *>*)dataSourceArr{
    if (!dataSourceArr.count) {
        return;
    }
    
    self.dataSourceArr = dataSourceArr.mutableCopy;
    [self layoutIfNeeded];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat chatButtonH = self.bounds.size.height;
    CGFloat chatButtonW = chatButtonH*0.82;
    
    CGFloat superMargin = self.dataSourceArr.count == 4?24.0:13.0;//和父控件的间隔
    

    CGFloat buttonsMargin = (TYGetViewW(self.contentView) - self.dataSourceArr.count*chatButtonW - superMargin*2)/(self.dataSourceArr.count - 1);//控件之间的间隔

    __weak typeof(self) weakSelf = self;
    [self.dataSourceArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JGJChatBootomTeamButton *chatBottomTeamBtn = [[JGJChatBootomTeamButton alloc ] init];
        
        [weakSelf.contentView addSubview:chatBottomTeamBtn];
        [chatBottomTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(chatButtonW);
            make.height.mas_equalTo(chatButtonH);
            make.centerY.mas_equalTo(self.contentView).offset(-5);
            make.left.mas_equalTo(self.contentView).offset(superMargin +idx*(chatButtonW + buttonsMargin));
        }];
        chatBottomTeamBtn.tag = idx;
        [chatBottomTeamBtn addTarget:self action:@selector(chatBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [chatBottomTeamBtn titleStr:obj[@"title"] img:[UIImage imageNamed:obj[@"img"]]];
    }];
}

- (void)chatBottomBtnClick:(UIButton *)button{
    //走delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBottomBtnClick:button:)]) {
        [self.delegate chatBottomBtnClick:self button:button];
    }
    
    //走block
    if (self.chatBootomBtnClick) {
        self.chatBootomBtnClick(self,button);
    }
}

@end
