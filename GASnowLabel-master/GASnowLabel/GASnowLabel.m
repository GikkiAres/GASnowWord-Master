//
//  GASnowLabel.m
//  GASnowLabel-master
//
//  Created by GikkiAres on 3/8/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import "GASnowLabel.h"
#import "GASnowView.h"
#import "UIBezierPath+ZJText.h"

@interface GASnowLabel ()<
GASnowViewDelegate
>

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger countSnow;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

#define kProduceRate 30.0
@implementation GASnowLabel

#pragma mark 1 - 流程函数
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor blackColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/kProduceRate target:self selector:@selector(createSnow:) userInfo:nil repeats:YES];
    self.text = @"GA";
    _shapeLayer = [CAShapeLayer layer];
    CGSize size = self.frame.size;
    CGFloat height = 250;
    _shapeLayer.frame = CGRectMake(0, (size.height - height)/2, size.width , height);
    _shapeLayer.geometryFlipped = YES;
    _shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    _shapeLayer.fillColor = [UIColor greenColor].CGColor;;
    _shapeLayer.lineWidth = 2.0f;
    _shapeLayer.lineJoin = kCALineJoinRound;
    NSMutableDictionary *_attrs = [[NSMutableDictionary alloc] init];
    UIFont *font = [UIFont fontWithName:@"Chalkduster" size:200];
    [_attrs setValue:font forKey:NSFontAttributeName];
    _path = [UIBezierPath zjBezierPathWithText:self.text attributes:_attrs];
    self.shapeLayer.bounds = CGPathGetBoundingBox(_path.CGPath);
    self.shapeLayer.path = _path.CGPath;
    [self.layer addSublayer:_shapeLayer];
  }
  return self;
}

#pragma mark 2 - 基本函数
-(void)createSnow:(NSTimer *)timer{
  int n = arc4random()%3+1;
  for (int i=0; i<n; i++) {
    GASnowView *view = [GASnowView new];
    view.delegate = self;
    [self addSubview:view];
  }
}

#pragma mark - 3 代理
- (BOOL)isInSlowArea:(GASnowView *)view {
  //点的判断必须在同一个坐标系下.
  CGPoint pt = [_shapeLayer convertPoint:view.center fromLayer:self.layer];
  return CGPathContainsPoint(_path.CGPath, NULL,pt, NO);
}


@end
