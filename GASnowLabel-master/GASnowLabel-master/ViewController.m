//
//  ViewController.m
//  GASnowLabel-master
//
//  Created by GikkiAres on 3/8/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import "ViewController.h"
#import "GASnowLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  GASnowLabel *snowLabel = [[GASnowLabel alloc]initWithFrame:self.view.bounds];
  snowLabel.text = @"龍";
  [self.view addSubview:snowLabel];
  
}

@end
