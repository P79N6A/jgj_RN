//
//  JLGPhoneCollection.m
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGPhoneCollection.h"
#import "UIButton+WebCache.h"
#import "JLGPhoneCollectionViewCell.h"
#import "JLGProjectCollectionViewCell.h"

#define JLGPhoneImageMarginValue 2

@interface JLGPhoneCollection ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    JLGPhoneCollectionViewCellDelegate
>
@property (nonatomic,assign) CGFloat cellWitdh;
@property (nonatomic,assign) NSUInteger imageNum;//图片数量
@property (nonatomic,assign) NSInteger lineMaxNum;//每行的图片数
@property (nonatomic,assign) CGFloat JLGPhoneImageH;//collection的高度
@property (nonatomic,assign) CGFloat JLGPhoneImageW;//collection的宽度
@property (copy, nonatomic) NSString *identifierStr;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;
@property (nonatomic,assign) BOOL isGetHeight;
@end

@implementation JLGPhoneCollection

- (void)getHeightWithImagesArray:(NSArray *)imagesArray byLineMaxNum:(NSInteger )lineMaxNum width:(CGFloat)width
{
    if (self) {
        self.isGetHeight = YES;
        self.cellWitdh = width;
        self.lineMaxNum = lineMaxNum;//一定要先设置LineNum
        self.imagesArray = [imagesArray mutableCopy];
    }
}

- (void)initByImagesArray:(NSArray *)imagesArray byLineMaxNum:(NSInteger )lineMaxNum width:(CGFloat)width
{
    if (self) {
        self.isGetHeight = NO;
        self.cellWitdh = width;
        self.lineMaxNum = lineMaxNum;//一定要先设置LineNum
        
        [self getPhoneSize];
        
        self.imagesArray = [imagesArray mutableCopy];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:@"JLGPhoneCollection" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    [self registerNib];
}

//注册collectionCell
- (void)registerNib{
    //设置collectionView
    if (self.imagesCollection.delegate == nil) {
        self.imagesCollection.delegate = self;
    }
    
    if (self.imagesCollection.dataSource == nil) {
        self.imagesCollection.dataSource = self;
    }
    
    //注册一般显示的照片collection
    NSString *identifierStr = NSStringFromClass([JLGPhoneCollectionViewCell class]);
    UINib *nib = [UINib nibWithNibName:identifierStr
                                bundle: nil];
    [self.imagesCollection registerNib:nib forCellWithReuseIdentifier:identifierStr];
    
    
    //注册添加照片的collection
    identifierStr = NSStringFromClass([JLGProjectCollectionViewCell class]);
    nib = [UINib nibWithNibName:identifierStr
                         bundle: [NSBundle mainBundle]];
    [self.imagesCollection registerNib:nib forCellWithReuseIdentifier:identifierStr];
    
    //注册空白的collection
    identifierStr = @"nilCollectionCell";
    [self.imagesCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifierStr];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.imagesCollection addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneTouch)]) {
        [self.delegate phoneTouch];
    }
}

- (void )dealloc{
    self.imagesCollection.delegate = nil;
    self.imagesCollection = nil;
}

- (void)setImagesArray:(NSMutableArray *)imagesArray{
    _imagesArray = imagesArray;

    NSInteger count = self.imagesArray.count;//图片总数
    count = count >=9?8:count;
    NSInteger rowCount = self.hiddenAddButton?((count - 1)/self.lineMaxNum + 1):(count/self.lineMaxNum + 1);
//    self.collectionViewH = rowCount*(self.JLGPhoneImageH + JLGPhoneImageMarginValue) + (rowCount == 1?12:0);
    self.collectionViewH = rowCount*(self.JLGPhoneImageH + JLGPhoneImageMarginValue) +  12;

    if (!self.isGetHeight) {
        [self.imagesCollection reloadData];
    }
}

- (void)setLineMaxNum:(NSInteger)lineMaxNum{
    _lineMaxNum = lineMaxNum;
    [self getPhoneSize];
}

- (void)getPhoneSize{
    if (!self.lineMaxNum) {
        self.lineMaxNum = 3;
    }
    
    self.JLGPhoneImageH = ceil((self.cellWitdh - (self.lineMaxNum + 1)*JLGPhoneImageMarginValue)/self.lineMaxNum);
    self.JLGPhoneImageW = self.JLGPhoneImageH;
}

#pragma mark - collection的delegate
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return JLGPhoneImageMarginValue;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return JLGPhoneImageMarginValue;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.imagesArray.count?(self.imagesArray.count + 1):1;
    count = count >= 10 ?9:count;
    
    return count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.JLGPhoneImageH,self.JLGPhoneImageW - 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row != self.imagesArray.count)&&indexPath.row <= 8) {//只能有9张图片
        JLGPhoneCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JLGPhoneCollectionViewCell class]) forIndexPath:indexPath];
        
        collectionCell.indexPath = indexPath;
        if ([self.imagesArray[indexPath.row] isKindOfClass:[NSString class]]) {
            NSString *url = [JLGHttpRequest_Public stringByAppendingString:self.imagesArray[indexPath.row]];
            collectionCell.picUrl = url;
        }else{
            collectionCell.backImage = self.imagesArray[indexPath.row];
        }
        
        collectionCell.showDeleteButton = self.showDeleteButton;
        
        if (!collectionCell.delegate) {
            collectionCell.delegate = self;
        }
        
        return collectionCell;
    }else{
        if (self.hiddenAddButton) {//显示空白的
            UICollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nilCollectionCell" forIndexPath:indexPath];
            return collectionCell;
        }
        
        JLGProjectCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JLGProjectCollectionViewCell class]) forIndexPath:indexPath];
        [collectionCell.backButton sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        return collectionCell;
    }
    
}

#pragma mark - 点击了collection
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hiddenAddButton && indexPath.row == self.imagesArray.count) {//显示空白的
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(phoneDidSelected:index:)]) {
        [self.delegate phoneDidSelected:self index:indexPath.row];
    }
}


#pragma mark - 点击了每个图片的删除按钮
- (void)deleteBtnClick:(JLGPhoneCollectionViewCell *)phoneCollectionCell{
    //删除以后就重新刷新
    NSInteger deletePicIndex = phoneCollectionCell.indexPath.row;
    //如果是字符串，说明是Url
    if ([self.imagesArray[deletePicIndex] isKindOfClass:[NSString class]]) {
        [self.deleteImgsArray addObject:self.imagesArray[deletePicIndex]];
    }

#pragma mark - 添加删除图片后多余空白没有刷新
    NSInteger count = self.imagesArray.count;//图片总数
    count = count >=9?8:count;
    NSInteger rowCount = self.hiddenAddButton?((count - 1)/self.lineMaxNum + 1):(count/self.lineMaxNum + 1);
    self.collectionViewH = rowCount*(self.JLGPhoneImageH + JLGPhoneImageMarginValue) +  12;
//    [TYNotificationCenter postNotificationName:@"freashImage" object:nil];
//上面这块代码时候来添加的
    
    
    
    [self.imagesArray removeObjectAtIndex:deletePicIndex];
    [self.imagesCollection reloadData];
    
    if ([self.delegate respondsToSelector:@selector(phoneDelete:index:)]) {
        [self.delegate phoneDelete:self index:deletePicIndex];
    }
}

- (NSMutableArray *)deleteImgsArray
{
    if (!_deleteImgsArray) {
        _deleteImgsArray = [[NSMutableArray alloc] init];
    }
    return _deleteImgsArray;
}

@end
