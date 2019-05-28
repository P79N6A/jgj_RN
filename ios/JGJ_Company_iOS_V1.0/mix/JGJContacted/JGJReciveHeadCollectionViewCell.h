//
//  JGJReciveHeadCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/1/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJReciveHeadCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *holdLable;
@property (nonatomic ,strong)NSString *url_str;

@property (nonatomic, strong) JGJSynBillingModel *detailMemeberModel;
@property (nonatomic, strong) UILabel *NodataLable;
@property (strong, nonatomic) IBOutlet UILabel *noDataLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;

@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (nonatomic ,strong)UIImage *image;
@end
