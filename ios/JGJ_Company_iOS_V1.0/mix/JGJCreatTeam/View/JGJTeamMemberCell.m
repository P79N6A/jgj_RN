//
//  JGJTeamMemberCell.m
//  mix
//
//  Created by yj on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTeamMemberCell.h"
#import "JGJTeamMemberHeaderReusableView.h"
#import "JGJTeamMemberCollectionViewCell.h"

#import "JGJProSetMemberHeaderReusableView.h"

#import "JGJCheckPlanCollectionHeaderView.h"

static NSString *const TeamMemberCollectionViewCellID = @"JGJTeamMemberCollectionViewCell";

static NSString * const HeaderID = @"JGJTeamMemberHeaderReusableView";

static NSString * const MemberHeaderID = @"JGJProSetMemberHeaderReusableView";

static NSString * const CheckPlanHeaderID = @"JGJCheckPlanCollectionHeaderView";

@interface JGJTeamMemberCell () <UICollectionViewDelegate, UICollectionViewDataSource, JGJTeamMemberCollectionViewCellDelegate, JGJProSetMemberHeaderReusableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation JGJTeamMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonSet];
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *TeamMemberCellID = @"Cell";
    JGJTeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamMemberCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJTeamMemberCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)commonSet {
    self.collectionViewLayout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
    
    CGFloat padding = TYIST_IPHONE_X ? 10 : LinePadding;
    
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
    
    self.collectionViewLayout.headerReferenceSize = CGSizeMake(TYGetUIScreenWidth, HeaderHegiht);
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    self.collectionViewLayout.minimumLineSpacing = 0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJTeamMemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:TeamMemberCollectionViewCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJTeamMemberHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJProSetMemberHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MemberHeaderID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JGJCheckPlanCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CheckPlanHeaderID];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (self.memberFlagType) {
        case ShowAddTeamMemberFlagType: {
            count = self.teamMemberModels.count == 0 ? 1 : self.teamMemberModels.count;
        }
            break;
        case ShowAddAndRemoveTeamMemberFlagType: {
            count = self.teamMemberModels.count == 0 ? 2 : self.teamMemberModels.count;
        }
            break;
        case DefaultTeamMemberFlagType: {
            count = self.teamMemberModels.count;
        }
            break;
        default:
            break;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJTeamMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeamMemberCollectionViewCellID forIndexPath:indexPath];
    cell.memberFlagType = self.memberFlagType;
    cell.delegate = self;
    cell.commonModel = self.commonModel; //这里是先全部隐藏删除按钮，再处理单独的添加的和删除上面的删除按钮标记
    
    if (self.teamMemberModels.count > 0) {
         cell.teamMemberModel = self.teamMemberModels[indexPath.row];   
    }
    
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    //    点击判断是不是我们平台成员弹框
    
    if (self.teamMemberModels.count > 0) {
        
        JGJSynBillingModel *teamMemberModel= self.teamMemberModels[indexPath.row];
        
        self.commonModel.teamModelModel = teamMemberModel;
        
        if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellUnRegisterTeamModel:)] && !teamMemberModel.isMangerModel) {
            
            [self.delegate handleJGJTeamMemberCellUnRegisterTeamModel:self.commonModel];
            
        }else if (teamMemberModel.isAddModel) {
            
            //    项目组使用
            if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellAddMember:)]) {
                
                [self.delegate handleJGJTeamMemberCellAddMember:self.commonModel];
                
            }
            
        }else if (teamMemberModel.isRemoveModel) {
            
            //    项目组使用
            if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellRemoveMember:)]) {
                
                [self.delegate handleJGJTeamMemberCellRemoveMember:self.commonModel];
                
            }
            
        }
        
        //创建班组使用
        if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellRemoveIndividualTeamMember:)] && !teamMemberModel.isMangerModel) {
            
            [self.delegate handleJGJTeamMemberCellRemoveIndividualTeamMember:teamMemberModel];
        }
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    //检查计划隐藏头部，这里只是调整顶部间隔
    if (self.isCheckPlanHeader && kind == UICollectionElementKindSectionHeader) {
        
        JGJCheckPlanCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CheckPlanHeaderID forIndexPath:indexPath];
        
        reusableview = headerView;
        
    }else  if (kind == UICollectionElementKindSectionHeader && self.commonModel.memberType == JGJProMemberType) {
        
        JGJProSetMemberHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MemberHeaderID forIndexPath:indexPath];
        
        headerView.delegate = self;
        
        headerView.teamInfo = self.teamInfo;
        
        reusableview = headerView;
        
        //3.3.4隐藏项目设置成员统计
        headerView.hidden = self.commonModel.teamControllerType == JGJTeamMangerControllerType;
        
        if (self.commonModel.teamControllerType == JGJTeamMangerControllerType) {
            
            self.collectionViewLayout.headerReferenceSize = CGSizeMake(TYGetUIScreenWidth, HeaderHegiht / 2.0);
        }
        
    }else if (kind == UICollectionElementKindSectionHeader) {
        
        JGJTeamMemberHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderID forIndexPath:indexPath];
        
        headerView.backgroundColor = self.commonModel.headerTitleColor;
        
        headerView.commonModel = self.commonModel;
        
        //        headerView.lineView.hidden = YES;
        
        reusableview = headerView;
    }
    

    

    return reusableview;
}

