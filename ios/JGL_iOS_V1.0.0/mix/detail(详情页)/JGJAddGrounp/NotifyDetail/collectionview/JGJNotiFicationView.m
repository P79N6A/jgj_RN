//
//  JGJNotiFicationView.m
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotiFicationView.h"
#import "UIImageView+WebCache.h"
#import "JGJGetViewFrame.h"
#import "JGJSclePhoto.h"
#import "JGJNotifyCationDetailViewController.h"
#define leftalign     NSTextAlignmentLeft
#define rightalign    NSTextAlignmentRight
#define centeralign   NSTextAlignmentCenter
#define departHeight  10
#define MainScreen [UIScreen mainScreen].bounds.size
@interface JGJNotiFicationView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImageView *HeadImageView;


}
@property(nonatomic ,strong)UIView *topView;

@end
@implementation JGJNotiFicationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.NewsLable];
////        [self addSubview:self.peopleCollectionview];
//        [self addSubview:self.FromLable];
//        [self addSubview:self.DepartLable];
//        [self hadReciveView];
////        [self addSubview:self.headImageView];
////        [self addSubview:self.NameLable];
////        [self addSubview:self.TimeLable];
//        [self addSubview:self.topView];
        _WorkheadImage = [NSArray array];
        
    }
    
    return self;
}
-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreen.width, 60)];
        _topView.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
        
        [_topView addSubview:self.headImageView];
        [_topView addSubview:self.NameLable];
        [_topView addSubview:self.TimeLable];
    }

    return _topView;
}
-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        CGRect rect = CGRectMake(5, 10, 40, 40) ;
        [_headImageView setFrame:rect];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapHeadImage)];
//        [_headImageView addGestureRecognizer:tap];

        
    }


    return _headImageView;
}
-(UILabel *)NameLable
{
    if (!_NameLable) {
        _NameLable = [UILabel new];
        CGRect rect = CGRectMake([JGJGetViewFrame GetMaxX:self.headImageView]+10, 20, 100, 20);
        _NameLable.text = @"来自:白悦城项目组";
        _NameLable.textAlignment = leftalign;
        _NameLable.font = [UIFont systemFontOfSize:14];
        [_NameLable setFrame:rect];

    }

    return _NameLable;
}
-(UILabel *)TimeLable
{
    if (!_TimeLable) {
        _TimeLable = [UILabel new];
        CGRect rect = CGRectMake([JGJGetViewFrame GetMaxX:self.NameLable]+10, 20, MainScreen.width-180, 20);
        _TimeLable.text = @"2016-12-24";
        _TimeLable.textAlignment = rightalign;
        _TimeLable.textColor = [UIColor darkGrayColor];
        _TimeLable.font = [UIFont systemFontOfSize:12];
        [_TimeLable setFrame:rect];
        
    }

    return _TimeLable;

}

