//
//  CircularProgressViewController.m
//  AnimationSimple
//
//  Created by Owen.li on 2017/1/18.
//  Copyright © 2017年 Owen.li. All rights reserved.
//

#import "CircularProgressViewController.h"

@interface CircularProgressViewController ()
{
    CAShapeLayer *_trackLayer;
    CAShapeLayer *_progressLayer;
}

@end

@implementation CircularProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat ViewWith = CGRectGetWidth(self.view.frame);
    
    CGPoint position = self.view.center;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ViewWith / 2, ViewWith / 2) radius:ViewWith / 2 - 10 startAngle:- M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.bounds = CGRectMake(0, 0, ViewWith, ViewWith);
    _trackLayer.position = position;
    _trackLayer.lineCap = kCALineCapRound;
    _trackLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    _trackLayer.fillColor = [UIColor clearColor].CGColor;
    _trackLayer.lineWidth = 10;
    _trackLayer.path = path.CGPath;
    [self.view.layer addSublayer:_trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    //可以改
    _progressLayer.bounds = _trackLayer.bounds;
    _progressLayer.position = CGPointMake(CGRectGetWidth(_trackLayer.bounds) / 2, CGRectGetWidth(_trackLayer.bounds) / 2);
    _progressLayer.strokeColor = [UIColor redColor].CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = 10;
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeEnd = 0;
//    [_trackLayer addSublayer:_progressLayer];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame = _progressLayer.frame;
    [colorLayer setColors:@[(id)[UIColor blueColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor]];
    colorLayer.mask = _progressLayer;
    [_trackLayer addSublayer:colorLayer];
    
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation1.duration = 2;
    animation1.fromValue = 0;
    animation1.toValue = @1;
    animation1.fillMode = kCAFillModeForwards;
    animation1.removedOnCompletion = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation2.duration = 2;
    animation2.fromValue = 0;
    animation2.toValue = @0.25;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation3.beginTime = 1.5;
    animation3.duration = 1;
    animation3.fromValue = @0.25;
    animation3.toValue = @1;
    animation3.fillMode = kCAFillModeForwards;
    animation3.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1,animation2,animation3];
    group.duration = 2.5;
    group.repeatCount = MAXFLOAT;
    [_progressLayer addAnimation:group forKey:nil];
}

@end
