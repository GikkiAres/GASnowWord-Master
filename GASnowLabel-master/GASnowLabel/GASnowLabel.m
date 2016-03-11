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
//产生雪花的定时器
@property (nonatomic,strong)NSTimer *timerCreate;
//@property (nonatomic,strong)NSTimer *timerCreate;
@property (nonatomic,strong)NSTimer *timerDrop;
@property (nonatomic,strong)NSTimer *timerDrop2;
@property (nonatomic,strong)NSTimer *timerDrop3;
@property (nonatomic,strong)NSTimer *timerDrop4;
@property (nonatomic,strong)NSTimer *timerDrop5;
@property (nonatomic,strong)NSMutableArray *marrSnow;
@property (nonatomic,strong)NSMutableArray *marrSnow2;
@property (nonatomic,strong)NSMutableArray *marrSnow3;
@property (nonatomic,strong)NSMutableArray *marrSnow4;
@property (nonatomic,strong)NSMutableArray *marrSnow5;

@property (nonatomic,assign)NSInteger countSnow;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

#define kProduceRate 30.0
#define kFPS 25.0
#define kMode 0
#define kUseUIViewAnimate 0

@implementation GASnowLabel

#pragma mark 1 - 流程函数
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor blackColor];
    _marrSnow = [NSMutableArray array];
    _timerCreate = [NSTimer scheduledTimerWithTimeInterval:1/kProduceRate target:self selector:@selector(createSnow:) userInfo:nil repeats:YES];
#if kUseUIViewAnimate==0
    _timerDrop = [NSTimer scheduledTimerWithTimeInterval:1/kFPS target:self selector:@selector(dropSnow) userInfo:nil repeats:YES];
#endif
#if kMode==1
    _marrSnow2 = [NSMutableArray array];
    _marrSnow3 = [NSMutableArray array];
    _marrSnow4 = [NSMutableArray array];
    _marrSnow5 = [NSMutableArray array];
    _timerDrop2 = [NSTimer scheduledTimerWithTimeInterval:1/kFPS target:self selector:@selector(dropSnow2) userInfo:nil repeats:YES];
    _timerDrop3 = [NSTimer scheduledTimerWithTimeInterval:1/kFPS target:self selector:@selector(dropSnow3) userInfo:nil repeats:YES];
    _timerDrop4 = [NSTimer scheduledTimerWithTimeInterval:1/kFPS target:self selector:@selector(dropSnow4) userInfo:nil repeats:YES];
    _timerDrop5 = [NSTimer scheduledTimerWithTimeInterval:1/kFPS target:self selector:@selector(dropSnow5) userInfo:nil repeats:YES];
#endif
    self.text = @"生日快乐";
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
    UIFont *font = [UIFont fontWithName:@"Chalkduster" size:80];
    font = [UIFont systemFontOfSize:80];
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
  NSLog(@"%zi",self.subviews.count);
  int n = arc4random()%3+1;
  n *=2;
  for (int i=0; i<n; i++) {
    GASnowView *view = [GASnowView new];
    view.delegate = self;
    [self addSubview:view];
    
#if kUseUIViewAnimate==1
    [UIView animateWithDuration:10 animations:^{
      view.center = view.centerEnd;
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:arc4random()%10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.alpha=0;
      } completion:^(BOOL finished) {
        [view removeFromSuperview];
      }];
    }];
#endif
#if kMode == 0
    [_marrSnow addObject:view];
#else
    switch (i%5) {
      case 0:
        [_marrSnow addObject:view];
        break;
      case 1:
        [_marrSnow2 addObject:view];
        break;
      case 2:
        [_marrSnow3 addObject:view];
        break;
      case 3:
        [_marrSnow4 addObject:view];
        break;
      case 4:
        [_marrSnow5 addObject:view];
        break;
    }
#endif
  }
}

