//
//  CAReplicatorLayerViewController.m
//  AnimationSimple
//
//  Created by Owen.li on 2017/1/18.
//  Copyright © 2017年 Owen.li. All rights reserved.
//

#import "CAReplicatorLayerViewController.h"

#define LAYER_WIDTH [UIScreen mainScreen].bounds.size.width / 2


@interface CAReplicatorLayerViewController ()
{
    
}

@end

@implementation CAReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //音乐播放器
    [self musicLayer];
    
    //三角形移动
    [self trilateralLayer];
    
    //正方形样式
    [self rectLayer];
    
    //进度条
    [self progressLayer];
    //倒影
}

//=======layer================
- (void)musicLayer
{
    CALayer *_musicLayer = [CALayer layer];
    _musicLayer.frame = CGRectMake(0, 64, LAYER_WIDTH, LAYER_WIDTH);
    _musicLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:_musicLayer];
    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, 20, 100);
    baseLayer.backgroundColor = [UIColor redColor].CGColor;
    baseLayer.cornerRadius = 5;
    baseLayer.anchorPoint = CGPointMake(0, 1);
    baseLayer.position = CGPointMake(10, CGRectGetWidth(_musicLayer.bounds));
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = 5;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0);
    replicatorLayer.instanceDelay = 0.1;
    replicatorLayer.instanceRedOffset -= 0.1;
    [replicatorLayer addSublayer:baseLayer];
    [_musicLayer addSublayer:replicatorLayer];
    
    //animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.duration = 1;
    animation.values = @[@1,@0.5,@0];
    animation.repeatCount = HUGE;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [baseLayer addAnimation:animation forKey:nil];
}

- (void)trilateralLayer
{
    CALayer *_trilateralLayer = [CALayer layer];
    _trilateralLayer.frame = CGRectMake(LAYER_WIDTH, 64, LAYER_WIDTH, LAYER_WIDTH);
    _trilateralLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:_trilateralLayer];

    CGFloat radius                     = 100/4.0;
    CGFloat transX                     = 100 - radius;
    CAShapeLayer *baseLayer = [CAShapeLayer layer];
    baseLayer.frame = CGRectMake(0, 0, radius, radius);
    baseLayer.fillColor = [UIColor greenColor].CGColor;
    baseLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;

    
    /*        创建克隆层         */
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame              = CGRectMake(0, 0, radius, radius);
    replicatorLayer.instanceDelay      = 0.0;
    replicatorLayer.instanceCount      = 3;
    CATransform3D trans3D              = CATransform3DIdentity;
    trans3D                            = CATransform3DTranslate(trans3D, transX, 0, 0);
    trans3D                            = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    replicatorLayer.instanceTransform  = trans3D;
    [replicatorLayer addSublayer:baseLayer];
    [_trilateralLayer addSublayer:replicatorLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(transX ,0, 0)];
    animation.repeatCount = HUGE;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [baseLayer addAnimation:animation forKey:nil];
}

- (void)rectLayer
{
    CALayer *_rectLayer = [CALayer layer];
    _rectLayer.frame = CGRectMake(0, 64 + LAYER_WIDTH, LAYER_WIDTH, LAYER_WIDTH);
    _rectLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:_rectLayer];
    
    CGFloat radius                     = 50/4.0;
    CGFloat transX                     = radius + 5;
    CAShapeLayer *baseLayer = [CAShapeLayer layer];
    baseLayer.frame = CGRectMake(30, 30, radius, radius);
    baseLayer.fillColor = [UIColor redColor].CGColor;
    baseLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    
    CAReplicatorLayer *replicator1 = [CAReplicatorLayer layer];
    replicator1.instanceCount = 5;
    replicator1.instanceTransform = CATransform3DMakeTranslation(transX, 0, 0);
    replicator1.instanceDelay = 0.3;
    [replicator1 addSublayer:baseLayer];
    
    CAReplicatorLayer *replicator2 = [CAReplicatorLayer layer];
    replicator2.instanceCount = 5;
    replicator2.instanceTransform = CATransform3DMakeTranslation(0, transX, 0);
    replicator2.instanceDelay = 0.2;
    [replicator2 addSublayer:replicator1];
    [_rectLayer addSublayer:replicator2];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0)];
    animation.repeatCount = HUGE;
    animation.autoreverses = YES;
    [baseLayer addAnimation:animation forKey:nil];
}

- (void)progressLayer
{
    CALayer *_progressLayer = [CALayer layer];
    _progressLayer.frame = CGRectMake(0, 64 + LAYER_WIDTH * 2, LAYER_WIDTH, LAYER_WIDTH);
    _progressLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:_progressLayer];
    
    CGFloat radius = 50/4.0;
    CAShapeLayer *baseLayer = [CAShapeLayer layer];
    baseLayer.frame = CGRectMake(50, 50, radius, radius);
    baseLayer.fillColor = [UIColor redColor].CGColor;
    baseLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:20 startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
    baseLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.instanceCount = 10;
    CGFloat angle = 2 * M_PI / 10;
    replicator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    replicator.instanceDelay = 1 / 10;
    [replicator addSublayer:baseLayer];
    [_progressLayer addSublayer:replicator];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.fromValue = @1;
    animation.toValue = @0.1;
    animation.repeatCount = HUGE;
//    animation.autoreverses = YES;
    [baseLayer addAnimation:animation forKey:nil];
}
@end
