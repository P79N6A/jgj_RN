//
//  UIImage+TYALAssetsLib.m
//  TYSamples
//
//  Created by Tony on 2016/7/15.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "UIImage+TYALAssetsLib.h"
#import <objc/runtime.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

static const void *TYALAssetsLibCompleteBlockKey = &TYALAssetsLibCompleteBlockKey;
static const void *TYALAssetsLibFailureBlockKey = &TYALAssetsLibFailureBlockKey;

@interface UIImage ()

@property (nonatomic,copy)  void(^TYALAssetsLibCompleteBlock)();

@property (nonatomic,copy)  void(^TYALAssetsLibFailureBlock)();

@end

@implementation UIImage (TYALAssetsLib)

/*
 *  添加block
 */
-(void (^)())TYALAssetsLibFailureBlock{
    return objc_getAssociatedObject(self, TYALAssetsLibFailureBlockKey);
}
-(void)setTYALAssetsLibFailureBlock:(void (^)())TYALAssetsLibFailureBlock{
    objc_setAssociatedObject(self, TYALAssetsLibFailureBlockKey, TYALAssetsLibFailureBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^)())TYALAssetsLibCompleteBlock{
    return objc_getAssociatedObject(self, TYALAssetsLibCompleteBlockKey);
}

-(void)setTYALAssetsLibCompleteBlock:(void (^)())TYALAssetsLibCompleteBlock{
    objc_setAssociatedObject(self, TYALAssetsLibCompleteBlockKey, TYALAssetsLibCompleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 保存图片到相册
- (void)saveToAlbum:(NSString *)albumName
    completionBlock:(void (^)(void))completionBlock
       failureBlock:(void (^)(NSError *error))failureBlock{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (TYiOS9Later) {
            [self saveToAlbumiOS9Later:albumName completionBlock:completionBlock failureBlock:failureBlock];
        }else{
            [self saveToAlbumiOS9Before:albumName completionBlock:completionBlock failureBlock:failureBlock];
        }
    });
}


- (void)saveToAlbumiOS9Later:(NSString *)albumName
    completionBlock:(void (^)(void))completionBlock
       failureBlock:(void (^)(NSError *error))failureBlock{
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                TYLog(@"保存失败 error = %@",error);
                if(failureBlock != nil) failureBlock(error);
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self getAssetCollection:albumName];
            if (collection == nil) return;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                TYLog(@"保存失败 error = %@",error);
                if(failureBlock != nil) failureBlock(error);
            } else {
                TYLog(@"保存成功");
                if(completionBlock != nil) completionBlock();
            }
        });
    }];// 判断授权状态
}
#pragma mark - 保存图片到自定义相册
/**
 * 获得自定义的相册对象
 */
- (PHAssetCollection *)getAssetCollection:(NSString *)albumName
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            return collection;
        }
    }
    
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        TYLog(@"获取相册【%@】失败", albumName);
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}

#pragma mark 保存图片到相册
- (void)saveToAlbumiOS9Before:(NSString *)albumName
    completionBlock:(void (^)(void))completionBlock
       failureBlock:(void (^)(NSError *error))failureBlock{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            BOOL haveHDRGroup = NO;
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:albumName])
                {
                    haveHDRGroup = YES;
                }
            }
            if (!haveHDRGroup)
            {
                //如果没有，增加一个albumName
                [assetsLibrary addAssetsGroupAlbumWithName:albumName
                                               resultBlock:^(ALAssetsGroup *group)
                 {
                     if (group) {//创建成功了再保存
                          [groups addObject:group];
                     }
                 }
                failureBlock:^(NSError *error) {
                    TYLog(@"error = %@",error);
                }];
                
                haveHDRGroup = YES;
            }
        }
    };
    
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        TYLog(@"error = %@",error);
    }];

    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(self) customAlbumName:albumName completionBlock:^{
        TYLog(@"保存成功");
        if(completionBlock != nil) completionBlock();
     }
     failureBlock:^(NSError *error){
        TYLog(@"保存失败");
        if(failureBlock != nil) failureBlock(error);
     }];
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
    {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}
@end
