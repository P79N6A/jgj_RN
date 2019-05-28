//
//  JGJCollectionImageHeadView.h
//  九宫格图片
//
//  Created by Tony on 2017/6/8.
//  Copyright © 2017年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol didselectIndexPathdelegate <NSObject>
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;//点击图片
@end
@interface JGJCollectionImageHeadView : UIView
@property(nonatomic ,strong)NSMutableArray *DataArr;
@property(nonatomic ,strong)id <didselectIndexPathdelegate> delegate;

@end
