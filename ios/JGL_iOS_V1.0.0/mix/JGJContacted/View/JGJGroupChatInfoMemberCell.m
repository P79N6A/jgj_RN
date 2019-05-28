//
//  JGJGroupChatInfoMemberCell.m
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGroupChatInfoMemberCell.h"
#import "JGJGroupChatMemberCollectionViewCell.h"
static NSString *const JGJGroupChatMemberCollectionViewCellID = @"JGJGroupChatMemberCollectionViewCell";
@interface JGJGroupChatInfoMemberCell () <JGJGroupChatMemberCollectionViewCellDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@end
@implementation JGJGroupChatInfoMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSet];
}

- (void)commonSet {
    self.collectionViewLayout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    
    CGFloat padding = TYIST_IPHONE_X ? 10 : LinePadding;
    
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
    
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    
    self.collectionViewLayout.minimumLineSpacing = 0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJGroupChatMemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JGJGroupChatMemberCollectionViewCellID];
}

- (void)setMemberModels:(NSMutableArray *)memberModels {
    _memberModels = memberModels;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (self.memberFlagType) {
        case ShowAddTeamMemberFlagType: {
            count = self.memberModels.count == 0 ? 1 : self.memberModels.count;
        }
            break;
        case ShowAddAndRemoveTeamMemberFlagType: {
            count = self.memberModels.count == 0 ? 2 : self.memberModels.count;
        }
            break;
        case DefaultTeamMemberFlagType: {
            count = self.memberModels.count;
        }
            break;
        default:{
            count = self.memberModels.count;
        }
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJGroupChatMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JGJGroupChatMemberCollectionViewCellID forIndexPath:indexPath];
    JGJSynBillingModel *memberModel= self.memberModels[indexPath.row];
    cell.memberModel = memberModel;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JGJSynBillingModel *memberModel= self.memberModels[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(handleJGJGroupChatInfoMemberCell:commonModel:memberModel:)]) {
        [self.delegate handleJGJGroupChatInfoMemberCell:self commonModel:self.commonModel memberModel:memberModel];
    }
}

- (void)handleJGJGroupChatMemberCollectionViewCell:(JGJGroupChatMemberCollectionViewCell *)cell commonModel:(JGJTeamMemberCommonModel *)commonModel {
    if ([self.delegate respondsToSelector:@selector(handleJGJGroupChatMemberCollectionViewCell:commonModel:)]) {
        [self.delegate handleJGJGroupChatInfoMemberCell:self commonModel:commonModel memberModel:cell.memberModel];
    }
}

@end
