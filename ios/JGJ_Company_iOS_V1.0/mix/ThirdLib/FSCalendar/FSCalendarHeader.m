//
//  FSCalendarHeader.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "FSCalendarHeader.h"
#import "FSCalendarCollectionView.h"
#import "FSCalendarDynamicHeader.h"

@interface FSCalendarHeader ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;

@end

@implementation FSCalendarHeader

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollEnabled = YES;
    _needsAdjustingMonthPosition = YES;
    _needsAdjustingViewFrame = YES;
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewFlowLayout.minimumInteritemSpacing = 0;
    collectionViewFlowLayout.minimumLineSpacing = 0;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsZero;
    collectionViewFlowLayout.itemSize = CGSizeMake(1, 1);
    self.collectionViewFlowLayout = collectionViewFlowLayout;
    
    FSCalendarCollectionView *collectionView = [[FSCalendarCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    collectionView.scrollEnabled = NO;
    collectionView.userInteractionEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
//   [TYNotificationCenter addObserver:self selector:@selector(reciveNotification:) name:@"calendarHeadarSelect" object:nil];
    //使用不同的头部样式
    
if (_calendar.scope == FSCalendarScopeMonth  ) {
    if (_leftAndRightShow) {
    [collectionView registerClass:[FSLeftCalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];

    }else{
    [collectionView registerClass:[FSCalendarHeaderCell class]
       forCellWithReuseIdentifier:@"cell"];
    }
    }else{
    [collectionView registerClass:[FSCalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];
    }
    self.collectionView = collectionView;
    

}
//-(void)reciveNotification:(NSNotification *)obj
//{
//    if ([self.delegate respondsToSelector:@selector(FSCalendarHeaderLeftandRIGHTSelected:)]) {
//        [self.delegate FSCalendarHeaderLeftandRIGHTSelected:[obj.object intValue]];
//    }
//    
//    
//}

-(void)setLeftAndRightShow:(BOOL)leftAndRightShow
{
    _leftAndRightShow = leftAndRightShow;
    if (leftAndRightShow) {
        [_collectionView registerClass:[FSLeftCalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];
    }else{
        [_collectionView registerClass:[FSCalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];
    }
    [self.collectionView reloadData];



}
//Tony修改过的地方
- (void)setNeedSelectedTime:(BOOL)needSelectedTime{
    _needSelectedTime = needSelectedTime;
    
    [self.collectionView reloadData];
}
-(void)setNeedshowArrow:(BOOL)needshowArrow
{

    _needshowArrow = needshowArrow;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needsAdjustingViewFrame) {
        _needsAdjustingViewFrame = NO;
        _collectionView.frame = CGRectMake(0, self.fs_height*0.1, self.fs_width, self.fs_height*0.9);
        _collectionViewFlowLayout.itemSize = CGSizeMake(
                                                        _collectionView.fs_width*((_scrollDirection==UICollectionViewScrollDirectionHorizontal)?0.5:1),
                                                        _collectionView.fs_height
                                                       );
    }
    
    if (_needsAdjustingMonthPosition) {
        _needsAdjustingMonthPosition = NO;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            [_collectionView setContentOffset:CGPointMake((_scrollOffset+0.5)*_collectionViewFlowLayout.itemSize.width, 0) animated:NO];
        } else {
            [_collectionView setContentOffset:CGPointMake(0, _scrollOffset * _collectionViewFlowLayout.itemSize.height) animated:NO];
        }
    };
    
}

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.calendar.scope) {
        case FSCalendarScopeMonth: {
            switch (_scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    NSDate *minimumPage = [_calendar beginingOfMonthOfDate:_calendar.minimumDate];
                    NSInteger count = [_calendar monthsFromDate:minimumPage toDate:_calendar.maximumDate] + 1;
                    return count;
                }
                case UICollectionViewScrollDirectionHorizontal: {
                    // 这里需要默认多出两项，否则当contentOffset为负时，切换到其他页面时会自动归零
                    // 2 more pages to prevent scrollView from auto bouncing while push/present to other UIViewController
                    NSDate *minimumPage = [_calendar beginingOfMonthOfDate:_calendar.minimumDate];
                    NSInteger count = [_calendar monthsFromDate:minimumPage toDate:_calendar.maximumDate] + 1;
                    return count + 2;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case FSCalendarScopeWeek: {
            NSDate *minimumPage = [_calendar beginingOfMonthOfDate:_calendar.minimumDate];
            NSInteger count = [_calendar weeksFromDate:minimumPage toDate:_calendar.maximumDate] + 1;
            return count + 2;
        }
        default: {
            break;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSCalendarHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.header = self;
    
    cell.needSelectedTime = self.needSelectedTime;
    cell.titleLabel.textColor = _appearance.headerTitleColor;
#pragma mark - 刘远强临时添加写死日历顶部的大小
    if (_calendar.scope ==  FSCalendarScopeWeek) {
        cell.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    }else{
        cell.titleLabel.font = _appearance.preferredHeaderTitleFont;

    }
    _calendar.formatter.dateFormat = _appearance.headerDateFormat;

    BOOL usesUpperCase = (_appearance.caseOptions & 15) == FSCalendarCaseOptionsHeaderUsesUpperCase;
    NSString *text = nil;
    switch (self.calendar.scope) {
        case FSCalendarScopeMonth: {
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                // 多出的两项需要制空
                if ((indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:0] - 1)) {
                    text = nil;
                } else {
                    NSDate *date = [_calendar dateByAddingMonths:indexPath.item-1 toDate:_calendar.minimumDate];
                    text = [_calendar.formatter stringFromDate:date];
                }
            } else {
                NSDate *date = [_calendar dateByAddingMonths:indexPath.item toDate:_calendar.minimumDate];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        case FSCalendarScopeWeek: {
            if ((indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:0] - 1)) {
                text = nil;
            } else {
                NSDate *firstPage = [_calendar middleOfWeekFromDate:_calendar.minimumDate];
                NSDate *date = [_calendar dateByAddingWeeks:indexPath.item-1 toDate:firstPage];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        default: {
            break;
        }
    }
    text = usesUpperCase ? text.uppercaseString : text;
    cell.titleLabel.text = text;
    [cell setNeedsLayout];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(FSCalendarHeaderSelected:)]) {
        [self.delegate FSCalendarHeaderSelected:self];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
}
#pragma mark - Properties
- (void)setCalendar:(FSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _appearance  = calendar.appearance;
    }
}
- (void)setScrollOffset:(CGFloat)scrollOffset
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
    }
    _needsAdjustingMonthPosition = YES;
    [self setNeedsLayout];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        _collectionViewFlowLayout.scrollDirection = scrollDirection;
        _needsAdjustingMonthPosition = YES;
        _needsAdjustingViewFrame = YES;
        [self setNeedsLayout];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (_scrollEnabled != scrollEnabled) {
        _scrollEnabled = scrollEnabled;
        [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

#pragma mark - Public

- (void)reloadData
{
    [_collectionView reloadData];
}

@end


@implementation FSCalendarHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];

        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
        titleLabel.textColor = AppFont333333Color;
        [self.contentView addSubview:titleLabel];
        
        UIImage *selectedImage = [UIImage imageNamed:@"calendarDown.jpg"];
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:selectedImage];
        
        [self.contentView addSubview:selectedImageView];
        self.selectedImageView = selectedImageView;
     
//        //添加左边的选择按钮
//        UIImage *LselectedImage = [UIImage imageNamed:@"RecordWorkpoints_down"];
//        UIImageView *lselectedImageView = [[UIImageView alloc] initWithImage:LselectedImage];
//        lselectedImageView.tag = 110;
//        [self.contentView addSubview:lselectedImageView];
//        self.LeftselectedImageView = lselectedImageView;
//        //
        
        self.titleLabel = titleLabel;
        self.titleLabel.textColor = AppFont333333Color;
        
        
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame )- 0.5, TYGetUIScreenWidth, 0.5)];
//        lable.backgroundColor = AppFontdbdbdbColor;
//        [self.contentView addSubview:lable];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];

    //Tony修改过的地方
    [self setTitleViewFrame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setTitleViewFrame];
    if (self.header.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].x;
        CGFloat center = CGRectGetMidX(self.header.bounds);
        if (self.header.scrollEnabled) {
            self.contentView.alpha = 1.0 - (1.0-self.header.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_width;
        } else {
            self.contentView.alpha = (position > 0 && position < self.header.fs_width*0.75);
        }
    } else if (self.header.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].y;
        CGFloat center = CGRectGetMidY(self.header.bounds);
        self.contentView.alpha = 1.0 - (1.0-self.header.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_height;
    }
    
}

