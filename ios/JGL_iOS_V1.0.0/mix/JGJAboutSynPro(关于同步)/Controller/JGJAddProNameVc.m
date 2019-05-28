//
//  JGJAddProNameVc.m
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddProNameVc.h"

#import "JGJAddProNameView.h"

@interface JGJAddProNameVc () <JGJAddProNameViewDelegate>

@property (nonatomic, strong) JGJAddProNameView *proNameView;

@end

@implementation JGJAddProNameVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.proNameView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JGJAddProNameView *)proNameView {
    
    if (!_proNameView) {
        
        _proNameView = [[JGJAddProNameView alloc] initWithFrame:TYGetUIScreenMain.bounds];
        
        _proNameView.delegate = self;
    }
    
    return _proNameView;
}

#pragma mark - JGJAddProNameViewDelegate

- (void)addProNameView:(JGJAddProNameView *)view name:(NSString *)name {
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":name} success:^(id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(addProNameVc:requestResponse:)]) {
            
            [self.delegate addProNameVc:self requestResponse:responseObject];
        }

    }];
    
}

@end
