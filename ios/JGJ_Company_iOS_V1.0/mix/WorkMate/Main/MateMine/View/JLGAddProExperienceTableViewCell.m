//
//  JLGAddProExperienceTableViewCell.m
//  mix
//
//  Created by Tony on 16/1/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAddProExperienceTableViewCell.h"

#define kAddProExperLineMaxNum (TYIS_IPHONE_5_OR_LESS?3:4)
@interface JLGAddProExperienceTableViewCell ()
<
    JLGPhoneCollectionDelegate
>
@end

@implementation JLGAddProExperienceTableViewCell
@synthesize imagesArray = _imagesArray;

- (CGFloat )getHeightWithImagesArray:(NSMutableArray *)imagesArray{
    JLGPhoneCollection *imagesCollectionCell = [JLGPhoneCollection new];
    [imagesCollectionCell getHeightWithImagesArray:imagesArray byLineMaxNum:kAddProExperLineMaxNum width:TYGetUIScreenWidth - 20];
    
    
    return imagesCollectionCell.collectionViewH + 13;
}

- (void)setImagesArray:(NSMutableArray *)imagesArray{
    _imagesArray = imagesArray;

    self.imagesCollectionCell.delegate = self;

    [self.imagesCollectionCell initByImagesArray:self.imagesArray byLineMaxNum:kAddProExperLineMaxNum width:TYGetUIScreenWidth - 20];
    
    self.cellHeight = self.imagesCollectionCell.collectionViewH + 10;
}

- (void)phoneDelete:(JLGPhoneCollection *)phoneCollectionCell index:(NSInteger )index{
    if (self.deleteCallBack) {
        self.deleteCallBack(phoneCollectionCell,index);
    }
}
-(void)setHeight:(NSInteger)height
{
    _headDepart.constant = height;

}

@end