-(UICollectionView *)peopleCollectionview
{
    if (!_peopleCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        int Num =0;
        Num = self.WorkheadImage.count/3+1;
        if (self.WorkheadImage.count == 0) {
            Num = 0;
        }
        _peopleCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0, [JGJGetViewFrame GetMaxY:self.NewsLable]-40,[UIScreen mainScreen].bounds.size.width, Num*100) collectionViewLayout:layout];

        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _peopleCollectionview.showsHorizontalScrollIndicator = NO;
        [_peopleCollectionview registerNib:[UINib nibWithNibName:@"JGJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"peopleCollectionindentFer1"];
        _peopleCollectionview.dataSource = self;
        _peopleCollectionview.delegate = self;
        _peopleCollectionview.backgroundColor = [UIColor clearColor];
        _peopleCollectionview.scrollEnabled = YES;
        _peopleCollectionview.pagingEnabled = YES;
        _peopleCollectionview.showsVerticalScrollIndicator = NO;
        _peopleCollectionview.bounces = NO;
        
    }
    return _peopleCollectionview;
    
}
-(UICollectionView *)headCollectionview
{
    if (!_headCollectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _headCollectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 15,[UIScreen mainScreen].bounds.size.width, [self HeadRowNumber]*50+20) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _headCollectionview.showsHorizontalScrollIndicator = NO;
        [_headCollectionview registerNib:[UINib nibWithNibName:@"JGJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"headCollectionindentFer1"];
        _headCollectionview.dataSource = self;
        _headCollectionview.delegate = self;
        _headCollectionview.tag = 10;
        _headCollectionview.backgroundColor = [UIColor clearColor];
        _headCollectionview.scrollEnabled = YES;
        _headCollectionview.pagingEnabled = YES;
        _headCollectionview.showsVerticalScrollIndicator = NO;
        _headCollectionview.bounces = NO;
        UILabel *departlb = [[UILabel alloc]initWithFrame:CGRectMake(0, [JGJGetViewFrame GetMaxY:_headCollectionview], MainScreen.width, 3)];
        departlb.backgroundColor = [UIColor redColor];
        [_headCollectionview addSubview:departlb];
    }
    
    return _headCollectionview;
    
}


-(UILabel *)FromLable
{
    
    if (!_FromLable) {
        _FromLable = [UILabel new];
        CGRect rect = CGRectMake(0, [JGJGetViewFrame GetMaxY:self.peopleCollectionview]+departHeight, MainScreen.width-10, 20);
        _FromLable.text = @"来自：白悦城项目组";
        _FromLable.textAlignment = rightalign;
        _FromLable.textColor =[UIColor darkGrayColor];
        _FromLable.font = [UIFont systemFontOfSize:14];
        [_FromLable setFrame:rect];
    }
    return _FromLable;
    
}
-(UILabel *)DepartLable
{
    if (!_DepartLable) {
        
        _DepartLable = [UILabel new];
        CGRect rect = CGRectMake(0, [JGJGetViewFrame GetMaxY:self.FromLable]+departHeight, MainScreen.width, 6);
        _DepartLable.textAlignment = rightalign;
        _DepartLable.backgroundColor = AppFontf1f1f1Color;
        _DepartLable.font = [UIFont systemFontOfSize:14];
        [_DepartLable setFrame:rect];
  
    }

    return _DepartLable;

}
#pragma mark -已收到人员的头像
-(void)hadReciveView
{
     _bottomview = [[[NSBundle mainBundle]loadNibNamed:@"HadReciveView" owner:nil options:nil]firstObject];
    CGRect rect = _bottomview.frame;
    [_bottomview setFrame:CGRectMake(rect.origin.x, [JGJGetViewFrame GetMaxY:self.DepartLable], rect.size.width, [self HeadRowNumber]*50+45)];
    
    [self addSubview:_bottomview];
    [_bottomview addSubview:self.headCollectionview];
    

}
-(UILabel *)NewsLable
{
    if (!_NewsLable) {
        _NewsLable = [[UILabel alloc] init];
            _NewsLable.font = [UIFont systemFontOfSize:14];
        NSString *str = @"1这是一个长满了百合花的峡谷。百合花静静地开放着，水边、坡上、岩石旁、大树下，到处都有。它们不疯不闹，也无鲜艳的颜色，仿佛它们开放着，也就是开放着，全无一点别的心思。峡谷上空的阳光是明亮的，甚至是强烈的，但因为峡谷太深，阳光仿佛要走过漫长的时间。因此，照进峡谷，照到这些百合花时，阳光已经变得柔和了，柔和得像薄薄的、轻盈得能飘动起来的雨幕。";
            _NewsLable.text = str;
            _NewsLable.backgroundColor = [UIColor clearColor];
            _NewsLable.numberOfLines = 0;
            _NewsLable.textColor = [UIColor darkTextColor];
            _NewsLable.lineBreakMode = NSLineBreakByTruncatingTail;
             CGSize maximumLabelSize = CGSizeMake(MainScreen.width-10, 3000);
             CGSize expectSize = [_NewsLable sizeThatFits:maximumLabelSize];
             _NewsLable.frame = CGRectMake(5, 30, expectSize.width, expectSize.height);
    }
    return _NewsLable;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 10) {
    return _HadreciveArray.count;
    }else{
    return self.WorkheadImage.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 10) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCollectionindentFer1" forIndexPath:indexPath];
      //已收到数据
        UIImageView *imageview = (UIImageView *)[cell viewWithTag:110];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = JGJCornerRadius;
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,_HadreciveArray[indexPath.row][@"head_pic"]]]];
//        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,_HadreciveArray[indexPath.row][@"head_pic"]]);
        return cell;

    }else{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peopleCollectionindentFer1" forIndexPath:indexPath];
    //测试数据
   UIImageView *imageview = (UIImageView *)[cell viewWithTag:110];
    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,_WorkheadImage[indexPath.row]]]];
       return cell;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 10) {
        
        return CGSizeMake(45, 50);
    }else{
        if (self.WorkheadImage.count == 0) {
            return CGSizeMake(0, 0);

        }else{
    return CGSizeMake((MainScreen.width-40)/3, (MainScreen.width-40)/3);
        }
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    
    return 1;
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 10) {
        return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);

    }else{
    return UIEdgeInsetsMake(2.0f, 10.0f, 5.0f, 10.0f);
}
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (collectionView.tag == 10) {
        
    }else{

        [JGJSclePhoto InitImageURL:@"http://api.ex.yzgong.com/v2/index/userhead?uid=100008576"];

    }
    

    if ([self.Tapdelegate respondsToSelector:@selector(tapPeopleDetailNewS:)]) {
        [self.Tapdelegate tapPeopleDetailNewS:_WorkheadImage[indexPath.row]];
    }


}
-(void)setWorkheadImage:(NSMutableArray *)WorkheadImage
{

    _WorkheadImage = WorkheadImage;

    [_peopleCollectionview reloadData];
}
-(NSInteger)RowNumber
{
    if (_WorkheadImage.count == 0) {
        return 0;
    }else{
    return _WorkheadImage.count/3+1;
    }
}
-(void)setHadreciveArray:(NSMutableArray *)HadreciveArray
{
    _HadreciveArray = [NSMutableArray array];
    _HadreciveArray = HadreciveArray;
    [_headCollectionview reloadData];


}

