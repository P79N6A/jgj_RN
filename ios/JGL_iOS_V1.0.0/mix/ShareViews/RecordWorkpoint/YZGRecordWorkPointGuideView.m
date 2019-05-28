//
//  YZGRecordWorkPointGuideView.m
//  mix
//
//  Created by Tony on 16/3/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGRecordWorkPointGuideView.h"
#import "CALayer+SetLayer.h"

typedef NS_ENUM(NSUInteger, GuidViewType) {
    GuidViewTypeDefualt = 0,
    GuidViewTypeSegment
};
@interface YZGRecordWorkPointGuideView ()
@property (nonatomic, assign) GuidViewType guidViewType;

@property (nonatomic, copy) NSArray *workImgsArr;//图片的数组
@property (nonatomic, copy) NSString *identifyString;//身份字符串

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *GuideStripImage;
@property (weak, nonatomic) IBOutlet UIImageView *GuideContentImage;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuideStripLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuideStripLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuideStripLayoutT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuideStripLayoutL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowLayoutR;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iNowLayoutT;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowLayoutL;
@end

@implementation YZGRecordWorkPointGuideView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.identifyString = (self.isMateBool?:JLGisMateBool)?@"RecordWorkpoints_Guide_SelectedLeader":@"RecordWorkpoints_Guide_SelectedMate";
}

#pragma mark - 聊天进入班组长/工头显示对工人
- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel {
    _workProListModel = workProListModel;
    if ([_workProListModel.myself_group isEqualToString:@"1"]) {
        self.identifyString = @"RecordWorkpoints_Guide_SelectedMate";
    }else if ([_workProListModel.myself_group isEqualToString:@"0"]){
        self.identifyString = @"RecordWorkpoints_Guide_SelectedLeader";
    }
}

- (void)showGuideViewSegment:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel{
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self layoutIfNeeded];//改了约束
    }
    
    self.guidViewType = GuidViewTypeSegment;
    [self changeContentSegment:RecordWorkPointGuideModel];
}

- (void)showRecordWorkPointGuideView:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel{
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self layoutIfNeeded];//改了约束
    }

    self.guidViewType = GuidViewTypeDefualt;
    [self changeContent:RecordWorkPointGuideModel];
}

- (void)hiddenRecordWorkPointGuideView{
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [self removeFromSuperview];

        self.workIndexPathArr = nil;
        self.workFramePathArr = nil;
        self.RecordWorkPointGuideModel = nil;
        [self.workCellArr removeAllObjects];
        if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkPointHidden:)]) {
            [self.delegate RecordWorkPointHidden:self];
        }
    }
}

- (void)changeContent:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel{
    CGRect showFrame = RecordWorkPointGuideModel.showFrame;
    NSInteger imageIndex = RecordWorkPointGuideModel.guideIndex;
    
    self.arrowImageView.image = [UIImage imageNamed:@"RecordWorkpoints_Guide_RightTop"];
    self.GuideStripImage.image = [UIImage imageNamed:@"RecordWorkpoints_Guide_Strip"];
    
//    self.arrowLayoutL.priority = 1;
//    self.arrowLayoutR.priority = 999;
    
//    if (self.iNowLayoutT.constant != 178) {
//        self.iNowLayoutT.constant = 178;
//    }
    

    //iphone5 包工的时候再iphone5的屏幕下太低了
    if (TYIS_IPHONE_5_OR_LESS &&
        self.RecordWorkPointGuideModel.accountTypeCode == 2 &&
        (imageIndex + 1 )== self.RecordWorkPointGuideModel.maxIndex &&
        self.iNowLayoutT.constant != 5) {
        self.iNowLayoutT.constant = 5;
    }
    
    if (self.arrowLayoutR.constant != 10) {
        self.arrowLayoutR.constant = 10;
    }


    self.GuideStripLayoutT.constant = TYGetRectY(showFrame);
    self.GuideStripLayoutW.constant = TYGetRectWidth(showFrame);
    self.GuideStripLayoutH.constant = TYGetRectHeight(showFrame);
    self.GuideStripLayoutL.constant = 0;
    
    self.contentImageView.image = [UIImage imageNamed:self.workImgsArr[imageIndex]];
    self.RecordWorkPointGuideModel.maxIndex = self.workImgsArr.count;
    
    self.GuideContentImage.image = (UIImage *)self.workCellArr[imageIndex];
    [self.GuideContentImage.layer setLayerCornerRadiusWithRatio:0.02];
    [self.contentView layoutIfNeeded];
}

