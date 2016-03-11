//
//  GASnowLayer.h
//  GASnowLabel-master
//
//  Created by GikkiAres on 3/8/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class GASnowView;
@protocol GASnowViewDelegate <NSObject>

- (BOOL)isInSlowArea:(GASnowView *)view;

@end

@interface GASnowView : UIView
@property (nonatomic, strong) id<GASnowViewDelegate> delegate;
@property (nonatomic,assign) CGFloat  yDropDestination;
//为什么有的属性不会自动合成?
@property (nonatomic,assign) CGVector speed;

@property (nonatomic,assign) CGPoint centerEnd;

- (void)drop;
@end
