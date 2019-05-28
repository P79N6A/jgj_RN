//
//  JGJScanImageViewController.m
//  mix
//
//  Created by Tony on 2017/1/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJScanImageViewController.h"
#import "UIImageView+WebCache.h"
@interface JGJScanImageViewController ()
@property(strong ,nonatomic)UIScrollView *scrollView;
@end

@implementation JGJScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        UISwipeGestureRecognizer *swipGuessTrue = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Swipe:)];
        swipGuessTrue.direction = UISwipeGestureRecognizerDirectionRight;
        [_scrollView addGestureRecognizer:swipGuessTrue];
        UISwipeGestureRecognizer *swipGuessTrues = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Swipeleft:)];
        swipGuessTrues.direction = UISwipeGestureRecognizerDirectionLeft;
        [_scrollView addGestureRecognizer:swipGuessTrues];
        

    }
    return _scrollView;
}
-(void)Swipe:(UISwipeGestureRecognizer *)recogNize
{
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+TYGetUIScreenWidth, 0)];
    
    


}
-(void)Swipeleft:(UISwipeGestureRecognizer *)recogNize
{

    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x-TYGetUIScreenWidth, 0)];


}

-(void)setImageArray:(NSArray *)ImageArray
{
    
    [_scrollView setContentSize:CGSizeMake(ImageArray.count*TYGetUIScreenWidth,TYGetUIScreenHeight)];
    _scrollView.pagingEnabled = YES;
    for (int i = 0; i<ImageArray.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth*i, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,ImageArray[i]]] placeholderImage:nil];
//        if (i == 0||i == 3) {
//            imageview.image = [UIImage imageNamed:@"new_feature_2.jpg"];
// 
//        }
        [self.scrollView addSubview:imageview];
    }


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
