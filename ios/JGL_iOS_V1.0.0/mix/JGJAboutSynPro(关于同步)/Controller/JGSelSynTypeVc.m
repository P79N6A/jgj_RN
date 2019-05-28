//
//  JGSelSynTypeVc.m
//  mix
//
//  Created by yj on 2018/5/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGSelSynTypeVc.h"

#import "JGJSelSynTypeView.h"

#import "JGJAddSynInfoVc.h"

@interface JGSelSynTypeVc () <JGJSelSynTypeViewDelegate>

@property (nonatomic, strong) JGJSelSynTypeView *synTypeView;

@end

@implementation JGSelSynTypeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择同步类型";
    
    self.view = self.synTypeView;
    
    self.synTypeView.delegate = self;
}

#pragma mark - 选择同步类型
- (void)selSynTypeView:(JGJSelSynTypeView *)typeView syncType:(JGJSyncType)syncType {
    
    JGJAddSynInfoVc *synInfoVc = [[JGJAddSynInfoVc alloc] init];
    
    synInfoVc.syncType = syncType;
    
    synInfoVc.synSuccessBlock = self.synSuccessBlock;
    
    [self.navigationController pushViewController:synInfoVc animated:YES];
    
    
}

- (JGJSelSynTypeView *)synTypeView {
    
    if (!_synTypeView) {
        
        _synTypeView = [[JGJSelSynTypeView alloc] initWithFrame:TYGetUIScreenMain.bounds];
        
    }
    
    return _synTypeView;
}

@end