-(NSInteger)HeadRowNumber
{
    return self.HadreciveArray.count/3+1;
}
#pragma mark - 设置页面数据
-(void)setDetailModel:(JGJChatMsgListModel *)DetailModel
{
    [self addSubview:self.topView];
    [self addSubview:self.NewsLable];
    _NewsLable.text = DetailModel.msg_text;
    _FromLable.text = [NSString stringWithFormat:@"来自：%@" ,DetailModel.from_group_name];
    _WorkheadImage = [NSArray array];
    _WorkheadImage = DetailModel.msg_src;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl,DetailModel.head_pic]]];
    [self addSubview:self.FromLable];
    [self addSubview:self.DepartLable];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapHeadImage)];
            [_headImageView addGestureRecognizer:tap];

    [self hadReciveView];
    
    _NameLable.text = DetailModel.from_group_name;
    _TimeLable.text = DetailModel.date;
    [self addSubview:self.peopleCollectionview];
    [_peopleCollectionview reloadData];
    [self HadRecivemasgID:DetailModel.msg_id];
    _DetailModel = DetailModel;


}

-(void)HadRecivemasgID:(NSString *)msg_id{

    
    NSDictionary *body = @{
                           @"ctrl" : @"Team",
                           @"action": @"getReplyList",
                           @"msg_id":msg_id
                           };
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        array = responseObject;
        
    } failure:^(NSError *error, id values) {
    
    } showHub:NO];
    


}
 -(float)getHight
{


    return _DepartLable.frame.origin.y+[self HeadRowNumber]*50+45;

}
-(void)TapHeadImage
{

 [JGJSclePhoto InitImageURL:_DetailModel.head_pic];



}

@end
