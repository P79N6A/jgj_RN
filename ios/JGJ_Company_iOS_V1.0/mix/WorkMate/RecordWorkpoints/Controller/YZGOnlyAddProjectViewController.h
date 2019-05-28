//
//  YZGOnlyAddProjectViewController.h
//  mix
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EditNameType) {
    EditProNameType = 1,
    EditMineNameType,
};

@protocol YZGOnlyAddProjectViewControllerDelegate <NSObject>

@optional
- (void)handleYZGOnlyAddProjectViewControllerEditName:(NSString *)editName editType:(EditNameType )editType;
@end
@interface YZGOnlyAddProjectViewController : UIViewController
@property (nonatomic,assign) BOOL superViewIsGroup;
@property (nonatomic, weak) id <YZGOnlyAddProjectViewControllerDelegate> delegate;
@property (nonatomic, assign) EditNameType editType; //创建班组进入
@property (nonatomic, copy) NSString *proNameTFPlaceholder;
@property (nonatomic, copy) NSString *defaultProName; //默认名字

@property (nonatomic, assign) BOOL isEditGroupName; //编辑班组名字
@end
