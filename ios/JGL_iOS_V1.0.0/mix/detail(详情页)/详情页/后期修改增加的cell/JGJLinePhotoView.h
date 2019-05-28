//
//  JGJLinePhotoView.h
//  mix
//
//  Created by Tony on 2017/7/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tapPhotoViewBlock)(UIImage *image);
typedef void(^heightBlock)(NSString *height);
@protocol tapCollectionViewPhotoDelegate <NSObject>

-(void)tapCollectionViewPhotoWithTag:(NSInteger)currentindex andimgs:(NSMutableArray *)imageArrs;

@end
@interface JGJLinePhotoView : UIView
/*
 *九宫格
 */
 
-(instancetype)initWithFrame:(CGRect)frame andImageArr:(NSArray *)imageArr andSize:(CGSize )Size andDepart:(NSInteger)lineDepart andViewHeightblock:(heightBlock)height;
/*
 *九宫格
 */
-(instancetype)initWithFrame:(CGRect)frame OlineandImageArr:(NSArray *)imageArr andSize:(CGSize )Size andDepart:(NSInteger)lineDepart andViewHeightblock:(heightBlock)height;


+(void)initPhotoImageWithUrl_Arr:(NSMutableArray *)arr withFrameSize:(CGSize)frameSize andupLineDepart:(NSInteger)upline andDownLineDepart:(NSInteger)downLine andBlockImage:(tapPhotoViewBlock)imageBlock;


@property (nonatomic ,copy)tapPhotoViewBlock tapPhotoImageBlock;
@property (nonatomic ,copy)heightBlock height;
@property (nonatomic ,strong)id <tapCollectionViewPhotoDelegate>delegate;
@property (nonatomic ,strong)NSMutableArray *imagArrs;


@end
