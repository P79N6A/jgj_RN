//
//  TYOpenAlbum.h
//  mix
//
//  Created by jizhi on 15/11/11.
//  Copyright © 2015年 JiZhi. All rights reserved.
//  打开摄像头

#import <Foundation/Foundation.h>

@interface TYOpenAlbum : NSObject
@property (nonatomic ,strong) NSMutableArray *imagesArray;

-(void)addHeadImageInView:(UIViewController *)viewController;
@end
