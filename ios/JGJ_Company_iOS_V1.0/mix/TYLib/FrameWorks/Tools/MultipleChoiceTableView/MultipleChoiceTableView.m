//
//  MultipleChoiceTableView.m
//  MultipleChoiceTableView
//
//  Created by fujin on 15/7/9.
//  Copyright (c) 2015年 fujin. All rights reserved.
//

#import "MultipleChoiceTableView.h"

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

#pragma mark - 更新是否能够滑动的状态
- (void)updateScrollEnabled{
    self.tableView.scrollEnabled = JLGLoginBool;//登录了就能滑动，没有登录不能
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
    
    vc.view.frame = cell.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.width;
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