- (void)invalidateHeaderFont
{
    _titleLabel.font = self.header.appearance.headerTitleFont;
}

- (void)invalidateHeaderTextColor
{
    _titleLabel.textColor = self.header.appearance.headerTitleColor;
}

- (void)setTitleViewFrame{
    CGSize size = [_titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font,NSFontAttributeName, nil]];
    
    self.titleLabel.frame = CGRectMake(0, 0, size.width,self.bounds.size.height);
    self.titleLabel.center = self.contentView.center;
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.contentView.frame), CGRectGetMidY(self.contentView.frame)-4);
    self.titleLabel.textColor = AppFont333333Color;

    
    
    self.selectedImageView.hidden = !self.needSelectedTime;
    if (self.needSelectedTime) {
//        CGFloat selectedImageW = size.width/7;
        CGFloat selectedImageW = 12;

//        CGFloat selectedImageH = selectedImageW*13/24;
        CGFloat selectedImageH = 7;
        CGFloat selectedImageY = (TYGetViewH(self.titleLabel) - selectedImageH)/2;
        self.selectedImageView.frame = CGRectMake(TYGetMaxX(self.titleLabel), selectedImageY -3, selectedImageW,selectedImageH);
//        self.selectedImageView.frame = CGRectMake(TYGetMaxX(self.titleLabel)+5, selectedImageY, selectedImageW,selectedImageH);

        
        //添加日历的左右选择新样式 2017-3-7
//        CGFloat LselectedImageW = size.width/7;
//        CGFloat LselectedImageH = selectedImageW*13/24;
//        CGFloat LselectedImageY = (TYGetViewH(self.titleLabel) - selectedImageH)/2;
//        self.LeftselectedImageView.frame = CGRectMake(TYGetMinX(self.titleLabel)-5-LselectedImageW, LselectedImageY, LselectedImageW,LselectedImageH);
        
    }
}

