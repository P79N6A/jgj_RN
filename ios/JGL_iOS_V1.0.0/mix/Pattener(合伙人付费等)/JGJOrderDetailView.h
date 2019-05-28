//
//  JGJOrderDetailView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GoodTYpe){
  JGJHighProTYpe,//高级项目服务
  JGJCloudNetType,//云盘

};
@interface JGJOrderDetailView : UIView
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iamgeview;
@property (strong, nonatomic) IBOutlet UIImageView *imageviews;

@property (assign, nonatomic) GoodTYpe goodsType;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;

@end
