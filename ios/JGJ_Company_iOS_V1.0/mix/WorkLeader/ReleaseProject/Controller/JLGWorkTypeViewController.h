//
//  JLGWorkTypeViewController.h
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLGWorkTypeViewController;
@protocol JLGWorkTypeViewControllerDelegate <NSObject>
- (void)JLGWorkTypeVc:(JLGWorkTypeViewController *)workTypeVc SelectedArray:(NSArray *)selectedArray;
@end

@interface JLGWorkTypeViewController : UIViewController
@property (nonatomic , weak) id<JLGWorkTypeViewControllerDelegate> delegate;
@property (nonatomic,copy) NSArray *workTypesArray;
@property (strong,nonatomic) NSMutableArray *selectedArray;//点击为1，没有点击为0
@end
