//
//  HomepageTableViewCell.h
//  BaseProject
//
//  Created by super on 2020/3/5.
//  Copyright © 2020 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomepageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomepageAgeView : UIView
@property (nonatomic , assign) BOOL isMale;
@property (nonatomic , copy) NSString *age;
@end

@interface HomepageTableViewCell : UITableViewCell
@property (nonatomic , assign) BOOL isMale;
@property (nonatomic , copy) NSString *age;
@property (nonatomic , strong) HomepageItemModel *model;
@end

NS_ASSUME_NONNULL_END
