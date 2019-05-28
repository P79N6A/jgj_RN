//
//  JGJWeatherPickerview.m
//  mix
//
//  Created by Tony on 2017/3/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWeatherPickerview.h"
#import "JGJweatherCollectionViewCell.h"
#import "JGJpacketNumCollectionViewCell.h"
#import "JGJQuanQCollectionViewCell.h"
@interface JGJWeatherPickerview()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    NSMutableArray *selectArr;
    NSMutableArray *indexpathArr;
    JGJQuanQCollectionViewCell *quanqcell;
    NSIndexPath *slectIndexpath;
}

@end
@implementation JGJWeatherPickerview
-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andHadseledArr:(NSMutableArray *)Arr
{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionview];
        
        [self addSubview:self.topView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionview];

        [self addSubview:self.topView];
        [TYNotificationCenter addObserver:self selector:@selector(removeview) name:@"dissMissWeatherPicker" object:nil];

    }
    return self;
}
-(void)showWeatherPickerView
{
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.placeView];


  
    
    if (_Nshadow) {
        _placeView.alpha = 0;
    }
    [_topView addSubview:self.cancelButton];
    [_topView addSubview:self.surebutton];
    if (_Nshadow) {
        [self.cancelButton setTitle:@"清空重选" forState:UIControlStateNormal];
        [self.surebutton setTitle:@"关闭" forState:UIControlStateNormal];

    }
    [UIView animateWithDuration:.3 animations:^{
        [[[UIApplication sharedApplication]keyWindow]addSubview:self];
        _topView.transform = CGAffineTransformMakeTranslation(0, -250);
        _collectionview.transform = CGAffineTransformMakeTranslation(0, -250);
    }];
}
-(UIView *)placeView
{
    if (!_placeView) {
        _placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _placeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeview)];
        [_placeView addGestureRecognizer:tap];
    }
    return _placeView;
}
-(void)removeview
{
    
    if (_placeView) {
        [UIView animateWithDuration:.4 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.frame));
        }completion:^(BOOL finished) {
            [_placeView removeFromSuperview];
            _placeView = nil;
            [self removeFromSuperview];
        }];
 
    }
    
    _selLable.backgroundColor = AppFontfafafaColor;
    
}
- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 5, 80, 35)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(clicktopButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)surebutton
{
    if (!_surebutton) {
        _surebutton =  [[UIButton alloc]initWithFrame:CGRectMake(TYGetUIScreenWidth - 70, 5, 60, 35)];
        [_surebutton setTitle:@"确定" forState:UIControlStateNormal];
        _surebutton.titleLabel.font = [UIFont systemFontOfSize:16];

        [_surebutton addTarget:self action:@selector(clicktopButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surebutton;
}
-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, TYGetUIScreenWidth, 45)];
//        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 45)];

        _topView.backgroundColor = JGJMainColor;
        [_topView addSubview:self.toplable];
        if (_showCancel) {
            [_topView addSubview:self.cancelButton];
            [_topView addSubview:self.surebutton];
        }
    }
    return _topView;
}
- (UILabel *)toplable
{
    if (!_toplable) {
        _toplable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, TYGetUIScreenWidth, 30)];
        _toplable.textAlignment = NSTextAlignmentCenter;
        _toplable.textColor = AppFontffffffColor;
        _toplable.font = [UIFont systemFontOfSize:16];
        
    }
    return _toplable;
}
-(void)setTopname:(NSString *)topname
{
    _toplable.text = topname;

}
-(UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0,295,[UIScreen mainScreen].bounds.size.width, 250) collectionViewLayout:layout];
//        _collectionview =[[UICollectionView alloc]initWithFrame:CGRectMake(0,45,[UIScreen mainScreen].bounds.size.width, 250) collectionViewLayout:layout];

