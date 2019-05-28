//
//  JGJQuaSafeCheckRecordCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeCheckRecordCell.h"

#import "JGJNineSquareView.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

#import "UIView+GNUtil.h"

#import "JGJQuaSafeDealedResultView.h"

#import "NSString+Extend.h"

@interface JGJQuaSafeCheckRecordCell () <

    JGJQuaSafeDealedResultViewDelegate,

    JGJNineSquareViewDelegate

>

@property (strong, nonatomic)  UILabel *inspectNameLable;

@property (strong, nonatomic)  UILabel *resultLable;

@property (strong, nonatomic)  UILabel *subitemLable;

@property (strong, nonatomic)  JGJNineSquareView *thumbnailImageView;

@property (strong, nonatomic)  JGJQuaSafeDealedResultView *containBottomBtnView;

@property (strong, nonatomic) UIImageView *expandImageView;

//@property (strong, nonatomic) JGJQuaSafeDealedResultView *dealedResultView;


@property (strong, nonatomic) UIView *contentCheckView;

@property (strong, nonatomic) UIView *tapExpandView;
@end

@implementation JGJQuaSafeCheckRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *cellIdentifier = @"JGJQuaSafeCheckRecordCell";
    JGJQuaSafeCheckRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[JGJQuaSafeCheckRecordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;

}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style
                      reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //检查结果
        UILabel *resultLable = [[UILabel alloc] init];
        
        resultLable.textAlignment = NSTextAlignmentRight;
        
        resultLable.backgroundColor = [UIColor whiteColor];
        
        resultLable.textColor = AppFont999999Color;
        
        resultLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        self.resultLable = resultLable;
        
        [self.contentView addSubview:resultLable];
        
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
        
//        inspectNameLable.backgroundColor = [UIColor clearColor];
        
        inspectNameLable.lineBreakMode = NSLineBreakByCharWrapping;
        
        inspectNameLable.layer.borderWidth = 0;
        
        inspectNameLable.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        inspectNameLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        inspectNameLable.textColor = AppFont333333Color;
        
        inspectNameLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 125;
        
        self.inspectNameLable = inspectNameLable;
        
        inspectNameLable.numberOfLines = 0;
        
        [self.contentView addSubview:inspectNameLable];
        
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
        
        //检查说明
        UILabel *subitemLable = [[UILabel alloc] init];
        
        subitemLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 110;
        
        subitemLable.numberOfLines = 0;
        
        subitemLable.backgroundColor = [UIColor whiteColor];
        
        subitemLable.font = [UIFont systemFontOfSize:AppFont30Size];
        
        subitemLable.textColor = AppFont999999Color;
        
        self.subitemLable = subitemLable;
        
        [self.contentCheckView addSubview:subitemLable];
        
        
        //缩略图
        JGJNineSquareView *thumbnailImageView  = [[JGJNineSquareView alloc] init];
        
        thumbnailImageView.delegate = self;
        
        self.thumbnailImageView = thumbnailImageView;
        
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        
        [self.contentCheckView addSubview:thumbnailImageView];
        
        JGJQuaSafeDealedResultView *containBottomBtnView = [[JGJQuaSafeDealedResultView  alloc] init];
        
        containBottomBtnView.delegate = self;
        
        containBottomBtnView.backgroundColor = [UIColor whiteColor];
        
        self.containBottomBtnView = containBottomBtnView;
        
        [self.contentCheckView addSubview:containBottomBtnView];
        
        UIView *lineView = [[UIView  alloc] init];
        
        lineView.backgroundColor = AppFontf1f1f1Color;
        
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
    
    [self configListModel:_listModel];
    
    [self configViewFrame:_listModel];
    
    [self confExpandImageView:_listModel];
    
    self.containBottomBtnView.listModel = _listModel;
    
}

#pragma mark- 显示数据
- (void)configListModel:(JGJInspectPlanProInfoDotListModel *)listModel {

    self.inspectNameLable.text = listModel.dot_name;
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
    
    if (listModel.dot_status_list.count > 0) {
        
        replyModel = [listModel.dot_status_list firstObject];
    }
    
    UIColor *statusColor = AppFont999999Color;
    
    NSString *status = @"";
    
    if ([replyModel.status isEqualToString:@"0"]) {
        
        status = @"[未检查]";
        
    }else if ([replyModel.status isEqualToString:@"1"]) {
        
        statusColor = AppFontFF0000Color;
        
        status = @"[待整改]";
        
    }else if ([replyModel.status isEqualToString:@"2"]) {
        
        status = @"[不用检查]";
        
    }else if ([replyModel.status isEqualToString:@"3"]) {
        
        statusColor = AppFont83C76EColor;
        
        status = @"[通过]";
    }
    
    self.resultLable.textColor = statusColor;
    
    self.resultLable.text = status;
    
    self.subitemLable.text = replyModel.comment;
    
    self.containBottomBtnView.listModel = listModel;
    
    [self.thumbnailImageView imageCountLoadHeaderImageView:replyModel.imgs headViewWH:80.0 headViewMargin:5.0];
}

