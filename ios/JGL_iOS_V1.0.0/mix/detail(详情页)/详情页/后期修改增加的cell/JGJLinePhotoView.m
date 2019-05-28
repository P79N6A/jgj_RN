//
//  JGJLinePhotoView.m
//  mix
//
//  Created by Tony on 2017/7/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJLinePhotoView.h"
#import "UIImageView+WebCache.h"
@implementation JGJLinePhotoView
- (instancetype)initWithFrame:(CGRect)frame andImageArr:(NSArray *)imageArr andSize:(CGSize)Size andDepart:(NSInteger)lineDepart andViewHeightblock:(heightBlock)height{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initImageWithUrlArr:imageArr andSize:Size andDepart:lineDepart];
    }
    return self;
}
- (void)initImageWithUrlArr:(NSArray *)imageArr andSize:(CGSize )Size andDepart:(NSInteger)lineDepart
{
    if (imageArr.count) {
        
        self.imagArrs = [NSMutableArray array];
        
            for (int i = 0; i<imageArr.count; i++) {
                if (i<3) {
                    
                
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*(i+1) + (Size.width -lineDepart * 4) /3 * i + 5, 0, (Size.width -lineDepart * 4) /3, (Size.width -lineDepart * 4) /3)];
                    
                    imageview.contentMode = UIViewContentModeScaleAspectFill;
                    
                    imageview.clipsToBounds = YES;
                    
                imageview.tag = i;
                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:nil];
                    imageview.userInteractionEnabled = YES;

                    UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageControl:)];
                    [imageview addGestureRecognizer:tapGuesstrue];
                [self addSubview:imageview];
                    
                    [self.imagArrs addObject:imageview];

                }else if (i >= 3&& i<6)
                {
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*((i-3)+1) + (Size.width -lineDepart * 4) /3 * (i - 3) + 5, (Size.width -lineDepart * 4) /3  +lineDepart, (Size.width -lineDepart * 4) /3, (Size.width -lineDepart * 4) /3 )];
                    imageview.contentMode = UIViewContentModeScaleAspectFill;
                    imageview.clipsToBounds = YES;
                    imageview.tag = i;
                    imageview.userInteractionEnabled = YES;

                    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:nil];
                    UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageControl:)];
                    [imageview addGestureRecognizer:tapGuesstrue];
                    [self addSubview:imageview];

                    [self.imagArrs addObject:imageview];

                }else{
                
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*((i-6)+1) + (Size.width -lineDepart * 4) /3 * (i - 6) + 5, ((Size.width -lineDepart * 4) /3 * 2)  +lineDepart*2, (Size.width -lineDepart * 4) /3, (Size.width -lineDepart * 4) /3 )];
                    imageview.contentMode = UIViewContentModeScaleAspectFill;
                    imageview.clipsToBounds = YES;
                    imageview.tag = i;
                    imageview.userInteractionEnabled = YES;
                    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:[UIImage imageNamed:@"webViewFailure_Image"]];
                    UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageControl:)];
                    [imageview addGestureRecognizer:tapGuesstrue];                    [self addSubview:imageview];
                    
                    [self.imagArrs addObject:imageview];

                }
                
            }
        }
}
-(instancetype)initWithFrame:(CGRect)frame OlineandImageArr:(NSArray *)imageArr andSize:(CGSize)Size andDepart:(NSInteger)lineDepart andViewHeightblock:(heightBlock)height
{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initLineImageWithUrlArr:imageArr andSize:Size andDepart:lineDepart];
    }
    return self;

}

- (void)initLineImageWithUrlArr:(NSArray *)imageArr andSize:(CGSize )Size andDepart:(NSInteger)lineDepart
{
    if (imageArr.count) {
        
        self.imagArrs = [NSMutableArray array];
        
        for (int i = 0; i<imageArr.count; i++) {
            
                
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*(i+1) + (Size.width -lineDepart * 5) /4 * i + 5, 0, (Size.width -lineDepart * 5) /4, (Size.width -lineDepart * 5) /4)];
                imageview.tag = i;
                imageview.contentMode = UIViewContentModeScaleAspectFill;
            
                imageview.clipsToBounds = YES;
            
//                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,imageArr[i]]] placeholderImage:[UIImage imageNamed:@"loading_bgView1"]];
#pragma mark - 开发商中心裁剪地址有问题 所以线换了
            
            [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [TYNotificationCenter postNotificationName:JGJFrashMarkBillLineImageCell object:nil];
                }
            }];
//                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:[UIImage imageNamed:@"loading_bgView1"]];
                imageview.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewFromGuessTrue:)];
                [imageview addGestureRecognizer:tapGuesstrue];
                [self addSubview:imageview];
                
                [self.imagArrs addObject:imageview];
                
        }
        
    }
}
- (void)tapImageViewFromGuessTrue:(UIGestureRecognizer *)guessTrue
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tapCollectionViewPhotoWithTag:andimgs:)]) {
        [self.delegate tapCollectionViewPhotoWithTag:guessTrue.view.tag andimgs:self.imagArrs];
    }
}

-(void)tapImageControl:(UITapGestureRecognizer *)guessTrue
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(tapCollectionViewPhotoWithTag:andimgs:)]) {
        [self.delegate tapCollectionViewPhotoWithTag:guessTrue.view.tag andimgs:self.imagArrs];
    }
    
}
+ (void)initPhotoImageWithUrl_Arr:(NSMutableArray *)arr withFrameSize:(CGSize)frameSize andupLineDepart:(NSInteger)upline andDownLineDepart:(NSInteger)downLine andBlockImage:(tapPhotoViewBlock)imageBlock
{
//JGJLinePhotoView *photoImageView = [JGJLinePhotoView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, (frameSize.width -lineDepart * 4) /3 + 10 ) andImageArr:<#(NSMutableArray *)#> andSize:<#(CGSize)#> andDepart:<#(NSInteger)#>
//
}

@end
