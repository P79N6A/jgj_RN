//
//  JGJServicePeopleNumTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,JGJGoodsType)
{
   VIPType,
   CloudType,
};
@protocol selectGoodsNumdelegate <NSObject>
-(void)selectGoodNum:(NSString *)num andtype:(JGJGoodsType)type;
@end
@interface JGJServicePeopleNumTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *peopleNumLable;
@property (strong, nonatomic) IBOutlet UILabel *desLable;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIButton *subButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITextField *textFiled;
@property (strong, nonatomic)  id<selectGoodsNumdelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *desbutton;
@property (strong, nonatomic) IBOutlet UIView *addButtonView;
@property (assign, nonatomic)  JGJGoodsType goodsType;
@property (strong, nonatomic) IBOutlet UILabel *numLable;
@property (assign, nonatomic)  NSInteger peopleNum;
@property (strong ,nonatomic) JGJOrderListModel *orderListModel;
@property (strong ,nonatomic) JGJMyRelationshipProModel *proDetail;
@property (assign, nonatomic)  long alreadyHaveCloud;//云盘最小值
@property (assign, nonatomic)  long alreadyHaveeople;//高级服务版的最小值
@property (assign, nonatomic)  long VIPCloundDefult;//购买高级服务版是的云盘默认值
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titlelableTopconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *unitesConstace;
@property (strong, nonatomic) IBOutlet UILabel *departLable;
@property (assign ,nonatomic) BOOL BuyCloud;//却分购买商品类型


@end
