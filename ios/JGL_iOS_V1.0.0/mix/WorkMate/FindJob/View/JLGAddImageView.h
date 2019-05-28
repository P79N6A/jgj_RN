//
//  JLGAddImageView.h
//  mix
//
//  Created by jizhi on 15/11/29.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGAddImageViewDelegate <NSObject>

-(void)addImageButtonIndex:(NSInteger )imageIndex;
@end

@interface JLGAddImageView : UIView
@property (nonatomic, weak) id<JLGAddImageViewDelegate> delegate;
@property (nonatomic, copy) UIImage *addImage;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@end
