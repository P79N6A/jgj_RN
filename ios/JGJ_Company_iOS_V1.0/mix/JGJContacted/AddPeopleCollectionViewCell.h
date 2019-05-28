//
//  AddPeopleCollectionViewCell.h
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPeopleCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JGJSynBillingModel *DataNameModel;
@property (strong, nonatomic) IBOutlet UIImageView *Photo;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (nonatomic ,strong) NSString *Url_Str;
@property (nonatomic ,strong) NSString *NameStr;
@property (strong, nonatomic) IBOutlet UIButton *headButton;

@property(nonatomic ,strong)NSMutableDictionary   *userInfo;

@end
