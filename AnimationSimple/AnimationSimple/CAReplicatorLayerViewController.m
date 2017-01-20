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
    [self shadowLayer];
}

//=======layer================
- (void)musicLayer
{
    //背景layer，无实在意义。仅用作多页面显示不同区域。
    CALayer *_musicLayer = [CALayer layer];
    _musicLayer.frame = CGRectMake(0, 64, LAYER_WIDTH, LAYER_WIDTH);
    _musicLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:_musicLayer];
    
    //创建一个小长方形
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, 20, 100);
    baseLayer.backgroundColor = [UIColor redColor].CGColor;
    baseLayer.cornerRadius = 5;
    baseLayer.anchorPoint = CGPointMake(0, 1);
    baseLayer.position = CGPointMake(10, CGRectGetWidth(_musicLayer.bounds));
    
    //创建复制layer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = 5;  //复制5个
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0); //复制的时候产生位移40
    replicatorLayer.instanceDelay = 0.1;    //复制时延迟时间
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

    //老规矩，创建一个圆形的baseLayer
    CGFloat radius                     = 100/4.0;
    CGFloat transX                     = 100 - radius;
    CAShapeLayer *baseLayer = [CAShapeLayer layer];
    baseLayer.frame = CGRectMake(0, 0, radius, radius);
    baseLayer.fillColor = [UIColor greenColor].CGColor;
    baseLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;

    
    /*        创建克隆层         */
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame              = CGRectMake(0, 0, radius, radius);
    replicatorLayer.instanceDelay      = 0.0;   //因为不需要一个一个展现，所以延迟设置成0
    replicatorLayer.instanceCount      = 3;
    //这里面要设置复制的layer的变换了。先向右移动一定像素，再顺时针移动一定角度。这里有个点，至少我当时不是很明白，就是为什么这么设置就会闭合成一个三角形。那么当你弄三只小木棍模拟一下这个动画变换过程，你就会发现其中的道理了。
    CATransform3D trans3D              = CATransform3DIdentity;
    trans3D                            = CATransform3DTranslate(trans3D, transX, 0, 0);
    trans3D                            = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    replicatorLayer.instanceTransform  = trans3D;
    [replicatorLayer addSublayer:baseLayer];
    [_trilateralLayer addSublayer:replicatorLayer];
    
    //这个动画就很简单了，仅仅是改变了位置。
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
    
    //横向创建5个圆形baseLayer
    CAReplicatorLayer *replicator1 = [CAReplicatorLayer layer];
    replicator1.instanceCount = 5;
    replicator1.instanceTransform = CATransform3DMakeTranslation(transX, 0, 0);
    replicator1.instanceDelay = 0.3; //这个属性很重要，设置延迟时间才会出现逐个变化的效果
    [replicator1 addSublayer:baseLayer];
    
    //将上面创建的replicator1 作为子视图在纵向创建5个，形成一个正方形。
    CAReplicatorLayer *replicator2 = [CAReplicatorLayer layer];
    replicator2.instanceCount = 5;
    replicator2.instanceTransform = CATransform3DMakeTranslation(0, transX, 0);
    replicator2.instanceDelay = 0.3;
    [replicator2 addSublayer:replicator1];
    [_rectLayer addSublayer:replicator2];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0)];
    animation.repeatCount = HUGE;
    animation.autoreverses = YES; //autoreverses需要注意，他的意思是动画结束时执行逆动画
    [baseLayer addAnimation:animation forKey:nil];
}

- (void)progressLayer
{
    CALayer *_progressLayer = [CALayer layer];
    _progressLayer.frame = CGRectMake(0, 64 + LAYER_WIDTH * 2, LAYER_WIDTH, LAYER_WIDTH);
    _progressLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:_progressLayer];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = _progressLayer.bounds;
    replicator.instanceCount = 10;
    CGFloat angle = 2 * M_PI / 10; //按照一定角度复制
    replicator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    //1.0 / 10.0 = 0.1
    //1 / 10 = 0
    //如果这个没想好，没设置对，那么他就不会出现渐渐变大的效果，该问题我用了10多个小时才找出来。
    replicator.instanceDelay = 1.0 / 10.0;  //血的教训，整型和浮点型的重要性
    [_progressLayer addSublayer:replicator];
    
    CGFloat radius = 20;
    CAShapeLayer *baseLayer = [CAShapeLayer layer];
    baseLayer.frame = CGRectMake(50, 50, radius, radius);
    baseLayer.fillColor = [UIColor redColor].CGColor;
    baseLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    baseLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01); //先缩小，达到由小变大的效果
    [replicator addSublayer:baseLayer];

    //到目前为止，baseLayer已经按照一定角度排布好，然后每个baseLayer都会围绕中心点转动。那么唯一需要我们做的就是改变他们的大小
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.fromValue = @1;
    animation.toValue = @0.1;
    animation.repeatCount = HUGE;
    [baseLayer addAnimation:animation forKey:nil];
}

- (void)shadowLayer
{
    CALayer *_shadowLayer = [CALayer layer];
    _shadowLayer.frame = CGRectMake(LAYER_WIDTH, 64 + LAYER_WIDTH, LAYER_WIDTH, LAYER_WIDTH * 2);
    _shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:_shadowLayer];
    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, LAYER_WIDTH, LAYER_WIDTH);
    baseLayer.contents = (__bridge id)[UIImage imageNamed:@"demo"].CGImage;
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.instanceCount = 2;
    replicator.frame = _shadowLayer.bounds;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    replicator.instanceTransform = transform;
    replicator.instanceRedOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceAlphaOffset = -0.1;
    [replicator addSublayer:baseLayer];
    [_shadowLayer addSublayer:replicator];
}
@end
