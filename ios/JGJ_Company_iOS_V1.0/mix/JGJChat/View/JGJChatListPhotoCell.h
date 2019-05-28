//
//  JGJChatListPhotoCell.h
//  mix
//
//  Created by Tony on 2016/8/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJChatListPhotoCell;

typedef void(^DidSelectedPhotoBlock)(JGJChatListPhotoCell *photoCell,UIImage *image);

@interface JGJChatListPhotoCell : UICollectionViewCell

@property (nonatomic,copy) DidSelectedPhotoBlock didSelectedPhotoBlock;

@property (nonatomic,strong,readonly) NSIndexPath *indexPath;

- (void)setIndex:(NSIndexPath *)indexPath image:(id)image;
@end