//        _collectionview.allowsMultipleSelection = YES;

        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [_collectionview registerNib:[UINib nibWithNibName:@"JGJweatherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"weatherCollectionViewCell"];
        [_collectionview registerNib:[UINib nibWithNibName:@"JGJpacketNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"packetNumCollectionViewCell"];
        [_collectionview registerNib:[UINib nibWithNibName:@"JGJQuanQCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JGJQuanQCollectionViewCel"];

        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.scrollEnabled = YES;
        _collectionview.showsVerticalScrollIndicator = NO;
        
    }

    return _collectionview;
}
-(void)setAllowsMultipleSelections:(BOOL)allowsMultipleSelections
{
    _allowsMultipleSelections =allowsMultipleSelections;
//    self.collectionview.allowsMultipleSelection = allowsMultipleSelections;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //头部
        if (_classmodel == JGJPacknumPickermodel) {
        JGJpacketNumCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"packetNumCollectionViewCell" forIndexPath:indexPath];
        cell.detaillable.text = _titlearray[indexPath.row];
        return cell;

        }else{
            if (_showCancel) {
                quanqcell =[collectionView dequeueReusableCellWithReuseIdentifier:@"JGJQuanQCollectionViewCel" forIndexPath:indexPath];
                if (_imagarray.count) {
                    quanqcell.imageview.image = [UIImage imageNamed:_imagarray[indexPath.row]];
                }
                if (_titlearray.count) {
                    quanqcell.detailLable.text = _titlearray[indexPath.row];
                }
                quanqcell.detailLable.backgroundColor = [UIColor whiteColor];
                

                return quanqcell;

            }else{
        JGJweatherCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"weatherCollectionViewCell" forIndexPath:indexPath];
        if (_imagarray.count) {
            cell.imageview.image = [UIImage imageNamed:_imagarray[indexPath.row]];
        }
        if (_titlearray.count) {
            cell.detaillable.text = _titlearray[indexPath.row];
        }
        cell.detaillable.backgroundColor = [UIColor whiteColor];
        return cell;
            }
        
    }
    }
    return 0;
    
}
-(void)setTitlearray:(NSMutableArray *)titlearray
{
    _titlearray = [[NSMutableArray alloc]init];
    _titlearray = titlearray;
    [_collectionview reloadData];

}

