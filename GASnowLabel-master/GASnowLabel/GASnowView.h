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

@end
