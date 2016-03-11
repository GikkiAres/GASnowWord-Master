//
//  GASnowLayer.m
//  GASnowLabel-master
//
//  Created by GikkiAres on 3/8/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import "GASnowView.h"


@interface GASnowView ()

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) CADisplayLink *link;
//为什么有的属性不会自动合成?


@end


#define FPS 60.0
#define MAX_SIZE 10
#define kDURATION 10
@implementation GASnowView
@synthesize speed=_speed;

- (instancetype)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  CGFloat size = arc4random()%(MAX_SIZE+1)+5;
  CGFloat y = 0;
  CGFloat x = arc4random()%(int)(newSuperview.frame.size.width+1);
  self.frame = CGRectMake(x, y, size,size);
  [self.layer setContents:(id)[[UIImage imageNamed:@"snow.png"]CGImage]];
//  self.backgroundColor = [UIColor redColor];
  _yDropDestination = newSuperview.frame.size.height;
  //随机的运动时间
  NSTimeInterval time = arc4random()%(3+1)-6+kDURATION;
  CGFloat dy = newSuperview.frame.size.height/time/FPS;
  CGFloat dx = (arc4random()%100-50)/time/FPS;
  _centerEnd = CGPointMake(arc4random()%101/100.0*newSuperview.frame.size.width, newSuperview.frame.size.height);
  _speed = CGVectorMake(dx, dy);
  
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1/FPS target:self selector:@selector(drop) userInfo:nil repeats:YES];
//  _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(drop)];
//  [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//  [self drop];
}

- (void)drop {
  CGPoint center = self.center;
//  if (center.y>=_yDropDestination) {
//    if (_timer) {
//      [_timer invalidate];
//      _timer = nil;
//    }
//    if (_link) {
//      [_link invalidate];
//      _link = nil;
//    }

    
//  }
//  else {
//    CGPoint pt = [ convertPoint:snow.center fromLayer:self.view.layer];
    if (_delegate) {
      if ([_delegate isInSlowArea:self]) {
        center.x += _speed.dx/10;
        center.y += _speed.dy/10;
        self.center = center;
      }
      else {
        center.x += _speed.dx*5;
        center.y += _speed.dy*5;
        self.center = center;
      }
    }
    else {
    center.x += _speed.dx;
    center.y += _speed.dy;
    self.center = center;
//    NSLog(@"OUT");
    }
//  }
}

@end
