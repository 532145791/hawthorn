//
//  MeTableViewCell.h
//  BaseProject
//
//  Created by super on 2019/10/17.
//  Copyright © 2019 lengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeTableViewCell : UITableViewCell
@property (nonatomic , copy) NSString *iconName;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *subtitle;
@property (nonatomic , assign) BOOL isHiddenArrowIcon;
@end

NS_ASSUME_NONNULL_END
