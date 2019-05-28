//
//  JGJHeadView.m
//  JGJCompany
//
//  Created by Tony on 2017/1/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHeadView.h"
#import "UIImageView+WebCache.h"
#define selfframe 50
@implementation JGJHeadView


#pragma mark - 赶工期临时使用
-(instancetype)initWithFrame:(CGRect)frame withframe:(NSArray *)array
{
    if (self =[super initWithFrame:frame]) {
           self.layer.cornerRadius = 1.5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = TYColorHex(0xd8d9e6);
        
        if (array.count == 1) {
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self OneHead:array];
                
//            });
        }else if (array.count == 2){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self twoHead:array];
//            });
            
        }else if (array.count == 3){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self ThreeHead:array];
//            });
            
        }else if (array.count == 4){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self fourHead:array];
//            });
            
        }else if(array.count == 5){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self fiveHead:array];
//            });
        }else if(array.count == 6){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self sixHead:array];
//            });
            
        }else if(array.count == 7){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self sevenHead:array];
                
//            });
            
        }else if(array.count == 8){
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self eightHead:array];
//            });
            
        }else if(array.count >= 9){
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self nineHead:array];
//            });
        }else{
        }
    }
    return self;
}
-(void)OneHead:(NSArray *)arr{
    UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfframe+1, CGRectGetHeight(self.frame))];
    [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[0]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
    [self addSubview:imagview];
}
-(void)twoHead:(NSArray *)arr{
    for (int i = 0; i<2; i++) {
        UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/2*i+.8, CGRectGetWidth(self.frame)/4, (selfframe-2)/2, CGRectGetHeight(self.frame)/2-1)];
        [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
        [self addSubview:imagview];
    }
}
-(void)ThreeHead:(NSArray *)arr{
    for (int i = 0; i<3; i++) {
        if (i == 0) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/4, 1, selfframe/2, CGRectGetHeight(self.frame)/2-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }else{
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/2*(i-1)+1.1, CGRectGetHeight(self.frame)/2, selfframe/2-1.32, CGRectGetHeight(self.frame)/2-1.5)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }
    }
}
-(void)fourHead:(NSArray *)arr{
    for (int i = 0; i<4; i++) {
        if (i == 0||i == 1) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/2*i+.8, 1.3, selfframe/2-1, CGRectGetHeight(self.frame)/2-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }else{
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/2*(i-2)+.8, CGRectGetHeight(self.frame)/2+.5, CGRectGetWidth(self.frame)/2-1.2, CGRectGetHeight(self.frame)/2-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }
    }
}
-(void)fiveHead:(NSArray *)arr{
    for (int i = 0; i<5; i++) {
        if (i == 0||i == 1) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/6+CGRectGetWidth(self.frame)/3*i+2.2, CGRectGetHeight(self.frame)/6+.8, selfframe/3-.6, CGRectGetHeight(self.frame)/3-1.5)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }else{
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-2)+2, CGRectGetHeight(self.frame)/3+CGRectGetHeight(self.frame)/6+.4, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }
    }
}
-(void)sixHead:(NSArray *)arr{
    for (int i = 0; i<6; i++) {
        /*  if (i == 0||i == 1) {
         UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/3*i+2, 1, CGRectGetWidth(self.frame)/3-3, CGRectGetHeight(self.frame)/3-3)];
         [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
         [self addSubview:imagview];
         
         }else{*/
        if (i == 0||i == 1||i == 2) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*i+2, CGRectGetHeight(self.frame)/6+1, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1.2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }else{
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-3)+2, CGRectGetHeight(self.frame)/3+CGRectGetHeight(self.frame)/6+1, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }
        //}
    }
}
-(void)sevenHead:(NSArray *)arr{
    for (int i = 0; i<7; i++) {
        if (i == 0) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3+2, 2, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }else if(i == 1||i == 2||i == 3){
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-1)+2, CGRectGetHeight(self.frame)/3+.6, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }else{
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-4)+2, CGRectGetHeight(self.frame)/3*2, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
            
        }
    }
}
-(void)eightHead:(NSArray *)arr{
    for (int i = 0; i<8; i++) {
        if (i == 0||i == 1) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/6+CGRectGetWidth(self.frame)/3*i+2, 1.5, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }else if(i == 2||i == 3||i == 4){
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-2)+2, CGRectGetHeight(self.frame)/3+.6, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1.2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }else{
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-5)+2, CGRectGetHeight(self.frame)/3*2, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1.2)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }
    }
}
-(void)nineHead:(NSArray *)arr{
    for (int i = 0; i<9; i++) {
        if (i == 0||i == 1||i == 2) {
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*i+2, 1.6, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1.6)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }else if(i == 3||i == 4||i == 5){
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-3)+2, CGRectGetHeight(self.frame)/3+1, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1.6)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
        }else if(i == 6||i == 7||i == 8){
            UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(selfframe/3*(i-6)+2, CGRectGetHeight(self.frame)/3*2, selfframe/3-1.2, CGRectGetHeight(self.frame)/3-1.6)];
            [imagview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,arr[i]]] placeholderImage:[UIImage imageNamed:@"defaultHead_Man"]];
            [self addSubview:imagview];
            
        }
    }
}

-(UIImage *)acordingArrayRetrunImage:(NSArray *)ImageArray
{
    
    if (ImageArray.count == 1) {
        
    }
    return 0;
}




@end
