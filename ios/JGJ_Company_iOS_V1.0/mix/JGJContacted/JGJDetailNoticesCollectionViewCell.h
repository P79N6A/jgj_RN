//
//  JGJDetailNoticesCollectionViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/12/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJDetailNoticesCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstance;
@end
