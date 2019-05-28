//
//  JGJRNBaseController.m
//  mix
//
//  Created by Json on 2019/4/28.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRNBaseController.h"
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>

@interface JGJRNBaseController ()

@end

@implementation JGJRNBaseController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppFontfafafaColor;
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL: self.jsCodeLocation
                                moduleName: self.moudleName
                         initialProperties:@{}
                             launchOptions: nil];
    [self.view addSubview:rootView];
    self.rootView = rootView;
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets inset = self.view.safeAreaInsets;
    [self.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-inset.bottom);
    }];
}







@end