@end



#pragma mark - 刘远强添加了左右剪头选择日历时间的布局样式
@implementation FSLeftCalendarHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        UIImage *selectedImage = [UIImage imageNamed:@"left--arrows"];
        UIImageView *selectedImageView = [[UIImageView alloc]initWithImage:selectedImage]; ;
        selectedImageView.tag = 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadar:)];
        [selectedImageView addGestureRecognizer:tap];
        selectedImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:selectedImageView];
        self.selectedImageView = selectedImageView;
        //添加左边的选择按钮
        UIImage *LselectedImage = [UIImage imageNamed:@"right--arrows"];
        UIImageView *lselectedImageView = [[UIImageView alloc]initWithImage:LselectedImage]; ;
        lselectedImageView.tag = 110;
        UITapGestureRecognizer *Ltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadar:)];
        [lselectedImageView addGestureRecognizer:Ltap];
       lselectedImageView.userInteractionEnabled = YES;

        [self.contentView addSubview:lselectedImageView];
        self.rightSelectedImageView = lselectedImageView;
        
        self.calLeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth / 2 - 120, 0, 68, 30)];
        [self.calLeftBtn addTarget:self action:@selector(clickCalenderArrow:) forControlEvents:UIControlEventTouchUpInside];
        self.calLeftBtn.tag = 110;
        [self.contentView addSubview:self.calLeftBtn];
        
        self.calRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth / 2 + 53, 0, 68, 30)];
        self.calRightBtn.tag = 100;
        [self.calRightBtn addTarget:self action:@selector(clickCalenderArrow:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.calRightBtn];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame )- 0.5, TYGetUIScreenWidth, 0.5)];
        lable.backgroundColor = AppFontdbdbdbColor;
        lable.text = @"";
        [self.contentView addSubview:lable];
        
        self.titleLabel = titleLabel;
        
        

    }
    return self;
}
-(void)clickCalenderArrow:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    [TYNotificationCenter postNotificationName:@"calendarHeadarSelect" object:[NSString stringWithFormat:@"%ld",(long)button.tag]];
    
}
//-(void)dealloc
//{
//    
//    
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self setTitleViewFrame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setTitleViewFrame];
    if (self.header.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].x;
        CGFloat center = CGRectGetMidX(self.header.bounds);
        if (self.header.scrollEnabled) {
            self.contentView.alpha = 1.0 - (1.0-self.header.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_width;
        } else {
            self.contentView.alpha = (position > 0 && position < self.header.fs_width*0.75);
        }
    } else if (self.header.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].y;
        CGFloat center = CGRectGetMidY(self.header.bounds);
        self.contentView.alpha = 1.0 - (1.0-self.header.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.fs_height;
    }
    
    
    
}

