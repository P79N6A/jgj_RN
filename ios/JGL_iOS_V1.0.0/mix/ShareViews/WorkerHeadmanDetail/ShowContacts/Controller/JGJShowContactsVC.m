//
//  JGJShowContactsVC.m
//  mix
//
//  Created by celion on 16/4/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//
#define HeaderH 27
#define Padding 12
#define RowH 80
#define ShowCount 10
#define kSectionIndexWidth 20.f
#define kSectionIndexHeight 450.f
#define OffsetY 75
#define IndexPadding 5
#import "JGJShowContactsVC.h"
#import "JGJContactsCell.h"
#import "MJExtension.h"
#import "NSString+Extend.h"
#import "TYPhone.h"
#import "DSectionIndexView.h"
#import "DSectionIndexItemView.h"
@interface JGJShowContactsVC ()<
UITableViewDataSource,
UITableViewDelegate,
DSectionIndexViewDataSource,
DSectionIndexViewDelegate
>

@property (nonatomic, strong) NSArray *contacts;//模型转换的联系人
@property (nonatomic, strong) NSMutableDictionary *sameFirstContactsDic;
@property (nonatomic, strong) NSArray *sortContacts ;//排序后的联系人
@property (nonatomic, strong) NSArray *contactsLetters;//包含首字母
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *centerShowLetter;
@property (nonatomic, assign) BOOL isShowCenterlable;
@property (strong, nonatomic) DSectionIndexView            *sectionIndexView;
@end

@implementation JGJShowContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortContacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SortFindResultModel *sortFindResult = self.sortContacts[section];
    return sortFindResult.findResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGJContactsCell" forIndexPath:indexPath];
    SortFindResultModel *sortFindResult = self.sortContacts[indexPath.section];
    FindResultModel *findResultModel = sortFindResult.findResult[indexPath.row];
    findResultModel.isHiddenIndexView = self.contactsLetters.count <= ShowCount; //小于 ShowCount个数不移位
    cell.findResultModel = findResultModel;
    cell.lineViewH.constant = (sortFindResult.findResult.count -1 - indexPath.row) == 0 ? 0 : 7;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    UILabel *firstLetterLable = [[UILabel alloc] init];
    firstLetterLable.backgroundColor = [UIColor clearColor];
    firstLetterLable.font = [UIFont systemFontOfSize:AppFont34Size];
    firstLetterLable.frame = CGRectMake(Padding, 0, TYGetViewW(self.view), HeaderH);
    SortFindResultModel *sortFindResult = self.sortContacts[section];
    firstLetterLable.text = sortFindResult.firstLetter.uppercaseString;
    firstLetterLable.textColor = AppFontccccccColor;
    [headerView addSubview:firstLetterLable];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderH;
}

//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.contactsLetters;
//}

- (void)scrollViewDidScroll:(UITableView *)tableView {
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    if (self.contactsLetters.count > 0) {
        JGJContactsCell *cell = tableView.visibleCells[0];
        self.centerShowLetter.text = cell.findResultModel.firstLetteter.uppercaseString;
        self.centerShowLetter.hidden = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.contactsLetters.count <= ShowCount) {
        self.centerShowLetter.hidden = YES;
        return;
    }
    self.centerShowLetter.hidden = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.centerShowLetter.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.centerShowLetter.hidden = !decelerate;
}


- (void)getContactsFirstletter:(NSArray *)contacts {
    NSMutableArray *sortContacts = [NSMutableArray array];
    NSMutableArray *allContacts = [NSMutableArray arrayWithArray:contacts];
    NSMutableArray *contactsLetters = [NSMutableArray array];
    for (FindResultModel *result in contacts) {
        result.firstLetteter = [NSString firstCharactor:result.friendname];
        [contactsLetters addObject:result.firstLetteter.lowercaseString];
    }
//    contactsLetters包含没有重复的字母
    NSSet *set = [NSSet setWithArray:contactsLetters];
    contactsLetters = [set allObjects].mutableCopy;
    contactsLetters = [NSMutableArray arrayWithArray: [contactsLetters sortedArrayUsingSelector:@selector(compare:)]];
    self.contactsLetters = contactsLetters;
//包含相同首字母的放在一起, 删除已经包含的数据,减少循环次数
    NSMutableDictionary *sameFirstContactsDic = [NSMutableDictionary dictionary];
    self.sameFirstContactsDic = sameFirstContactsDic;
    for (NSString *firstLetter in contactsLetters) {
        NSMutableArray *sameFirstContacts = [NSMutableArray array];
        for (int i = 0; i < allContacts.count; i ++) {
            FindResultModel *result = allContacts[i];
            if ([result.firstLetteter.lowercaseString isEqualToString: firstLetter.lowercaseString]) {
                [sameFirstContacts addObject:result];
//                [allContacts removeObject:result];//在这里可以减少循环次数,但是删除了相同数据
            }
        }
        NSDictionary *contactDic = @{@"firstLetter" : firstLetter,
                                     @"findResult" : sameFirstContacts};
        [sortContacts addObject:contactDic];
        }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES]];
    [sortContacts sortUsingDescriptors:sortDescriptors];
    self.sortContacts = [SortFindResultModel mj_objectArrayWithKeyValuesArray:sortContacts];
}

