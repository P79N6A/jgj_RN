//
//  JGJWebMsgsViewController.m
//  mix
//
//  Created by Tony on 16/4/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWebMsgsViewController.h"
#import "SegmentTapView.h"
#import "MultipleChoiceTableView.h"
#import "JGJWebAllSubViewController.h"

static CGFloat const JGJSegmentTapViewY = 0;
static CGFloat const JGJSegmentTapViewH = 0;

@interface JGJWebMsgsViewController ()
<
    SegmentTapViewDelegate,
    MultipleChoiceTableViewDelegate
>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *controllsArray;
@property (nonatomic, strong) SegmentTapView *segmentTapView;
@property (nonatomic, strong) MultipleChoiceTableView *mulChoiceView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@end

@implementation JGJWebMsgsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSegment];
    [self MultipleChoiceTableView];
    [self initLeftButtonItem];
    [self.navigationController setValue:@NO forKey:@"shouldPopItemAfterPopViewController"];
}


- (void)initLeftButtonItem{
    SEL selector = NSSelectorFromString(@"getLeftBarButton");
    IMP imp = [self.navigationController methodForSelector:selector];
    UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
    UIBarButtonItem *leftBarButtonItem = func(self.navigationController, selector);
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)initSegment{
    CGRect segmentFrame = CGRectMake(0, JGJSegmentTapViewY, TYGetUIScreenWidth, JGJSegmentTapViewH) ;
    
    self.segmentTapView = [[SegmentTapView alloc] initWithFrame:segmentFrame withDataArray:[NSArray arrayWithObjects:@"收藏",@"评论",@"回复", nil] withFont:15];

    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"收藏",@"评论",@"回复"]];
    self.segmentControl = segmentControl;
    segmentControl.frame =CGRectMake(0, 0, 197, 29);
    [segmentControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    segmentControl.tintColor = AppFontd7252cColor;
    [segmentControl setTitleTextAttributes:@{@"UITextAttributeFont" :  [UIFont systemFontOfSize:AppFont30Size]} forState:UIControlStateNormal];
    segmentControl.selectedSegmentIndex = 0;
    self.selectedIndex = segmentControl.selectedSegmentIndex;
    self.navigationItem.titleView = segmentControl;
    self.segmentTapView.delegate = self;

}

-(void)MultipleChoiceTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }
    
    JGJWebAllSubViewController *collectionMsgWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeCollectionMsg];
    
    JGJWebAllSubViewController *commentMsgWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeCommentMsg];
    
    JGJWebAllSubViewController *receiveMsgWebView = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeReceiveMsg];
    
    [self.controllsArray addObject:collectionMsgWebView];
    [self.controllsArray addObject:commentMsgWebView];
    [self.controllsArray addObject:receiveMsgWebView];
    
    self.selectedIndex = 0;
    CGFloat mulChoiceY = JGJSegmentTapViewY + JGJSegmentTapViewH;
    self.mulChoiceView = [[MultipleChoiceTableView alloc] initWithFrame:CGRectMake(0, mulChoiceY, TYGetUIScreenWidth, TYGetUIScreenHeight - (mulChoiceY + 40)) withArray:_controllsArray];
    
    self.mulChoiceView.delegate = self;
    [self.view addSubview:self.mulChoiceView];
}

#pragma mark - delegate
- (void)scrollChangeToIndex:(NSInteger)index{
    [self.segmentTapView selectIndex:index];
    self.selectedIndex = index - 1;
    self.segmentControl.selectedSegmentIndex = index - 1;
}

-(void)selectedIndex:(NSInteger)index{
    [self.mulChoiceView selectIndex:index];
    self.selectedIndex = index;
}

- (void)segmentChange:(UISegmentedControl *)segment {
     [self.mulChoiceView selectIndex:segment.selectedSegmentIndex];
    self.selectedIndex = segment.selectedSegmentIndex;
}

- (void)dealloc{
    self.mulChoiceView = nil;
    self.controllsArray = nil;
    self.segmentTapView.delegate = nil;
    self.mulChoiceView.delegate = nil;
}

- (JGJBaseWebViewController *)getSubWebVc{
    JGJBaseWebViewController *webSubVc = (JGJBaseWebViewController *)self.controllsArray[self.selectedIndex];
    return webSubVc;
}

@end
