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
            for (int i = 0; i<imageArr.count; i++) {
                if (i<3) {
                    
                
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*(i+1) + (Size.width -lineDepart * 4) /3 * i + 5, 0, (Size.width -lineDepart * 4) /3, (Size.width -lineDepart * 4) /3)];
                    imageview.userInteractionEnabled = YES;
                imageview.tag = i;
                [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:nil];
                    UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageControl:)];
                    [imageview addGestureRecognizer:tapGuesstrue];
                [self addSubview:imageview];
                    
                    [self.imagArrs addObject:imageview];
                    
                }else if (i >= 3&& i<6)
                {
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*((i-3)+1) + (Size.width -lineDepart * 4) /3 * (i - 3) + 5, (Size.width -lineDepart * 4) /3  +lineDepart, (Size.width -lineDepart * 4) /3, (Size.width -lineDepart * 4) /3 )];
                    imageview.tag = i;
                    imageview.userInteractionEnabled = YES;

                    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:nil];
                    UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageControl:)];
                    [imageview addGestureRecognizer:tapGuesstrue];

                    [self addSubview:imageview];
                    
                    [self.imagArrs addObject:imageview];

                }else{
                
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(lineDepart*((i-6)+1) + (Size.width -lineDepart * 4) /3 * (i - 6) + 5, ((Size.width -lineDepart * 4) /3 * 2)  +lineDepart*2, (Size.width -lineDepart * 4) /3, (Size.width -lineDepart * 4) /3 )];
                    imageview.tag = i;
                    imageview.userInteractionEnabled = YES;

                    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@media/simages/m/%@",JLGHttpRequest_UpLoadPicUrl_center_image,imageArr[i]]] placeholderImage:nil];
                    UITapGestureRecognizer *tapGuesstrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageControl:)];
                    [imageview addGestureRecognizer:tapGuesstrue];

                    [self addSubview:imageview];
                    
                    [self.imagArrs addObject:imageview];


                }
              
               
                
                
            }
        }
}
-(NSMutableArray *)imagArrs
{
    if (!_imagArrs) {
        _imagArrs = [NSMutableArray array];
    }
    return _imagArrs;
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
