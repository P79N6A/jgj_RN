//
//  MultipleChoiceTableView.m
//  MultipleChoiceTableView
//
//  Created by fujin on 15/7/9.
//  Copyright (c) 2015年 fujin. All rights reserved.
//

#import "MultipleChoiceTableView.h"

@interface MultipleChoiceTableView ()

@property (nonatomic,assign) BOOL isAutoLayout;

@end

@implementation MultipleChoiceTableView
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)contentArray
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
        [self.dataArray addObjectsFromArray:contentArray];
        
        self.frame = frame;
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);

        self.tableView.frame = self.bounds;
        self.tableView.bounces = NO;
        self.tableView.scrollsToTop = YES;
        self.tableView.pagingEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)contentArray inView:(UIView *)superView
{
    self = [super init];
    if (self) {
        self.isAutoLayout = YES;
        self.dataArray = [[NSMutableArray alloc] init];
        [self.dataArray addObjectsFromArray:contentArray];

        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left);
            make.top.equalTo(superView.mas_top).offset(frame.origin.y);
            make.width.mas_equalTo(frame.size.width);
            make.height.mas_equalTo(frame.size.height - JGJ_IphoneX_BarHeight);
        }];
        self.tableView = [[UITableView alloc] init];
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.tableView.frame = self.bounds;
        self.tableView.bounces = NO;
        self.tableView.scrollsToTop = YES;
        self.tableView.pagingEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(self.mas_height);
            make.height.equalTo(self.mas_width);
        }];
                
        if (@available(iOS 11.0,*))  {
            
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
    }
    return self;
}

- (void)updateHeight:(CGFloat)height{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    [self layoutIfNeeded];
    [self.tableView layoutIfNeeded];
}

#pragma mark - 更新是否能够滑动的状态
- (void)updateScrollEnabled:(BOOL)enable{
    
    self.tableView.scrollEnabled = enable;
}

#pragma mark --- tableView datasouce and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MultipleChoiceTableViewCell"];
    
    UIViewController *vc = [_dataArray objectAtIndex:indexPath.row];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MultipleChoiceTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    [cell.contentView addSubview:vc.view];
    
    if (self.isAutoLayout) {
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(cell);
        }];
    }else{
        vc.view.frame = cell.bounds;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.width;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [_dataArray objectAtIndex:indexPath.row];
    [vc viewWillAppear:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [_dataArray objectAtIndex:indexPath.row];
    [vc viewWillDisappear:YES];
}

#pragma mark --- scrollView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.delegate &&[self.delegate respondsToSelector:@selector(scrollChangeToIndex:)]) {
//        int index = scrollView.contentOffset.y / self.frame.size.width + 0.5;
//        [self.delegate scrollChangeToIndex:index + 1];
//    }
//
//}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(scrollEndChangeToIndex:)]) {
        int index = scrollView.contentOffset.y / self.frame.size.width + 0.5;
        [self.delegate scrollEndChangeToIndex:index + 1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(scrollEndChangeToIndex:)]) {
        int index = scrollView.contentOffset.y / self.frame.size.width + 0.5;
        [self.delegate scrollEndChangeToIndex:index + 1];
    }
    
    //为了解决3个tableview滑动的bug，放到这里，就会出现滑动结束了，segmentView才变化的情况
    if (self.delegate &&[self.delegate respondsToSelector:@selector(scrollChangeToIndex:)]) {
        int index = scrollView.contentOffset.y / self.frame.size.width + 0.5;
        [self.delegate scrollChangeToIndex:index + 1];
    }
}

#pragma mark --- select onesIndex
-(void)selectIndex:(NSInteger)index
{
//    [UIView animateWithDuration:0.3 animations:^{
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
//    }];
}

@end
