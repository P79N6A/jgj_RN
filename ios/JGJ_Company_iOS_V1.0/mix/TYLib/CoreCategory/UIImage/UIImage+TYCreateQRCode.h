//
//  UIImage+TYCreateQRCode.h
//  LTYSamples
//
//  Created by Tony on 16/08/23.
//  Copyright © 2016年 cnpayany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TYCreateQRCode)


+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress;


+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress
                     codeSize: (CGFloat)codeSize;



+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress
                     codeSize: (CGFloat)codeSize
                          red: (NSUInteger)red
                        green: (NSUInteger)green
                         blue: (NSUInteger)blue;



+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress
                     codeSize: (CGFloat)codeSize
                          red: (NSUInteger)red
                        green: (NSUInteger)green
                         blue: (NSUInteger)blue
                  insertImage: (UIImage *)insertImage;

+ (UIImage *)imageOfQRFromURL: (NSString *)networkAddress
                     codeSize: (CGFloat)codeSize
                          red: (NSUInteger)red
                        green: (NSUInteger)green
                         blue: (NSUInteger)blue
                  insertImage: (UIImage *)insertImage
                  roundRadius: (CGFloat)roundRadius;


@end