- (void)commonSet {
    if (TYIS_IPHONE_4_OR_LESS) {
         self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.centerShowLetter];
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = AppFontf1f1f1Color;
//    self.tableView.sectionIndexColor = AppFont999999Color;   //可以改变字体的颜色
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];  //可以改变索引背景色
    if ([self.jlgFHLeaderDetailModel.findresult isKindOfClass:[NSDictionary class]]) {
        self.contacts = [FindResultModel mj_objectArrayWithKeyValuesArray:self.jlgFHLeaderDetailModel.findresult];
    } else {
        self.contacts = self.jlgFHLeaderDetailModel.contacts;
    }
    NSInteger contactsCount = self.contacts.count;
    NSString *title = nil;
    if (contactsCount > 0) {
        title = [NSString stringWithFormat:@"你有%ld个朋友认识他", self.contacts.count];
    } else {
        title = @"暂没有朋友认识他";
    }
    self.title = title;
    [TYLoadingHub showLoadingWithMessage:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getContactsFirstletter:self.contacts];
        if (self.contactsLetters.count > 0) {
            self.centerShowLetter.text =  self.contactsLetters[0];
            self.tableView.hidden = NO;
            self.centerShowLetter.hidden =  YES;
            [self.tableView reloadData];
        }
        [TYLoadingHub hideLoadingView];
    });
}

- (UILabel *)centerShowLetter {
    if (!_centerShowLetter) {
        
        _centerShowLetter = [[UILabel alloc] init];
        _centerShowLetter.textColor = [UIColor whiteColor];
        _centerShowLetter.textAlignment = NSTextAlignmentCenter;
        _centerShowLetter.font = [UIFont systemFontOfSize:30];
        _centerShowLetter.frame = CGRectMake(0, 0, 55, 55);
        _centerShowLetter.center = self.view.center;
        _centerShowLetter.clipsToBounds = YES;
        _centerShowLetter.layer.cornerRadius = TYGetViewW(_centerShowLetter)  / 2;
        _centerShowLetter.backgroundColor = AppFontd7252cColor;
        _centerShowLetter.hidden = YES;
    }
    return _centerShowLetter;
}

#pragma mark DSectionIndexViewDataSource && delegate method
- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView
{
    return self.contactsLetters.count;
}

- (void)setContactsLetters:(NSArray *)contactsLetters {
    _contactsLetters = contactsLetters;
    if (_contactsLetters.count > ShowCount) {
        if (!self.sectionIndexView) {
            [self creatTableIndexView];
        }
        BOOL isShow = _contactsLetters.count  > ShowCount? NO:YES; //搜索时隐藏所以
        self.sectionIndexView.hidden = isShow;
        [self.sectionIndexView reloadItemViews];
    }else {
        
        self.sectionIndexView.hidden = YES;
    }
}

#pragma Mark - 创建右边索引
- (void)creatTableIndexView {
    
    _sectionIndexView = [[DSectionIndexView alloc] init];
    _sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tableView.frame) - kSectionIndexWidth - IndexPadding, OffsetY, kSectionIndexWidth, TYGetUIScreenHeight - OffsetY * 3);
    [_sectionIndexView setBackgroundViewFrame];
    _sectionIndexView.backgroundColor = [UIColor whiteColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.isShowCallout = NO;
    _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    [self.view addSubview:self.sectionIndexView];
}

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    DSectionIndexItemView *itemView = [[DSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [self.contactsLetters objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:12];
    itemView.titleLabel.textColor = AppFont999999Color;
    itemView.titleLabel.highlightedTextColor = AppFontd7252cColor;
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.contactsLetters objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    return label;
}

- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return [self.contactsLetters objectAtIndex:section];
}

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    __weak typeof(self) weakSelf  = self;
    self.centerShowLetter.text = self.contactsLetters[section];
    self.centerShowLetter.hidden = NO;
    sectionIndexView.touchCancelBlock = ^(DSectionIndexView *sectionIndexView, BOOL isTouchCancel){
        //        延时的目的是当touch停止的时候还会滚动一小段时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.centerShowLetter.hidden = isTouchCancel;
        });
    };
}

@end