-(void)setImagarray:(NSMutableArray *)imagarray
{
    _imagarray = [[NSMutableArray alloc]init];
    _imagarray = imagarray;
    [_collectionview reloadData];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_classmodel == JGJPacknumPickermodel) {
        return _titlearray.count;
    }
    if (_imagarray.count) {
    
        return _imagarray.count;
}else if (_titlearray.count)
{

    return _titlearray.count;
}
       return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_showCancel) {
        return CGSizeMake((TYGetUIScreenWidth - 50) / 5, 73);
    }
    if (_classmodel == JGJPacknumPickermodel) {
        return CGSizeMake((TYGetUIScreenWidth - 100) / 4, 58);
    }

    return CGSizeMake(50, 58);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    if (_showCancel) {
         return UIEdgeInsetsMake(10.0f,5, 0.0f,0);
    }
    if (_classmodel == JGJPacknumPickermodel) {
        return UIEdgeInsetsMake(10.0f,10, 0.0f, 10);

    }
         return UIEdgeInsetsMake(10.0f,(TYGetUIScreenWidth - 250)/3.9, 0.0f, (TYGetUIScreenWidth - 250)/3.9);
}
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (selectArr.count >= 4 && _showCancel) {
//        return NO;
//    }
//    return YES;
//}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_allowsMultipleSelections) {

    UICollectionViewCell *cell = [_collectionview cellForItemAtIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 2;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth = 1;
        
    [selectArr removeObject:_titlearray[indexPath.row]];
        [indexpathArr removeObject:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didMoreselectweaterevent:andArr: andDelete:)]) {
            [self.delegate didMoreselectweaterevent:indexPath andArr:selectArr andDelete:[_titlearray[indexPath.row] isEqualToString:@"不选"]?1:0];
        }
        return YES;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    slectIndexpath = indexPath;
    //多选
    if (_showCancel) {
        //发施工日志的晴雨表选择
        if (!selectArr) {
            selectArr = [NSMutableArray array];
            
        }
        if (!indexpathArr) {
            indexpathArr = [NSMutableArray array];
        }
        if ([_titlearray[indexPath.row] isEqualToString:@"不选"]) {
            
        }else{
            
            if ([indexpathArr containsObject:indexPath]) {
                
                if (selectArr.count < 2) {
                    
                    [indexpathArr addObject:indexPath];
                    [selectArr addObject:_titlearray[indexPath.row]];
                    
                }
                
                for (int i = 0; i < indexpathArr.count; i ++) {
                    
                    NSIndexPath *newIndexPath = indexpathArr[i];
                    JGJQuanQCollectionViewCell *cell = (JGJQuanQCollectionViewCell *)[_collectionview cellForItemAtIndexPath:newIndexPath];
                    cell.baseView.layer.masksToBounds = YES;
                    cell.baseView.layer.cornerRadius = 2;
                    cell.baseView.layer.borderColor = AppFontccccccColor.CGColor;
                    cell.baseView.backgroundColor = AppFontfafafaColor;
                    cell.baseView.layer.borderWidth = 1;
                    cell.QuanLable.hidden = NO;
                    cell.QuanLable.text = [NSString stringWithFormat:@"%d",i + 1];
                }
                
            }else{
                
                [indexpathArr addObject:indexPath];
                [selectArr addObject:_titlearray[indexPath.row]];
                
                if (indexpathArr.count > 2) {
                    
                    JGJQuanQCollectionViewCell *cell = (JGJQuanQCollectionViewCell *)[_collectionview cellForItemAtIndexPath:indexpathArr.firstObject];
                    cell.QuanLable.hidden = YES;
                    cell.baseView.layer.masksToBounds = YES;
                    cell.baseView.layer.cornerRadius = 2;
                    cell.baseView.layer.borderColor = [UIColor whiteColor].CGColor;
                    cell.baseView.backgroundColor = [UIColor whiteColor];
                    cell.baseView.layer.borderWidth = 1;
                    [selectArr removeObjectAtIndex:0];
                    [indexpathArr removeObjectAtIndex:0];
                    
                }
                
                for (int i = 0; i < indexpathArr.count; i ++) {
                    
                    NSIndexPath *newIndexPath = indexpathArr[i];
                    JGJQuanQCollectionViewCell *cell = (JGJQuanQCollectionViewCell *)[_collectionview cellForItemAtIndexPath:newIndexPath];
                    cell.baseView.layer.masksToBounds = YES;
                    cell.baseView.layer.cornerRadius = 2;
                    cell.baseView.layer.borderColor = AppFontccccccColor.CGColor;
                    cell.baseView.backgroundColor = AppFontfafafaColor;
                    cell.baseView.layer.borderWidth = 1;
                    cell.QuanLable.hidden = NO;
                    cell.QuanLable.text = [NSString stringWithFormat:@"%d",i + 1];
                }
                
                
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didMoreselectweaterevent:andArr: andDelete:)]) {
            
            [self.delegate didMoreselectweaterevent:indexPath andArr:selectArr andDelete:[_titlearray[indexPath.row] isEqualToString:@"不选"]?1:0];
        }
        
    }else{
        
        if (_allowsMultipleSelections) {
            
            if (!selectArr) {
                
                selectArr = [NSMutableArray array];
            }
            
            if ([_titlearray[indexPath.row] isEqualToString:@"不选"]) {
                
            }else{
                [selectArr addObject:_titlearray[indexPath.row]];
                
                
                if (!_Nshadow) {
                    
                    UICollectionViewCell *cell = [_collectionview cellForItemAtIndexPath:indexPath];
                    
                    cell.layer.masksToBounds = YES;
                    cell.layer.cornerRadius = 2;
                    cell.layer.borderColor = AppFontccccccColor.CGColor;
                    cell.backgroundColor = AppFontfafafaColor;
                    cell.layer.borderWidth = 1;
                    
                    if (selectArr.count ==4) {
                        
                        [self removeview];
                    }
                }
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didMoreselectweaterevent:andArr: andDelete:)]) {
                
                [self.delegate didMoreselectweaterevent:indexPath andArr:selectArr andDelete:[_titlearray[indexPath.row] isEqualToString:@"不选"]?1:0];
                
            }
            
        }else{
            
            //单选
            for (UICollectionViewCell *cell in _collectionview.visibleCells) {
                
                if (!cell.selected) {
                    
                    cell.layer.borderColor = [UIColor whiteColor].CGColor;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    cell.layer.borderWidth = 1;
                    
                }else{
                    
                    UICollectionViewCell *cell = [_collectionview cellForItemAtIndexPath:indexPath];
                    cell.layer.masksToBounds = YES;
                    cell.layer.cornerRadius = 2;
                    cell.layer.borderColor = AppFontccccccColor.CGColor;
                    cell.backgroundColor = AppFontfafafaColor;
                    cell.layer.borderWidth = 1;
                    
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(didselectweaterevent: andstr:)]) {
                
                if (_titlearray.count >= indexPath.row) {
                    
                    [self.delegate didselectweaterevent:indexPath andstr:_titlearray[indexPath.row]];
                    
                }else{
                    
                    [self.delegate didselectweaterevent:indexPath andstr:@""];
                }
            }
            
            [self removeview];
        }
        
    }

}
#pragma mark -点击取消确定按钮
- (void)clicktopButton:(UIButton *)button
{
    if (_Nshadow && [button.titleLabel.text isEqualToString:@"清空重选"]) {
        if (slectIndexpath) {
            
       [self.delegate cleanrRainCalender];
            
        }
        

        selectArr = [[NSMutableArray alloc]init];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTopbutton:)]) {
        [self.delegate clickTopbutton:button.titleLabel.text];
    }
    
    if (![button.titleLabel.text isEqualToString:@"清空重选"]) {
        [self removeview];
        
    }

}
-(void)initCollectionviewCellLayer:(UICollectionViewCell *)cell initlayerColor:(UIColor *)color
{


}


@end
