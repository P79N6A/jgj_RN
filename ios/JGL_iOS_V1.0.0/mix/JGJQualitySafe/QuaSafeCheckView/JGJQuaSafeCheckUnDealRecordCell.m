//
//  JGJQuaSafeCheckUnDealRecordCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckUnDealRecordCell.h"

#import "JGJNineSquareView.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

#import "UIView+GNUtil.h"

#import "JGJQuaSafeUnDealedResultView.h"

@interface JGJQuaSafeCheckUnDealRecordCell () <

    JGJQuaSafeUnDealedResultViewDelegate
>

@property (strong, nonatomic)  UILabel *inspectNameLable;

@property (strong, nonatomic)  UILabel *resultLable;

@property (strong, nonatomic)  JGJQuaSafeUnDealedResultView *containBottomBtnView;

@property (strong, nonatomic) UIImageView *expandImageView;

@property (strong, nonatomic) UIView *contentCheckView;

@property (strong, nonatomic) UIView *tapExpandView;
@end

@implementation JGJQuaSafeCheckUnDealRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *cellIdentifier = @"JGJQuaSafeCheckUnDealRecordCell";
    JGJQuaSafeCheckUnDealRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[JGJQuaSafeCheckUnDealRecordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style
                      reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *tapExpandView = [[UIView alloc] init];
        
        tapExpandView.backgroundColor = [UIColor clearColor];
        
        self.tapExpandView = tapExpandView;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExPandAction)];
        
        tapGesture.numberOfTapsRequired = 1;
        
        [tapExpandView addGestureRecognizer:tapGesture];
        
        [self.contentView addSubview:tapExpandView];
        
        //检查标题
        UILabel *inspectNameLable = [[UILabel alloc] init];
        
        inspectNameLable.lineBreakMode = NSLineBreakByCharWrapping;
        
//        inspectNameLable.backgroundColor = [UIColor clearColor];
        
        inspectNameLable.layer.borderWidth = 0;
        
        inspectNameLable.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        inspectNameLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        inspectNameLable.textColor = AppFont333333Color;
        
        CGFloat contentW = TYGetUIScreenWidth - 125;
        
        inspectNameLable.preferredMaxLayoutWidth = contentW;
        
        self.inspectNameLable = inspectNameLable;
        
        inspectNameLable.numberOfLines = 0;
        
        [self.contentView addSubview:inspectNameLable];
        
        //检查结果
        UILabel *resultLable = [[UILabel alloc] init];
        
        resultLable.textAlignment = NSTextAlignmentRight;
        
        resultLable.backgroundColor = [UIColor whiteColor];
        
        resultLable.textColor = AppFont999999Color;
        
        resultLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        self.resultLable = resultLable;
        
        [self.contentView addSubview:resultLable];
        
        //展开箭头
        UIImageView *expandImageView = [[UIImageView alloc] init];
        
        expandImageView.image = [UIImage imageNamed:@"arrow_down"];
        
        // 设置内部的imageView的内容模式为居中
        expandImageView.contentMode = UIViewContentModeCenter;
        // 超出边框的内容不需要裁剪
        expandImageView.clipsToBounds = NO;
        
        self.expandImageView = expandImageView;
        
        [self.contentView addSubview:expandImageView];
        
        UIView *contentCheckView = [[UIView alloc] init];
        
        contentCheckView.backgroundColor = [UIColor whiteColor];
        
        self.contentCheckView = contentCheckView;
        
        [self.contentView addSubview:contentCheckView];
        
        JGJQuaSafeUnDealedResultView *containBottomBtnView = [[JGJQuaSafeUnDealedResultView  alloc] init];
        
        containBottomBtnView.delegate = self;
        
        containBottomBtnView.backgroundColor = [UIColor whiteColor];
        
        self.containBottomBtnView = containBottomBtnView;
        
        [self.contentCheckView addSubview:containBottomBtnView];
        
        UIView *lineView = [[UIView  alloc] init];
        
        lineView.backgroundColor = AppFontdbdbdbColor;
        
        self.lineView = lineView;
        
        [self.contentView addSubview:lineView];
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setListModel:(JGJInspectPlanProInfoDotListModel *)listModel {
    
    _listModel = listModel;
    
    self.inspectNameLable.text = _listModel.dot_name;
    
    self.resultLable.text = @"[未检查]";
    
    [self configViewFrame:_listModel];
    
    [self configExpandImageView:_listModel];
    
    self.containBottomBtnView.listModel = listModel;
}

