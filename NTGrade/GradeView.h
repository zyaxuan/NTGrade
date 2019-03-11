//
//  GradeView.h
//  NTGrade
//
//  Created by Jonny on 2019/3/11.
//  Copyright © 2019 sports8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeInfo.h"

#define  kScreenWidth                           [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight                          [UIScreen mainScreen].bounds.size.height
NS_ASSUME_NONNULL_BEGIN

@interface GradeView : UIView

@property (nonatomic, copy) void (^gradeViewSelectBlock)(GradeInfo *gradeInfo);

@end

NS_ASSUME_NONNULL_END
