//
//  RFLayout.m
//  RFCircleCollectionView
//
//  Created by Arvin on 15/11/25.
//  Copyright © 2015年 mobi.refine. All rights reserved.
//

#import "RFLayout.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.1
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)


@implementation RFLayout

-(id)init
{
    self = [super init];
    if (self) {
        

        if (isiPhoneX) {
            self.itemSize = CGSizeMake(kScreen_Width - 100 , TYGetUIScreenHeight - 200 - 78);
            self.sectionInset = UIEdgeInsetsMake(90 + 44 , 46, 72.5  + 34, 50);

        }else{
            self.itemSize = CGSizeMake(kScreen_Width - 100 , TYGetUIScreenHeight - 200 );
            self.sectionInset = UIEdgeInsetsMake(90  , 46, 72.5, 50);

        }

        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 20;

        
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            distance = ABS(distance);
            
            if (distance < kScreen_Width / 2 + self.itemSize.width) {
                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - distance / ACTIVE_DISTANCE);
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0 , -zoom * 25, 0);
                attributes.alpha = zoom - ZOOM_FACTOR;
            }
        }
    }
    return array;

//    //1.确定加载item的区域
//    CGFloat  x = self.collectionView.contentOffset.x;
//    CGFloat  y = 0;
//    CGFloat  w = self.collectionView.frame.size.width;
//    CGFloat  h = self.collectionView.frame.size.height;
//    CGRect myrect =CGRectMake(x, y, w, h);
//    
//    //2.获得这个区域的item
//    NSArray *original =[super layoutAttributesForElementsInRect:myrect];
//    
//    //遍历item,快到中间的时候放大，离开中间的时候收索
//    for (UICollectionViewLayoutAttributes *atts in original) {
//        //1.获得item距离左边的边框的距离
//        CGFloat leftdelta = atts.center.x - self.collectionView.contentOffset.x;
//        
//        //2.获得屏幕的中心点
//        CGFloat centerX = self.collectionView.frame.size.width * 0.5;
//        //3.获得距离中心的距离
//        CGFloat dela = fabs(centerX - leftdelta);
//        
//        //4.左边的item缩小
//        CGFloat rightscale =1.00 - dela/centerX;
//        
//        //5.缩放
//        atts.transform =CGAffineTransformMakeScale(1 + rightscale * .4, 1 + rightscale * .4);
//        //6.加透明度
//        if (self.isAlpha) {
//            
//            CGFloat dela1 = fabs(leftdelta -centerX);
//            CGFloat rightscale1 = 1.00-dela1/centerX;
//            
//            if (rightscale1 < 0.5) {
//                atts.alpha = 0.5;
//            }else if(rightscale1 > 0.99){
//                atts.alpha = 1;
//            }else{
//                atts.alpha = rightscale1;
//            }
//        }
//
//        
//    }
//    NSArray * attributes = [[NSArray alloc] initWithArray:original copyItems:YES];
//    
//    return attributes;

}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//        }
//    }
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    CGFloat  x = self.collectionView.contentOffset.x;
    CGFloat  y = 0;
    CGFloat  w = self.collectionView.frame.size.width;
    CGFloat  h = self.collectionView.frame.size.height;
    CGRect myrect = CGRectMake(x, y, w, h);
    
    //1.2.获得这个区域的item
    NSArray *arr =[super layoutAttributesForElementsInRect:myrect];
    
    CGFloat mindelta =MAXFLOAT;
    for (UICollectionViewLayoutAttributes *atts in arr) {
        
        //2.计算距离中心点的距离
        //1.获得item距离左边的边框的距离
        CGFloat leftdelta =atts.center.x -proposedContentOffset.x;
        //2.获得屏幕的中心点
        CGFloat centerX =self.collectionView.frame.size.width *0.5;
        //3.获得距离中心的距离
        CGFloat dela = fabs(centerX -leftdelta);
        //4.获得最小的距离
        if(dela <= mindelta)
            mindelta = centerX -leftdelta;
    }
    
    //定位在中心，注意是-号，回到之前的位置
    proposedContentOffset.x -= mindelta;
    
    //防止在第一个和最后一个 滑到中间时  卡住
    if (proposedContentOffset.x < 0) {
        proposedContentOffset.x = 0;
    }
    
    if (proposedContentOffset.x > (self.collectionView.contentSize.width - self.sectionInset.left - self.sectionInset.right - self.itemSize.width)) {
        
        proposedContentOffset.x = floor(proposedContentOffset.x);
    }
    
    return proposedContentOffset;
}


@end