- (void)invalidateHeaderFont
{
    _titleLabel.font = self.header.appearance.headerTitleFont;
}
-(void)invalirightSelectimagHidden:(BOOL)hidden
{
    self.selectedImageView.hidden = hidden;

}
- (void)invalidateHeaderTextColor
{
    _titleLabel.textColor = self.header.appearance.headerTitleColor;
}

- (void)setTitleViewFrame{
    // 根据字体得到NSString的尺寸
    self.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];

    CGSize size = [_titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font,NSFontAttributeName, nil]];
    
    self.titleLabel.frame = CGRectMake(0, 0, size.width,self.bounds.size.height);
//  self.titleLabel.center = self.contentView.center;
//    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 2);
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.frame), self.contentView.center.y + 2);

    self.titleLabel.textColor = AppFont333333Color;
    self.selectedImageView.hidden = !self.needSelectedTime;
    if (self.needSelectedTime) {
        CGFloat selectedImageW = 7;
        CGFloat selectedImageH = 12;
//        self.selectedImageView.frame = CGRectMake(TYGetMaxX(self.titleLabel)+5 +5, self.titleLabel.frame.origin.y + 6.5, selectedImageW,selectedImageH);

        self.selectedImageView.frame = CGRectMake(TYGetMaxX(self.titleLabel)+5 +5, self.bounds.size.height/2 - 4, selectedImageW,selectedImageH);
        CGFloat LselectedImageW  = 7;
        CGFloat LselectedImageH = 12;
//        self.LeftselectedImageView.frame = CGRectMake(TYGetMinX(self.titleLabel)-5-LselectedImageW -5, self.titleLabel.frame.origin.y +6.5, LselectedImageW,LselectedImageH);
        self.rightSelectedImageView.frame = CGRectMake(TYGetMinX(self.titleLabel)-5-LselectedImageW -5, self.bounds.size.height/2 - 4, LselectedImageW,LselectedImageH);

        NSString *year =[NSString stringWithFormat:@"%ld", (long)[JGJTime GetyearFromStamp:[NSDate date]]] ;
        NSString *month =[NSString stringWithFormat:@"%ld", (long)[JGJTime GetMonthFromStamp:[NSDate date]]];
        NSString *str;
        if ([month intValue]<10) {
        str = [NSString stringWithFormat:@"%@年0%@月",year,month];
        }else{
        str = [NSString stringWithFormat:@"%@年%@月",year,month];
        }
        if ([_titleLabel.text isEqualToString:str]) {
            self.selectedImageView.hidden = YES;
        }else{
            self.selectedImageView.hidden = NO;
        }

    }
}

@end


@implementation FSCalendarHeaderTouchDeliver

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return _calendar.collectionView ?: hitView;
    }
    return hitView;
}

@end