#pragma mark - JGJTeamMemberCollectionViewCellDelegate
//添加成员
- (void)handleJGJTeamMemberCollectionViewCellAddTeamMember:(JGJSynBillingModel *)teamMemberModel {
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellAddTeamMember:)]) {
        [self.delegate handleJGJTeamMemberCellAddTeamMember:self];
    }

}
//移除多个
- (void)handleJGJTeamMemberCollectionViewCellRemoveTeamMember:(NSMutableArray *)teamMemberModels {
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellRemoveTeamMember:)]) {
        [self.delegate handleJGJTeamMemberCellRemoveTeamMember:self.teamMemberModels];
    }
    
}
//移除单个
- (void)handleJGJRemoveIndividualTeamModel:(JGJSynBillingModel *)teamMemberModel {
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellRemoveIndividualTeamMember:)]) {
        [self.delegate handleJGJTeamMemberCellRemoveIndividualTeamMember:teamMemberModel];
    }
}

//不是我们平台成员弹框
- (void)handleJGJUnRegisterTeamModel:(JGJTeamMemberCommonModel *)commonModel {
    if ([self.delegate respondsToSelector:@selector(handleJGJTeamMemberCellUnRegisterTeamModel:)]) {
        [self.delegate handleJGJTeamMemberCellUnRegisterTeamModel:commonModel];
    }
}

#pragma mark - 升级按下
- (void)proSetMemberHeaderReusableView:(JGJProSetMemberHeaderReusableView *)headerView {

    if ([self.delegate respondsToSelector:@selector(handleUpgradeActionWithCell:)]) {
        
        [self.delegate handleUpgradeActionWithCell:self];
        
    }
}

- (void)setIsCheckPlanHeader:(BOOL)isCheckPlanHeader {
    
    _isCheckPlanHeader = isCheckPlanHeader;
    
    if (_isCheckPlanHeader) {
        
        self.collectionViewLayout.headerReferenceSize = CGSizeMake(TYGetUIScreenWidth, CheckPlanHeaderHegiht);
    }
}


#pragma mark - 计算班组成员高度
+ (CGFloat)calculateCollectiveViewHeight:(NSArray *)dataSource headerHeight:(CGFloat)headerHeight {
    
    NSInteger lineCount = 0;
    
    NSUInteger teamMemberCount = dataSource.count;
    
    if (teamMemberCount == 0) {
        
        teamMemberCount = 1;
    }
    
    CGFloat padding = 15;
    
    lineCount = ((teamMemberCount / MemberRowNum) + (teamMemberCount % MemberRowNum != 0 ? 1 : 0));
    
    CGFloat collectionViewHeight = lineCount * ItemHeight + headerHeight + padding;
    
    return collectionViewHeight;
}

#pragma mark - 根据条件类型返回添加和删除模型
+ (NSMutableArray *)accordTypeGetMangerModels:(MemberFlagType)flagType{

    NSArray *picNames = @[@"menber_add_icon", @"member_ minus_icon"];
    
    NSArray *titles = @[@"添加", @"删除"];
    
    NSMutableArray *dataSource = [NSMutableArray array];
    
    NSInteger count = 0;
    
    if (flagType == ShowAddAndRemoveTeamMemberFlagType) {
        
        count = 2;
        
    }else if (flagType == ShowAddTeamMemberFlagType) {
        
        count = 1;
    }
    
    for (int idx = 0; idx < count; idx ++) {
        
        JGJSynBillingModel *memberModel = [[JGJSynBillingModel alloc] init];
        
        memberModel.isMangerModel = YES;
        
        if (idx == 0) {
            
            memberModel.addHeadPic = picNames[0];
            
            memberModel.isAddModel = YES;
            
        }
        
        if (idx == 1) {
            
            memberModel.removeHeadPic = picNames[1];
            
            memberModel.isRemoveModel = YES;
            
        }
        
        memberModel.name = titles[idx];
        
        [dataSource addObject:memberModel];
    }
    return dataSource;
}

- (JGJTeamMemberCommonModel *)commonModel {
    
    if (!_commonModel) {
        
        _commonModel = [JGJTeamMemberCommonModel new];
    }
    
    return _commonModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
