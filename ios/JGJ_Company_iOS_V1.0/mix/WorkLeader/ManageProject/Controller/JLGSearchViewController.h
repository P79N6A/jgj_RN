//
//  JLGSearchViewController.h
//  mix
//
//  Created by jizhi on 15/12/23.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "JGJTSearchProAddressDefaultCell.h"

#import "JLGCityModel.h"

@protocol JLGSearchViewControllerDelegate <NSObject>

- (void)searchVcCancel;

- (void)searchVcSelectLocation:(NSString *)location addressName:(NSString *)addressName;

@end

@interface JLGSearchViewController : UIViewController
@property (nonatomic , weak) id<JLGSearchViewControllerDelegate> delegate;

@property (nonatomic,copy) NSString *proName;

@property (nonatomic, copy) NSString *searchName;

@property (nonatomic, strong) JGJProAddressModel *searchAddressModel; //搜索地址模型

@property (nonatomic, strong) JLGCityModel *cityModel;//城市模型
@end
