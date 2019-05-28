//
//  JGJSingerTextCollectionViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSingerTextCollectionViewCell : UICollectionViewCell
@property (strong ,nonatomic)JGJElementDetailModel *elementModel;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLableWidth;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@end