- (void)configViewFrame:(JGJInspectPlanProInfoDotListModel *)listModel {

    CGFloat leading = 25.0;
    
    CGFloat top = 13.0;
    
    CGFloat bottom = 18.0;
    
    JGJInspectPlanProInfoDotReplyModel *replyModel = nil;
    
    if (listModel.dot_status_list.count > 0) {
        
        replyModel = [listModel.dot_status_list firstObject];
    }
    
    self.expandImageView.frame = CGRectMake(TYGetUIScreenWidth - 25, top, 15, 9);
    
    self.resultLable.frame = CGRectMake(TYGetUIScreenWidth - 115, top, 80, 21);
    
    self.expandImageView.centerY = self.resultLable.centerY;
    
    CGFloat contentW = TYGetUIScreenWidth - 125;
    
    self.inspectNameLable.preferredMaxLayoutWidth = contentW;
    
    self.subitemLable.preferredMaxLayoutWidth = contentW;
    
    CGFloat inspectNameLableH = [NSString stringWithContentWidth:contentW content: self.inspectNameLable.text font:AppFont30Size];
    
    //大标题
    self.inspectNameLable.frame = CGRectMake(leading, top, contentW, inspectNameLableH);
    
    //检查说明
    
    CGFloat subitemLableH = 0;
    
    if (![NSString isEmpty:replyModel.comment]) {
        
        subitemLableH = [NSString stringWithContentWidth:contentW content: replyModel.comment font:AppFont30Size];
        
    }
    
    self.subitemLable.hidden = [NSString isEmpty:replyModel.comment];
    
    self.subitemLable.frame = CGRectMake(leading, 0, contentW, subitemLableH);
    
    //缩略图
    CGFloat thumbnailImageViewH = [JGJNineSquareView nineSquareViewHeight:replyModel.imgs headViewWH:80.0 headViewMargin:5];
    
    self.thumbnailImageView.frame = CGRectMake(leading, TYGetMaxY(self.subitemLable) + top, TYGetUIScreenWidth, thumbnailImageViewH);
    
    //底部按钮
    self.containBottomBtnView.frame = CGRectMake(0, TYGetMaxY(self.thumbnailImageView) + top, TYGetUIScreenWidth, 28);
    
    //除了不用检查其余都能看得见底部按钮
    BOOL isHiddenContainBottomBtnView = [replyModel.status isEqualToString:@"0"];

    self.thumbnailImageView.hidden = replyModel.imgs.count == 0;
    
    if (![NSString isEmpty:replyModel.comment] && replyModel.imgs.count == 0) {
        
        self.containBottomBtnView.y = TYGetMaxY(self.subitemLable) + top;
        
        self.thumbnailImageView.y = TYGetMaxY(self.subitemLable);
        
    }else if ([NSString isEmpty:replyModel.comment] && replyModel.imgs.count > 0) {
        
        self.thumbnailImageView.y = 0;
        
        self.containBottomBtnView.y = TYGetMaxY(self.thumbnailImageView) + top;
        
    }else if ([NSString isEmpty:replyModel.comment] && replyModel.imgs.count == 0) {
        
        self.containBottomBtnView.y = 0;
    }
    
    
    if (isHiddenContainBottomBtnView) {
        
        self.containBottomBtnView.y = TYGetMaxY(self.thumbnailImageView);
        
        self.containBottomBtnView.height = 0;
        
    }
    
    //底部大小
    
    CGFloat contentCheckViewH = TYGetMaxY(self.containBottomBtnView) - TYGetMinY(self.subitemLable);
    
    self.contentCheckView.frame = CGRectMake(0, top + TYGetMaxY(self.inspectNameLable), TYGetUIScreenWidth, contentCheckViewH);
    
    self.contentCheckView.hidden = !listModel.isExPand;
    
    //收缩隐藏按钮效果好些
    self.containBottomBtnView.hidden = !listModel.isExPand;
    
    CGFloat lineViewH = 0.5;
    
    //收缩后的高度
    _listModel.shrinkHeight = top + TYGetMaxY(self.inspectNameLable) + lineViewH;
    
    //点击展开的View
    
    self.tapExpandView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetMaxY(self.inspectNameLable) + bottom);
    
    listModel.cellHeight = TYGetMaxY(self.contentCheckView) + top + lineViewH;
    
    CGFloat lineViewY = listModel.isExPand ? listModel.cellHeight - lineViewH : _listModel.shrinkHeight - lineViewH;
    
    //去掉收缩的的分割线
    self.subitemLable.backgroundColor = [UIColor clearColor];
    
    self.lineView.frame = CGRectMake(10, lineViewY, TYGetUIScreenWidth, lineViewH);

}

- (void)confExpandImageView:(JGJInspectPlanProInfoDotListModel *)listModel {

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
    
    if ([self.delegate respondsToSelector:@selector(quaSafeCheckRecordCell:)]) {
        
        [self.delegate quaSafeCheckRecordCell:self];
    }
    
}

- (void)quaSafeDealResultView:(JGJQuaSafeDealedResultView *)dealResultView selectedButtonType:(QuaSafeDealResultViewButtonType)buttonType {

    if ([self.delegate respondsToSelector:@selector(quaSafeCheckRecordCell:selectedListModel: buttonType:)]) {
        
        [self.delegate quaSafeCheckRecordCell:self selectedListModel:self.listModel buttonType:buttonType];
    }
    
}

#pragma mark - 点击缩略图
- (void)nineSquareView:(JGJNineSquareView *)squareView squareImages:(NSArray *)squareImages didSelectedIndex:(NSInteger)index {

    if ([self.delegate respondsToSelector:@selector(detailThumbnailCell:imageViews:didSelectedIndex:)]) {
        
        [self.delegate detailThumbnailCell:self imageViews:squareImages didSelectedIndex:index];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