- (void)changeContentSegment:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel{
    CGRect showFrame = RecordWorkPointGuideModel.showFrame;
#ifdef JGTestFunction
    NSInteger imageIndex = 0;
#else
    NSInteger imageIndex = RecordWorkPointGuideModel.guideIndex;
#endif

    CGFloat constantH = TYGetRectHeight(showFrame)*0.2;
    CGFloat constantW = TYGetRectWidth(showFrame)/3.0*52.0/320.0;
    self.GuideStripLayoutT.constant = TYGetRectY(showFrame) - constantH/2.0;
    self.GuideStripLayoutW.constant = TYGetRectWidth(showFrame)/3.0 + constantW;
    self.GuideStripLayoutH.constant = TYGetRectHeight(showFrame) + constantH;
    self.GuideStripLayoutL.constant = (TYGetRectX(showFrame) + TYGetRectWidth(showFrame)/3.0*RecordWorkPointGuideModel.guideIndex) - constantW/2.0;
    
    self.contentImageView.image = [UIImage imageNamed:self.workImgsArr[imageIndex]];
    self.RecordWorkPointGuideModel.maxIndex = self.workImgsArr.count;
    
    self.GuideContentImage.image = (UIImage *)self.workCellArr[imageIndex];
    [self.GuideContentImage.layer setLayerCornerRadiusWithRatio:0.02];
    [self.contentView layoutIfNeeded];
    
    if (imageIndex == 0) {
        self.arrowImageView.image = [UIImage imageNamed:@"RecordWorkpoints_Guide_LeftTop"];
//        self.arrowLayoutL.priority = 999;
//        self.arrowLayoutR.priority = 1;
        self.arrowLayoutR.constant = -30;
    }else{
        self.arrowImageView.image = [UIImage imageNamed:@"RecordWorkpoints_Guide_RightTop"];
//        self.arrowLayoutL.priority = 1;
//        self.arrowLayoutR.priority = 999;
        self.arrowLayoutR.constant = 10;
    }
    
    self.GuideStripImage.image = [UIImage imageNamed:@"RecordWorkpoints_Guide_Strip_Small"];
//    self.iNowLayoutT.constant = 40;
}

- (IBAction)deleteBtnClick:(id)sender {
    [self hiddenRecordWorkPointGuideView];
}

- (IBAction)IKnowBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkPointGuideNext:)]) {
        [self.delegate RecordWorkPointGuideNext:self];
    }
    
    if (self.guidViewType == GuidViewTypeDefualt) {
        YZGRecordWorkPointGuideModel *recordWorkPointGuideModel = self.RecordWorkPointGuideModel;
        recordWorkPointGuideModel.guideIndex += 1;
        if (recordWorkPointGuideModel.guideIndex == recordWorkPointGuideModel.maxIndex) {
            [self hiddenRecordWorkPointGuideView];
            return;
        }
        
        recordWorkPointGuideModel.indexPath = self.workIndexPathArr[recordWorkPointGuideModel.guideIndex];
        recordWorkPointGuideModel.showFrame = [self.workFramePathArr[recordWorkPointGuideModel.guideIndex] CGRectValue];
        
        [self changeContent:recordWorkPointGuideModel];
    }else{
#ifdef JGTestFunction
        YZGRecordWorkPointGuideModel *recordWorkPointGuideModel = self.RecordWorkPointGuideModel;
        recordWorkPointGuideModel.guideIndex += 1;
        
        if (recordWorkPointGuideModel.guideIndex == recordWorkPointGuideModel.maxIndex) {
            [self hiddenRecordWorkPointGuideView];
            return;
        }
        
        recordWorkPointGuideModel.indexPath = self.workIndexPathArr[recordWorkPointGuideModel.guideIndex - 1];
        recordWorkPointGuideModel.showFrame = [self.workFramePathArr[recordWorkPointGuideModel.guideIndex- 1] CGRectValue];
        
        [self changeContent:recordWorkPointGuideModel];
#else
        YZGRecordWorkPointGuideModel *recordWorkPointGuideModel = self.RecordWorkPointGuideModel;
        recordWorkPointGuideModel.guideIndex += 1;
        
        if (recordWorkPointGuideModel.guideIndex >= 3) {
            if (recordWorkPointGuideModel.guideIndex == recordWorkPointGuideModel.maxIndex) {
                [self hiddenRecordWorkPointGuideView];
                return;
            }
            
            recordWorkPointGuideModel.indexPath = self.workIndexPathArr[recordWorkPointGuideModel.guideIndex - 3];
            recordWorkPointGuideModel.showFrame = [self.workFramePathArr[recordWorkPointGuideModel.guideIndex - 3] CGRectValue];
            
            [self changeContent:recordWorkPointGuideModel];
        }else{
            [self changeContentSegment:recordWorkPointGuideModel];
        }
#endif

    }
}

