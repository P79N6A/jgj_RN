//
//  JLGCitysListView.m
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGCitysListView.h"
#import "UITableViewCell+Extend.h"

@interface JLGCitysListView ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JLGCitysListView

- (void)tableViewReloadData{
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray <JLGCitysListModel *>*)dataArr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.dataArr = dataArr;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
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
}

- (void)setWorktypeArr:(NSArray<NSDictionary *> *)worktypeArr{
    _worktypeArr = worktypeArr;
    [self setTopTitleString:worktypeArr];
}

- (void)setTopTitleString:(NSArray *)workTypeArr{
    //设置上面的标题
    NSMutableArray *workTypeNameArray = [[NSMutableArray alloc] init];
    [workTypeArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [workTypeNameArray addObject:obj[@"name"]];
    }];
    
    NSString *workTypeString = [workTypeNameArray componentsJoinedByString:@","];
    NSString *topTileString = workTypeArr.count != 0?[NSString stringWithFormat:@"该城市暂无%@的招工信息,去其他城市看看吧!",workTypeString]:@"该城市暂无招工信息,去其他城市看看吧!";

    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:topTileString];
    
    [contentStr addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:NSMakeRange(0, topTileString.length)];
    if (workTypeArr.count != 0) {
        //数字需要黄色
        [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(5, workTypeString.length)];
    }

    
    self.topTitleLabel.attributedText = contentStr;
    self.topTitleLabel.minimumScaleFactor = 0.5;
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLGCitysListTableViewCell *cell = [JLGCitysListTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.citysModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JLGCitysListModel *city = self.dataArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCity:cityName:)]) {
        [self.delegate selectedCity:[NSString stringWithFormat:@"%@",@(city.city_code)] cityName:city.shortname[1]];
    }
    
    [self hidden];
}

- (void)showInView:(UIViewController *)Vc{
    if (self) {
        [Vc.view addSubview:self];
    }
}

- (void)hidden{
    if (self) {
        [self removeFromSuperview];
    }
}
@end
