//
//  JGJMoreLogCollectionViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMoreLogCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *addImageview;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) JGJGetLogTemplateModel *model;
@end
