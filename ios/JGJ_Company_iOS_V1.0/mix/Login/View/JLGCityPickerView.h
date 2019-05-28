//
//  JLGCityPickerView.h
//  mix
//
//  Created by jizhi on 15/12/5.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

typedef enum : NSUInteger {
    HometownType,
    ExpectAreaType
    
} SelectedAreaType;
#import <UIKit/UIKit.h>
@protocol JLGCityPickerViewDelegate <NSObject>

@optional
/*first存编号，last存城市的字符串
示例:first：100110 last:四川省 成都市 武侯区
 */
- (void)JLGCityPickerSelect:(NSDictionary *)cityDic;
- (void)JLGCityPickerSelect:(NSDictionary *)cityDic byIndexPath:(NSIndexPath *)indexPath;
@end

@interface JLGCityPickerView : UIView

@property (weak, nonatomic) id<JLGCityPickerViewDelegate> delegate;
@property (assign,nonatomic) BOOL onlyShowCitys;//只有2级城市的情况
/**根据选择的类型确定PickView标题*/
@property (assign, nonatomic) SelectedAreaType selectedAreaType;
- (void)showCityPicker;
- (void)showCityPickerByIndexPath:(NSIndexPath *)indexPath;
- (void)hiddenCityPicker;

@end