//
//  JGJImageCollectionViewCell.h
//  九宫格图片
//
//  Created by Tony on 2017/6/8.
//  Copyright © 2017年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJLImageCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property(nonatomic ,strong)NSString *urlStr;
@end
