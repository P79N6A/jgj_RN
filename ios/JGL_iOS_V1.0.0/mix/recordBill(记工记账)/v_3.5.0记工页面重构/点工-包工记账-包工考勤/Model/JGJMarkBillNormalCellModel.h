//
//  JGJMarkBillNormalCellModel.h
//  mix
//
//  Created by Tony on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJMarkBillNormalCellModel : NSObject

@property (nonatomic, copy) NSString *image_name;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *detail_content;
@property (nonatomic, assign) BOOL isEmpty;

@end
