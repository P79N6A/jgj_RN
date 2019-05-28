//
//  YZGAddContactsTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYModel.h"
#import "CustomView.h"
/// 服务器获取的model
@class GetBillSet_Tpl;
@interface YZGAddForemanModel : TYModel

@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *name_pinyin_abbr;//拼音首字母缩写
@property (nonatomic,copy) NSString *name_pinyin;//纯拼音
@property (nonatomic,copy) NSString *telph;
@property (nonatomic,strong) GetBillSet_Tpl *tpl;
@property (nonatomic, assign) BOOL isDelete;
@end

typedef void(^YZGDeleteForemanModelBlock)(YZGAddForemanModel *);
@interface YZGAddContactsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic,strong) YZGAddForemanModel *addForemanModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;
@property (copy, nonatomic) YZGDeleteForemanModelBlock deleteForemanModelBlock;
@end
