//
//  YZGWageBestDetailTableView.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageBestDetailTableView.h"
#import "YZGWageBestDetailModel.h"
#import "YZGWageMoreDetailModel.h"
#import "UITableView+TYSeparatorLine.h"

@interface YZGWageBestDetailTableView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation YZGWageBestDetailTableView
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
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [UITableView tableViewSetWithTableView:self.tableView];
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return wageBestDetailCellHegith;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myID = @"YZGWageBestDetailTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:myID];

        cell.textLabel.minimumScaleFactor = 0.5;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WageBestDetailPro_List *wageBestDetailPro_List = self.dateArray[indexPath.row];
    
    cell.textLabel.text = wageBestDetailPro_List.pro_name;
    if (self.wageMoreDetailValues.pid == wageBestDetailPro_List.pid) {
        cell.textLabel.textColor = JGJMainColor;
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.textLabel.textColor = TYColorHex(0x878787);
        cell.backgroundColor = JGJMainBackColor;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(YZGWageBestDetailTableViewSelected:index:)]) {
        [self.delegate YZGWageBestDetailTableViewSelected:self index:indexPath.row];
    }
}

//分割线偏移
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
