//
//  JLGPhoneCollection.h
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLGPhoneCollection;
@protocol JLGPhoneCollectionDelegate <NSObject>
@optional
- (void)phoneDidSelected:(JLGPhoneCollection *)phoneCollectionCell index:(NSInteger )index;
- (void)phoneDelete:(JLGPhoneCollection *)phoneCollectionCell index:(NSInteger )index;
- (void)phoneTouch;
@end

@interface JLGPhoneCollection : UIView
@property (nonatomic , weak) id<JLGPhoneCollectionDelegate> delegate;

@property (nonatomic,assign) CGFloat collectionViewH;//算出来collection的高度

#pragma mark 获取高度
- (void)getHeightWithImagesArray:(NSArray *)imagesArray byLineMaxNum:(NSInteger )lineMaxNum width:(CGFloat)width;

- (void )initByImagesArray:(NSArray *)imagesArray byLineMaxNum:(NSInteger )lineMaxNum width:(CGFloat )width;

@property (nonatomic,assign) BOOL showDeleteButton;
@property (nonatomic,assign) BOOL hiddenAddButton;
@property (nonatomic,strong) NSMutableArray *imagesArray;//保存image的url
@property (nonatomic,strong) NSMutableArray *deleteImgsArray;//保存删除的图片的url

- (void)setupView;
@end
