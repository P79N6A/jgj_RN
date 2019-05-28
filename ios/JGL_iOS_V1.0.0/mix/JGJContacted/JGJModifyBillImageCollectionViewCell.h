//
//  JGJModifyBillImageCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/10/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJModifyBillImageCollectionViewDlegate <NSObject>

-(void)JGJModifyBillImageCollectionViewDeleteImageAndIndex:(NSInteger)index;

@end
@interface JGJModifyBillImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@property (strong, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) id <JGJModifyBillImageCollectionViewDlegate>delegate;

@end