- (void)dropSnow{
  //  for (GASnowView *snow in _marrSnow) {
  if (_marrSnow.count) {
    for (int i = 0; i<=_marrSnow.count-1; i++) {
      GASnowView *snow = _marrSnow[i];
      if(snow.center.y >= snow.yDropDestination) {
        [_marrSnow removeObject:snow];
        [UIView animateWithDuration:arc4random()%10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
          snow.alpha=0;
        } completion:^(BOOL finished) {
          [snow removeFromSuperview];
        }];
      }
      else {
        //      [snow drop];
        //点的判断必须在同一个坐标系下.
#if 1
        CGPoint pt = [_shapeLayer convertPoint:snow.center fromLayer:self.layer];
        CGPoint center = snow.center;
        if(CGPathContainsPoint(_path.CGPath, NULL,pt, NO)) {
          center.x += snow.speed.dx/10/10;
          center.y += snow.speed.dy/10/10;
        }
        else {
          center.x += snow.speed.dx*5;
          center.y += snow.speed.dy*5;
        }
        snow.center = center;
#else
        CGPoint center = snow.center;
        center.x += snow.speed.dx*5;
        center.y += snow.speed.dy*5;
        snow.center = center;
        
        
#endif
      }}
  }
}

- (void)dropSnow2{
  //  for (GASnowView *snow in _marrSnow) {
  if (_marrSnow2.count) {
    for (int i = 0; i<=_marrSnow2.count-1; i++) {
      GASnowView *snow = _marrSnow2[i];
      if(snow.center.y >= snow.yDropDestination) {
        [_marrSnow2 removeObject:snow];
        [UIView animateWithDuration:arc4random()%10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
          snow.alpha=0;
        } completion:^(BOOL finished) {
          [snow removeFromSuperview];
        }];
      }
      else {
        [snow drop];
      }
    }
  }
}
- (void)dropSnow3{
  //  for (GASnowView *snow in _marrSnow) {
  if (_marrSnow3.count) {
    for (int i = 0; i<=_marrSnow3.count-1; i++) {
      GASnowView *snow = _marrSnow3[i];
      if(snow.center.y >= snow.yDropDestination) {
        [_marrSnow3 removeObject:snow];
        [UIView animateWithDuration:arc4random()%10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
          snow.alpha=0;
        } completion:^(BOOL finished) {
          [snow removeFromSuperview];
        }];
      }
      else {
        [snow drop];
      }
    }
  }
}
- (void)dropSnow4{
  //  for (GASnowView *snow in _marrSnow) {
  if (_marrSnow4.count) {
    for (int i = 0; i<=_marrSnow4.count-1; i++) {
      GASnowView *snow = _marrSnow4[i];
      if(snow.center.y >= snow.yDropDestination) {
        [_marrSnow4 removeObject:snow];
        [UIView animateWithDuration:arc4random()%10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
          snow.alpha=0;
        } completion:^(BOOL finished) {
          [snow removeFromSuperview];
        }];
      }
      else {
        [snow drop];
      }
    }
  }
}
- (void)dropSnow5{
  //  for (GASnowView *snow in _marrSnow) {
  if (_marrSnow5.count) {
    for (int i = 0; i<=_marrSnow5.count-1; i++) {
      GASnowView *snow = _marrSnow5[i];
      if(snow.center.y >= snow.yDropDestination) {
        [_marrSnow5 removeObject:snow];
        [UIView animateWithDuration:arc4random()%10 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
          snow.alpha=0;
        } completion:^(BOOL finished) {
          [snow removeFromSuperview];
        }];
      }
      else {
        [snow drop];
      }
    }
  }
}

#pragma mark - 3 代理
- (BOOL)isInSlowArea:(GASnowView *)view {
  //点的判断必须在同一个坐标系下.
  CGPoint pt = [_shapeLayer convertPoint:view.center fromLayer:self.layer];
  return CGPathContainsPoint(_path.CGPath, NULL,pt, NO);
}


@end
