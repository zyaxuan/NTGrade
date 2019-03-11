//
//  GradeView.m
//  NTGrade
//
//  Created by Jonny on 2019/3/11.
//  Copyright © 2019 sports8. All rights reserved.
//

#import "GradeView.h"

@interface GradeView ()

@property (nonatomic, strong) UIImageView * bgImageView;

@property (nonatomic, strong) UIView * gradeView;

@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@property (nonatomic, strong) UIBezierPath * bezierPath;

//圆心
@property (nonatomic, assign) CGPoint centerPoint;
//半径
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) NSMutableArray * gradeArray;

@property (nonatomic, strong) NSMutableArray * gradeViewArray;


@property (nonatomic, strong) UISwipeGestureRecognizer * swipeRight;

@property (nonatomic, strong) UISwipeGestureRecognizer * swipeLeft;

@end

@implementation GradeView
#pragma mark - 懒加载
- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = self.bezierPath.CGPath;
        _shapeLayer.lineWidth = 3;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.6].CGColor;
    }
    return _shapeLayer;
}
-(UIBezierPath *)bezierPath
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint
                                                              radius:self.radius
                                                          startAngle:0
                                                            endAngle:M_PI
                                                           clockwise:YES];
    return bezierPath;
}

#pragma mark - initWithFrame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.13 green:0.58 blue:0.95 alpha:1.00];
        
        [self setupInitData];
        
        [self setupUI];
    }
    return self;
}

- (void) setupInitData
{
    self.gradeArray = [[NSMutableArray alloc] init];
    self.centerPoint = CGPointMake(kScreenWidth/2.f,  -90);
    self.radius = 400;
    
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"grade" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *array = result[@"data"];
    for (NSDictionary *dic in array) {
        GradeInfo *gradeInfo = [GradeInfo gradeInfoWithDictionary:dic];
        [self.gradeArray addObject:gradeInfo];
    }
}

#pragma mark - UI
- (void)setupUI
{
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView.layer addSublayer:self.shapeLayer];
    
    self.gradeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    [self addSubview:self.gradeView];
    
    
    //左滑 右划手势
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGest:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGest:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.gradeView addGestureRecognizer:swipeRight];
    [self.gradeView addGestureRecognizer:swipeLeft];
    self.swipeRight = swipeRight;
    self.swipeLeft = swipeLeft;
    
    
    self.gradeViewArray = [NSMutableArray array];
    for (int i = 0; i < self.gradeArray.count; i ++) {
        
        GradeInfo *info = self.gradeArray[i];
        CGFloat angle = info.angle.floatValue * M_PI;
        CGPoint point = CGPointMake(self.centerPoint.x + cos(angle) *(self.radius), self.centerPoint.y + sin(angle) *(self.radius));
//        CGPoint point2 = CGPointMake(point.x, self.centerPoint.y + sin(angle) *(self.radius+40));
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        iconImageView.userInteractionEnabled = YES;
        iconImageView.tag = i;
        iconImageView.image = [UIImage imageNamed:info.image];
        [iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipTap:)]];
        if ([info.angle isEqualToString:@"0.5"]) {
            iconImageView.bounds = CGRectMake(0, 0, 80, 80);
            iconImageView.center = point;
        }
        else{
            iconImageView.bounds = CGRectMake(0, 0, 60,  60);
        }
        iconImageView.center = point;
        [self.gradeView addSubview:iconImageView];
        
        info.iconImage = iconImageView;
        [self.gradeViewArray addObject:info];
        
        
    }
    
    [self masonrySubView];
}

#pragma mark - layout
- (void)masonrySubView
{
    
}

#pragma mark - Setter

#pragma mark - Selector

- (void)swipeGest:(UISwipeGestureRecognizer *)swipeGest{
    self.swipeLeft.enabled = NO;
    self.swipeRight.enabled = NO;
    if (swipeGest.direction == UISwipeGestureRecognizerDirectionRight) {
        [self moveGradeAnimation:5];
    }
    else if (swipeGest.direction == UISwipeGestureRecognizerDirectionLeft){
        [self moveGradeAnimation:6];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.swipeLeft.enabled = YES;
        self.swipeRight.enabled = YES;
    });
    
}

- (void)vipTap:(UITapGestureRecognizer *)tap;
{
    NSInteger tag = tap.view.tag;
    
    
    [self moveGradeAnimation:tag];
}


- (void)moveGradeAnimation:(NSInteger) index
{
    
    CGFloat angleTrend = 0.1;  //角度偏移量
    BOOL clockwise = YES;  //yes 逆时针  no顺时针
    if (index >= 5) {
        if (index == 6) {
            //右划
            clockwise = YES;
            angleTrend = 0.1;
        }
        else if (index == 5){
            //左滑
            clockwise = NO;
            angleTrend = -0.1;
        }
    }
    else{
        GradeInfo *info = self.gradeViewArray[index];
        if ([info.angle isEqualToString:@"0.4"]) {
            angleTrend = 0.1;
            clockwise = YES;
        }
        else if ([info.angle isEqualToString:@"0.5"]){
            angleTrend = 0;
            clockwise = YES;
            return;
        }
        else if ([info.angle isEqualToString:@"0.6"]){
            angleTrend = -0.1;
            clockwise = NO;
        }
    }
    
    GradeInfo *firstInfo = [self.gradeViewArray firstObject];
    if (clockwise && [firstInfo.angle isEqualToString:@"0.9"]) {
        return;
    }
    else if (!clockwise && [firstInfo.angle isEqualToString:@"0.5"]){
        return;
    }
    
    int i = 0;
    for (GradeInfo *gradeInfo in self.gradeViewArray) {
        double angle = gradeInfo.angle.doubleValue;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.duration = 0.6;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        // 设置贝塞尔曲线路径
        UIBezierPath *circylePath = [[UIBezierPath alloc] init];
        [circylePath addArcWithCenter:self.centerPoint radius:self.radius startAngle:angle *M_PI endAngle:(angle +angleTrend)*M_PI clockwise:clockwise];
        animation.path = circylePath.CGPath;
        
        NSString *string = [NSString stringWithFormat:@"%.1f", angle + angleTrend];
        
        if ([string isEqualToString:@"0.5"]) {
            [UIView animateWithDuration:0.5 animations:^{
                gradeInfo.iconImage.bounds = CGRectMake(0, 0, 80, 80);
            }];
        }
        else {
            [UIView animateWithDuration:0.5 animations:^{
                gradeInfo.iconImage.bounds = CGRectMake(0, 0, 60, 60);
            }];
        }
        
        // 将动画对象添加到视图的layer上
        [gradeInfo.iconImage.layer addAnimation:animation forKey:nil];
        
        //位置纠正
        CGFloat a = (gradeInfo.angle.floatValue + angleTrend) * M_PI;
        CGPoint point = CGPointMake(self.centerPoint.x + cos(a) *(self.radius), self.centerPoint.y + sin(a) *(self.radius));
        gradeInfo.iconImage.center = point;
   
        i ++;
    }
    
    
    for (int i = 0; i < self.gradeViewArray.count; i ++) {
        GradeInfo *info = self.gradeViewArray[i];
        
        info.angle = [NSString stringWithFormat:@"%.1f",info.angle.floatValue + angleTrend];
    }
    
    NSArray *array = [self.gradeViewArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"angle ==%@",@"0.5"]];
    
    GradeInfo *a = [array firstObject];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !self.gradeViewSelectBlock ? : self.gradeViewSelectBlock(a);
        
    });
    
}

@end
