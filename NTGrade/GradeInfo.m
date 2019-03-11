//
//  GradeInfo.m
//  NTGrade
//
//  Created by Jonny on 2019/3/11.
//  Copyright © 2019 sports8. All rights reserved.
//

#import "GradeInfo.h"

@implementation GradeInfo


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _level = [self stringFromObject:dictionary[@"level"]];
        _name = [self stringFromObject:dictionary[@"name"]];
        _image = [self stringFromObject:dictionary[@"image"]];
        _angle = [self stringFromObject:dictionary[@"angle"]];
        _min = [self stringFromObject:dictionary[@"min"]].integerValue;
        _max = [self stringFromObject:dictionary[@"max"]].integerValue;
    
        
    }
    return self;
}
+(id)gradeInfoWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}


- (NSString *)stringFromObject:(id)obj
{
    if ([obj isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@",obj];
    }
    
    return @"";
}

@end
