//
//  JGJSynRecordParentVc.m
//  mix
//
//  Created by yj on 2018/12/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJSynRecordParentVc.h"

#import "JGJSynRecordVc.h"

#import "JGJSynToMyProVc.h"

#import "JGJCommonButton.h"

#import "JGSelSynTypeVc.h"

@interface JGJSynRecordParentVc ()

@end

@implementation JGJSynRecordParentVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"同步记工";
    
    self.titleScrollViewX = TYGetUIScreenWidth <= 320 ? 28 : 40;
    
    if (TYIS_IPHONE_6P) {
        
        self.titleScrollViewX = 50;
    }
    
    self.arrowIcon = @"up_real_arrow";
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    CGFloat titleHeight = 45;
    
    //这里不需要再次进入居中显示，消除滑动页面标题抖动
    
    self.is_un_title_center = YES;
    
    self.selectIndex = self.synType;
    
    // 推荐方式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight,CGFloat *titleWidth) {
        
        // 设置标题字体
        *titleFont = [UIFont systemFontOfSize:AppFont30Size];
        
        *titleScrollViewColor = AppFontfafafaColor;
        
        *norColor = AppFont333333Color;
        
        *selColor = AppFontEB4E4EColor;
        
        *titleHeight = 45;
        
    }];
    
    self.selTitleFont = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    self.norTitleFont = [UIFont systemFontOfSize:AppFont30Size];
    
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        
        // 标题填充模式
        *underLineColor = AppFontEB4E4EColor;
        
        *underLineH = 3;
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollIndex:)
                                                 name:@"YZDisplayViewClickOrScrollDidFinshNote"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollRepeatClickIndex:)
                                                 name:@"YZDisplayViewRepeatClickTitleNote"
                                               object:nil];
    
    UIView *titleBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHeight - 1, TYGetUIScreenWidth, 1)];
    
    titleBottomLineView.backgroundColor = AppFontdbdbdbColor;
    
    [self.titleScrollView addSubview:titleBottomLineView];
    
    
    UIView *titleCenterLineView = [[UIView alloc] initWithFrame:CGRectMake((TYGetUIScreenWidth - 1) / 2.0, 0, 1, titleHeight)];
    
    titleCenterLineView.backgroundColor = AppFontdbdbdbColor;
    
    [self.titleScrollView addSubview:titleCenterLineView];
    
    self.view.backgroundColor = AppFontf1f1f1Color;
}

- (void)setUpAllViewController {
    
    [self setUpContentViewFrame:^(UIView *contentView) {
        
        contentView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 45);
        
    }];
    
    JGJSynToMyProVc *synToMyProVc = [[JGJSynToMyProVc alloc] init];
    
    synToMyProVc.title = @"同步给我的记工";
    
    [self addChildViewController:synToMyProVc];
    
    
    JGJSynRecordVc *synRecordVc = [[JGJSynRecordVc alloc] init];
    
    synRecordVc.title = @"同步记工";
    
    [self addChildViewController:synRecordVc];
    
}

- (void)scrollIndex:(NSNotification *)note {
    
    TYLog(@"scrollIndex----%@", note.object);
    
    if ([note.object isMemberOfClass:[JGJSynToMyProVc class]]) {
        
        JGJSynToMyProVc *synRecordVc = self.childViewControllers[0];
        
        synRecordVc.isDelStatus = NO;
        
        NSString *title = @"删除";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(editItemPressed:)];
        
    }else if ([note.object isMemberOfClass:[JGJSynRecordVc class]]) {
        
        [self setSynedRightItem];
        
    }
    
}

- (void)setSynedRightItem {
    
    JGJCommonButton *rightItemBtn = [[JGJCommonButton alloc] init];
    
    rightItemBtn.buttonTitle = @"新增同步";
    
    rightItemBtn.type = JGJCommonCreatProType;
    
    [rightItemBtn addTarget:self action:@selector(addSynItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    
}

- (void)addSynItemPressed {
    
    JGSelSynTypeVc *synTypeVc = [[JGSelSynTypeVc alloc] init];
    
    [self.navigationController pushViewController:synTypeVc animated:YES];
    
    TYWeakSelf(self);
    
    synTypeVc.synSuccessBlock = ^(NSDictionary *res) {
        
        JGJSynRecordVc *synRecordVc = self.childViewControllers[1];
        
        if ([synRecordVc isMemberOfClass:[JGJSynRecordVc class]]) {
            
            [synRecordVc freshTable];
            
            [weakself.navigationController popToViewController:weakself animated:YES];
        }
        
    };
    
}

- (void)editItemPressed:(UIBarButtonItem *)item {
    
    JGJSynToMyProVc *synRecordVc = self.childViewControllers[0];
    
    if ([synRecordVc isMemberOfClass:[JGJSynToMyProVc class]]) {
        
        synRecordVc.isDelStatus = !synRecordVc.isDelStatus;
        
        self.navigationItem.rightBarButtonItem.title = synRecordVc.isDelStatus ? @"取消" : @"删除";
        
    }
    
}

- (void)scrollRepeatClickIndex:(NSNotification *)note  {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
