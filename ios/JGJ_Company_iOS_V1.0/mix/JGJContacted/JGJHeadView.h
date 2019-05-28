//
//  JGJHeadView.h
//  JGJCompany
//
//  Created by Tony on 2017/1/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHeadView : UIView
-(instancetype)initWithFrame:(CGRect)frame withframe:(NSArray *)array;

//@property(nonatomic ,strong)UIImageView *imageview;
-(UIImage *)acordingArrayRetrunImage:(NSArray *)ImageArray;
@end