- (void)configViewFrame:(JGJInspectPlanProInfoDotListModel *)listModel {

    CGFloat leading = 10.0;
    
    CGFloat trailing = 10.0;
    
    CGFloat top = 18.0 ;
    
    CGFloat bottom = 13.0;
    
    self.expandImageView.frame = CGRectMake(TYGetUIScreenWidth - 25, top, 15, 9);
    
    //暂时未用
    self.resultLable.frame = CGRectMake(TYGetUIScreenWidth - 115, top, 80, 21);
    
    self.expandImageView.centerY = self.resultLable.centerY;
    
    CGFloat contentW = TYGetUIScreenWidth - 125;
    
    self.inspectNameLable.preferredMaxLayoutWidth = contentW;
    
    CGFloat inspectNameLableH = [NSString stringWithContentWidth:contentW content: self.inspectNameLable.text font:AppFont30Size];
    
    //大标题
    self.inspectNameLable.frame = CGRectMake(leading, top, contentW, inspectNameLableH);
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
    
    if (self.listModel.dot_status_list.count > 0) {
        
        replyModel = [self.listModel.dot_status_list firstObject];
    }
    
    //底部大小
    
    CGFloat containBottomBtnViewH = 28.0;
    
    CGFloat contentCheckViewH = containBottomBtnViewH + bottom;
    
    //底部按钮
    self.containBottomBtnView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, containBottomBtnViewH);
    
    self.contentCheckView.frame = CGRectMake(0, top + TYGetMaxY(self.inspectNameLable), TYGetUIScreenWidth, contentCheckViewH);
    
    self.contentCheckView.hidden = !listModel.isExPand;
    
    //收缩隐藏按钮效果好些
    self.containBottomBtnView.hidden = !listModel.isExPand;
    
//  执行人不是自己不能展开
    self.expandImageView.hidden = NO;
    
    if ([replyModel.is_operate isEqualToString:@"0"] && [listModel.status isEqualToString:@"0"]) {

        self.contentCheckView.height = 0;

        self.containBottomBtnView.hidden = YES;

        self.expandImageView.hidden = YES;
    }
    
    CGFloat lineViewH = 0.5;
    
    self.lineView.frame = CGRectMake(10, TYGetMaxY(self.contentCheckView), TYGetUIScreenWidth, lineViewH);
    
    //收缩后的高度
    _listModel.shrinkHeight = top + TYGetMaxY(self.inspectNameLable) + lineViewH;
    
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
    //点击展开的View
    
    self.tapExpandView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetMaxY(self.inspectNameLable) + bottom);
    
    listModel.cellHeight = TYGetMaxY(self.lineView);
    
    self.lineView.y = listModel.isExPand ? listModel.cellHeight - lineViewH : _listModel.shrinkHeight - lineViewH;

}

- (void)configExpandImageView:(JGJInspectPlanProInfoDotListModel *)listModel {
    
    if (self.listModel.isExPand) {
        
        self.expandImageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
        self.expandImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
}

- (void)handleExPandAction {
    
    self.listModel.isExPand = !self.listModel.isExPand;
    
    if (!self.listModel.isExPand) {
        
        self.expandImageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }else {
        
        self.expandImageView.transform = CGAffineTransformMakeRotation(0);
    }
    
    if ([self.delegate respondsToSelector:@selector(quaSafeCheckUnDealRecordCell:)]) {
        
        [self.delegate quaSafeCheckUnDealRecordCell:self];
    }
    
}

#pragma mark - 点击按钮
- (void)quaSafeUnDealedResultView:(JGJQuaSafeUnDealedResultView *)unDealedResultView selectedButtonType:(QuaSafeUnDealedResultViewButtonType)buttonType {

    if ([self.delegate respondsToSelector:@selector(quaSafeCheckUnDealRecordCell:selectedListModel: buttonType:)]) {
        
        [self.delegate quaSafeCheckUnDealRecordCell:self selectedListModel:self.listModel buttonType:buttonType];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
