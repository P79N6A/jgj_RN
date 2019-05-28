//
//  JGJChatBootomView.m
//  mix
//
//  Created by Tony on 2016/8/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatBootomView.h"
#import "Masonry.h"
#import "JGJChatBootomButton.h"
#import "JGJChatBootomTeamButton.h"


@interface JGJChatBootomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

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

- (void)setDataSource:(NSArray <NSDictionary *>*)dataSourceArr workProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    if (!dataSourceArr.count) {
        return;
    }
    
    self.dataSourceArr = dataSourceArr.mutableCopy;
    self.workProListModel = workProListModel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addButton];
}

- (void)addButton{
    if (!self.workProListModel) {
        return ;
    }

    __weak typeof(self) weakSelf = self;
    //是否是team分组
//    BOOL isTeamGroup = [self.workProListModel.class_type isEqualToString:@"team"];
    
    //项目班组样式一样
    BOOL isTeamGroup = YES;
    
    CGFloat chatButtonH = 0.0;
    CGFloat chatButtonW = 0.0;
    CGFloat superMargin = 0.0;
    CGFloat buttonsMargin = 0.0;
    
    if (isTeamGroup) {
        chatButtonH = self.bounds.size.height;
        chatButtonW = chatButtonH*0.82;
        
        superMargin = self.dataSourceArr.count == 4?24.0:13.0;//和父控件的间隔
        
        buttonsMargin = (TYGetViewW(self.contentView) - self.dataSourceArr.count*chatButtonW - superMargin*2)/(self.dataSourceArr.count - 1);//控件之间的间隔
    }else{
        chatButtonW = 70;
        chatButtonH = chatButtonW/2.0;
        superMargin = self.dataSourceArr.count == 4?24.0:40;//和父控件的间隔
        
        //如果是5s这种宽的屏幕
        if (TYIS_IPHONE_5_OR_LESS) {
            superMargin = ceil(superMargin/2.4);
        }
        
        buttonsMargin = (TYGetViewW(self.contentView) - self.dataSourceArr.count*chatButtonW - superMargin*2)/(self.dataSourceArr.count - 1);//控件之间的间隔
    }
    
    [self.dataSourceArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *commonButton = [[UIButton alloc] init];
        if (isTeamGroup) {
            JGJChatBootomTeamButton *chatBottomTeamBtn = [[JGJChatBootomTeamButton alloc ] init];
            
            [weakSelf.contentView addSubview:chatBottomTeamBtn];
            [chatBottomTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(chatButtonW);
                make.height.mas_equalTo(chatButtonH);
                make.centerY.mas_equalTo(self.contentView).offset(-5);
                make.left.mas_equalTo(self.contentView).offset(superMargin + idx*(chatButtonW + buttonsMargin));
            }];
            chatBottomTeamBtn.tag = idx;
            [chatBottomTeamBtn addTarget:self action:@selector(chatBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [chatBottomTeamBtn titleStr:obj[@"title"] img:[UIImage imageNamed:obj[@"img"]]];
            commonButton = chatBottomTeamBtn;
        }else{
            JGJChatBootomButton *chatBottomBtn = [[JGJChatBootomButton alloc ] init];
            
            [weakSelf.contentView addSubview:chatBottomBtn];
            [chatBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(chatButtonW);
                make.height.mas_equalTo(chatButtonH);
                make.centerY.mas_equalTo(self.contentView).mas_offset(-6);
                make.left.mas_equalTo(self.contentView).offset(superMargin + idx*(chatButtonW + buttonsMargin));
            }];
            chatBottomBtn.tag = idx;
            [chatBottomBtn addTarget:self action:@selector(chatBottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [chatBottomBtn titleStr:obj[@"title"] img:[UIImage imageNamed:obj[@"img"]]];
            commonButton = chatBottomBtn;
        }
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
