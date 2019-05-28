//
//  JLGProjectTypeViewController.h
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ProjectType,
    WorkType,
    Work_level
} SelectedType;

@class JLGProjectTypeViewController;

@protocol JLGProjectTypeViewControllerDelegate <NSObject>
- (void)JLGProjectTypeVc:(JLGProjectTypeViewController *)workTypeVc SelectedArray:(NSArray *)selectedArray dataDic:(NSDictionary *)dataDic;
@end

@interface JLGProjectTypeViewController : UIViewController

@property (nonatomic , weak) id<JLGProjectTypeViewControllerDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (copy,nonatomic) NSArray *projectTypesArray;
@property (strong,nonatomic) NSMutableArray *selectedArray;//点击为1，没有点击为0
@property (assign,nonatomic) BOOL selectedSingle;//是否是单选,单选的时候，用圆点
@property (assign,nonatomic) BOOL multipleNoLimit;//多选的时候是否有限制，如果有限制，就显示@"你最多可选择5个类型(还剩下5个)",如果没有限制，直接显示成为多选
@property (assign, nonatomic) SelectedType selectedType;//选择的类型,项目工种
@end
