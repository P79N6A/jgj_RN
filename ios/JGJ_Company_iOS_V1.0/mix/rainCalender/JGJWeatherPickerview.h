//
//  JGJWeatherPickerview.h
//  mix
//
//  Created by Tony on 2017/3/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, weatherClassModel) {
    JGJWeatherPickermodel,
    JGJPacknumPickermodel
};
@protocol didselectweaterindexpath <NSObject>
//单选
- (void)didselectweaterevent:(NSIndexPath *)indexpath andstr:(NSString *)content;
//多选
- (void)didMoreselectweaterevent:(NSIndexPath *)indexpath andstr:(NSMutableArray *)selectArr;

- (void)didMoreselectweaterevent:(NSIndexPath *)indexpath andArr:(NSMutableArray *)selectArr andDelete:(BOOL)del;
//点击取消确定按钮
- (void)clickTopbutton:(NSString *)buttonTitle;
//清零
- (void)cleanrRainCalender;

@end
@interface JGJWeatherPickerview : UIView
@property (nonatomic ,strong)UICollectionView *collectionview;
@property (nonatomic , strong)UIView *topView;
@property (nonatomic , strong)UIView *placeView;
@property (nonatomic , strong)UIView *bottomview;
@property (nonatomic , strong)UIButton *cancelButton;//取消按钮
@property (nonatomic , strong)UIButton *surebutton;//确定按钮

@property (nonatomic , strong)UILabel *toplable;
@property (nonatomic , strong)NSString *topname;
@property (nonatomic , strong)NSMutableArray *imagarray;
@property (nonatomic , strong)NSMutableArray *titlearray;
@property (nonatomic ,strong) id <didselectweaterindexpath>delegate;
@property (assign, nonatomic) weatherClassModel classmodel;
@property (assign, nonatomic) BOOL allowsMultipleSelections;//允许多选
@property (assign, nonatomic) BOOL Nshadow;//不需要描边
@property (assign, nonatomic) BOOL showCancel;//是否显示取消按钮和确定按钮 目前用于判断是不是晴雨表
@property (assign, nonatomic) NSMutableArray *selectArr;//是否显示取消按钮和确定按钮 目前用于判断是不是晴雨表

//选中的标签
@property (strong, nonatomic) UILabel *selLable;

- (void)showWeatherPickerView;
-(void)removeview;

-(instancetype)initWithFrame:(CGRect)frame andHadseledArr:(NSMutableArray *)Arr;

@end