#pragma mark - 懒加载
- (NSArray *)workImgsArr
{
    if (!_workImgsArr) {
        NSMutableArray *workImgsArr = [NSMutableArray array];
        
        if (self.RecordWorkPointGuideModel.accountTypeCode == 1) {
            workImgsArr = @[self.identifyString,
                                @"RecordWorkpoints_Guide_Template",
                                @"RecordWorkpoints_Guide_WorkHour",
                                @"RecordWorkpoints_Guide_OverHour",
                                ].mutableCopy;
        }else if(self.RecordWorkPointGuideModel.accountTypeCode == 2){
            workImgsArr = @[self.identifyString,
                             @"RecordWorkpoints_Guide_InputUnitPrice",
                             @"RecordWorkpoints_Guide_InputQuantity"
                             ].mutableCopy;
        }else if(self.RecordWorkPointGuideModel.accountTypeCode == 3){
            workImgsArr = @[self.identifyString,
                             @"RecordWorkpoints_Guide_BorrowingMoney"
                                ].mutableCopy;
        }
        
        if (self.guidViewType == GuidViewTypeSegment) {
            NSArray *billsArr = @[@"RecordWorkpoints_Guide_DayBill",
                                  @"RecordWorkpoints_Guide_ContractBill",
                                  @"RecordWorkpoints_Guide_BorrowBill"
                                  ];
            
#ifdef JGTestFunction
            NSString *billStr = billsArr[self.RecordWorkPointGuideModel.accountTypeCode - 1];
            [workImgsArr insertObject:billStr atIndex:0];
#else
            workImgsArr = [billsArr arrayByAddingObjectsFromArray:workImgsArr].mutableCopy;
#endif

        }
        _workImgsArr = workImgsArr.copy;
    }
    return _workImgsArr;
}

- (NSArray *)workIndexPathArr
{
    NSInteger offsetRow = 0;
    if (!TYIS_IPHONE_5_OR_LESS) {
        offsetRow = 1;
    }
    if (!_workIndexPathArr) {
        if (self.RecordWorkPointGuideModel.accountTypeCode == 1) {
            _workIndexPathArr = @[[NSIndexPath indexPathForRow:0 inSection:1],
                                  [NSIndexPath indexPathForRow:1 inSection:1],
                                  [NSIndexPath indexPathForRow:offsetRow inSection:2],
                                  [NSIndexPath indexPathForRow:1 +offsetRow  inSection:2],
                                  ];
        }else if(self.RecordWorkPointGuideModel.accountTypeCode == 2){
            _workIndexPathArr = @[[NSIndexPath indexPathForRow:0 inSection:1],
                                  [NSIndexPath indexPathForRow:1 inSection:2],
                                  [NSIndexPath indexPathForRow:2 inSection:2]
                                  ];
        }else if(self.RecordWorkPointGuideModel.accountTypeCode == 3){
            _workIndexPathArr = @[[NSIndexPath indexPathForRow:0 inSection:1],
                                  [NSIndexPath indexPathForRow:1 inSection:1]
                                  ];
        }

    }
    return _workIndexPathArr;
}

- (NSMutableArray *)workFramePathArr
{
    if (!_workFramePathArr) {
        _workFramePathArr = [[NSMutableArray alloc] init];
    }
    return _workFramePathArr;
}

- (NSMutableArray *)workCellArr
{
    if (!_workCellArr) {
        _workCellArr = [[NSMutableArray alloc] init];
    }
    return _workCellArr;
}

- (YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel
{
    if (!_RecordWorkPointGuideModel) {
        _RecordWorkPointGuideModel = [[YZGRecordWorkPointGuideModel alloc] init];
    }
    return _RecordWorkPointGuideModel;
}

@end

@implementation YZGRecordWorkPointGuideModel
@end
