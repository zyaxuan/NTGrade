//
//  GradeInfo.h
//  NTGrade
//
//  Created by Jonny on 2019/3/11.
//  Copyright © 2019 sports8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GradeInfo : NSObject

@property (nonatomic, copy) NSString * level;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * image;

@property (nonatomic, copy) NSString * angle;

@property (nonatomic, assign) NSInteger min;

@property (nonatomic, assign) NSInteger max;

@property (nonatomic, strong) UIImageView * iconImage;

/**
 *  初始化
 *
 *  @param dictionary data字典
 *
 *  @return topicModel
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
/**
 *  类方法初始化
 *
 *  @param dictionary data字典
 *
 *  @return topicModel
 */
+(id)gradeInfoWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
