//
//  JLGAddProExperienceTableViewCell.h
//  mix
//
//  Created by Tony on 16/1/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGMYProExperienceTableViewCell.h"

@class JLGPhoneCollection;
typedef void(^DeleteImageCallBackBlock)(JLGPhoneCollection *collectionCell,NSInteger index);//index,删除的第几个
@interface JLGAddProExperienceTableViewCell : JLGMYProExperienceTableViewCell
- (CGFloat )getHeightWithImagesArray:(NSMutableArray *)imagesArray;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headDepart;

//删除图片的callBack
@property (nonatomic , copy) DeleteImageCallBackBlock deleteCallBack;
@property (nonatomic , assign) NSInteger height;

@end
