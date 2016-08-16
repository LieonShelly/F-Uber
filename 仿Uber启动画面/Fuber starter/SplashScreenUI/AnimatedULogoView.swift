/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import QuartzCore
import Commons
public class AnimatedULogoView: UIView {
  private let strokeEndTimingFunction   = CAMediaTimingFunction(controlPoints: 1.00, 0.0, 0.35, 1.0)
  private let squareLayerTimingFunction      = CAMediaTimingFunction(controlPoints: 0.25, 0.0, 0.20, 1.0)
  private let circleLayerTimingFunction   = CAMediaTimingFunction(controlPoints: 0.65, 0.0, 0.40, 1.0)
  private let fadeInSquareTimingFunction = CAMediaTimingFunction(controlPoints: 0.15, 0, 0.85, 1.0)
  
  private let radius: CGFloat = 37.5
  private let squareLayerLength = 21.0
  private let startTimeOffset = 0.7 * kAnimationDuration
  
  private var circleLayer: CAShapeLayer!
  private var squareLayer: CAShapeLayer!
  private var lineLayer: CAShapeLayer!
  private var maskLayer: CAShapeLayer!
  
  var beginTime: CFTimeInterval = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    circleLayer = generateCircleLayer()
    lineLayer = generateLineLayer()
    squareLayer = generateSquareLayer()
    maskLayer = generateMaskLayer()
    
    layer.mask = maskLayer
    layer.addSublayer(circleLayer)
    layer.addSublayer(lineLayer)
    layer.addSublayer(squareLayer)
  }
  
  public func startAnimating() {
    beginTime = CACurrentMediaTime()
    layer.anchorPoint = CGPointZero
    
    animateMaskLayer()
    animateCircleLayer()
    animateLineLayer()
    animateSquareLayer()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

extension AnimatedULogoView {
  
  private func generateMaskLayer()->CAShapeLayer {
    let layer = CAShapeLayer()
    layer.frame = CGRect(x: -radius, y: -radius, width: radius * 2.0, height: radius * 2.0)
    layer.allowsGroupOpacity = true
    layer.backgroundColor = UIColor.whiteColor().CGColor
    return layer
  }
  
  private func generateCircleLayer()->CAShapeLayer {
    let layer = CAShapeLayer()
    layer.lineWidth = radius
    layer.path = UIBezierPath(arcCenter: CGPointZero, radius: radius/2, startAngle: -CGFloat(M_PI_2), endAngle: CGFloat(3*M_PI_2), clockwise: true).CGPath
    layer.strokeColor = UIColor.whiteColor().CGColor
    layer.fillColor = UIColor.clearColor().CGColor
    return layer
  }
  
  private func generateLineLayer()->CAShapeLayer {
    let layer = CAShapeLayer()
    layer.position = CGPointZero
    layer.frame = CGRectZero
    layer.allowsGroupOpacity = true
    layer.lineWidth = 5.0
    layer.strokeColor = UIColor.fuberBlue().CGColor
    
    let bezierPath = UIBezierPath()
    bezierPath.moveToPoint(CGPointZero)
    bezierPath.addLineToPoint(CGPointMake(0.0, -radius))
    
    layer.path = bezierPath.CGPath
    return layer
  }
  
  private func generateSquareLayer()->CAShapeLayer {
    let layer = CAShapeLayer()
    layer.position = CGPointZero
    layer.frame = CGRect(x: -squareLayerLength / 2.0, y: -squareLayerLength / 2.0, width: squareLayerLength, height: squareLayerLength)
    layer.cornerRadius = 1.5
    layer.allowsGroupOpacity = true
    layer.backgroundColor = UIColor.fuberBlue().CGColor
    
    return layer
  }
}

extension AnimatedULogoView {
  
  private func animateMaskLayer() {
    // 边框缩小
    let boundsAnimation = CABasicAnimation(keyPath: "bounds")
    boundsAnimation.fromValue = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: radius * 2.0, height: radius * 2))
    boundsAnimation.toValue = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: 2.0/3.0 * squareLayerLength, height: 2.0/3.0 * squareLayerLength))
    boundsAnimation.duration = kAnimationDurationDelay
    boundsAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay
    boundsAnimation.timingFunction = circleLayerTimingFunction
    // 边角弧度
    let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
    cornerRadiusAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay
    cornerRadiusAnimation.duration = kAnimationDurationDelay
    cornerRadiusAnimation.fromValue = radius
    cornerRadiusAnimation.toValue = 2
    cornerRadiusAnimation.timingFunction = circleLayerTimingFunction
    // 合成动画
    let groupAnimation = CAAnimationGroup()
    groupAnimation.removedOnCompletion = false
    groupAnimation.fillMode = kCAFillModeBoth
    groupAnimation.beginTime = beginTime
    groupAnimation.repeatCount = Float.infinity
    groupAnimation.duration = kAnimationDuration
    groupAnimation.animations = [boundsAnimation, cornerRadiusAnimation]
    groupAnimation.timeOffset = startTimeOffset
    maskLayer.addAnimation(groupAnimation, forKey: "looping")

  }
  // 笔画变化的动画
  private func animateCircleLayer() {
    let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.timingFunction =  strokeEndTimingFunction
    strokeEndAnimation.duration = kAnimationDuration - kAnimationDurationDelay
    strokeEndAnimation.values = [0.0, 1.0]
    strokeEndAnimation.keyTimes = [0.0, 1.0]
    let transformAnimation = CABasicAnimation(keyPath: "transform")
    transformAnimation.timingFunction = strokeEndTimingFunction
    
    transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay
    var startingTransform = CATransform3DMakeRotation(-CGFloat(M_PI_4), 0, 0, 1)
    startingTransform = CATransform3DScale(startingTransform, 0.25, 0.25, 1)
    transformAnimation.fromValue = NSValue(CATransform3D: startingTransform)
    transformAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
    // 把两个动画合成
    let groupAnimation = CAAnimationGroup()
    groupAnimation.animations = [strokeEndAnimation, transformAnimation]
    groupAnimation.repeatCount = Float.infinity
    // 无限重复动画
    groupAnimation.duration = kAnimationDuration
    groupAnimation.beginTime = beginTime
    groupAnimation.timeOffset = startTimeOffset
    
    circleLayer.addAnimation(groupAnimation, forKey: "looping")
    
  }
  
  private func animateLineLayer() {
    // 线段宽度动画
    let lineWidthAnimation = CAKeyframeAnimation(keyPath: "lineWidth")
    lineWidthAnimation.values = [0.0, 5.0, 0.0]
    lineWidthAnimation.timingFunctions = [strokeEndTimingFunction, circleLayerTimingFunction]
    lineWidthAnimation.duration = kAnimationDuration
    lineWidthAnimation.keyTimes = [0.0, 1.0 - kAnimationDurationDelay/kAnimationDuration, 1.0]
    // 变形
    let transformAnimation = CAKeyframeAnimation(keyPath: "transform")
    transformAnimation.timingFunctions = [strokeEndTimingFunction, circleLayerTimingFunction]
    transformAnimation.duration = kAnimationDuration
    transformAnimation.keyTimes = [0.0, 1.0 - kAnimationDurationDelay/kAnimationDuration, 1.0]
    // 和之前一样的旋转放大动画
    var transform = CATransform3DMakeRotation(-CGFloat(M_PI_4), 0.0, 0.0, 1.0)
    transform = CATransform3DScale(transform, 0.25, 0.25, 1.0)// 先放大再缩小
    transformAnimation.values = [NSValue(CATransform3D: transform),  NSValue(CATransform3D: CATransform3DIdentity),                             NSValue(CATransform3D: CATransform3DMakeScale(0.15, 0.15, 1.0))]
    // 合成动画
    let groupAnimation = CAAnimationGroup()
    groupAnimation.repeatCount = Float.infinity
    groupAnimation.removedOnCompletion = false
    groupAnimation.duration = kAnimationDuration
    groupAnimation.beginTime = beginTime
    groupAnimation.animations = [lineWidthAnimation, transformAnimation]
    groupAnimation.timeOffset = startTimeOffset
    
    lineLayer.addAnimation(groupAnimation, forKey: "looping")

  }
  
  private func animateSquareLayer() {
    let b1 = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: 2.0/3.0 * squareLayerLength, height: 2.0/3.0  * squareLayerLength))
    let b2 = NSValue(CGRect: CGRect(x: 0.0, y: 0.0, width: squareLayerLength, height: squareLayerLength))
    let b3 = NSValue(CGRect: CGRectZero)// 边框从原始长度的2/3开始放大，到原始大小后再逐渐缩小到0
    let boundsAnimation = CAKeyframeAnimation(keyPath: "bounds")
    boundsAnimation.values = [b1, b2, b3]
    boundsAnimation.timingFunctions = [fadeInSquareTimingFunction, squareLayerTimingFunction]
    boundsAnimation.duration = kAnimationDuration
    boundsAnimation.keyTimes = [0, 1.0-kAnimationDurationDelay/kAnimationDuration, 1.0]
    // 背景颜色的变化
    let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
    backgroundColorAnimation.fromValue = UIColor.whiteColor().CGColor
    backgroundColorAnimation.toValue = UIColor.fuberBlue().CGColor
    backgroundColorAnimation.timingFunction = squareLayerTimingFunction
    backgroundColorAnimation.fillMode = kCAFillModeBoth
    backgroundColorAnimation.beginTime = kAnimationDurationDelay * 2.0 / kAnimationDuration
    backgroundColorAnimation.duration = kAnimationDuration / (kAnimationDuration - kAnimationDurationDelay)
    // 合成动画
    let groupAnimation = CAAnimationGroup()
    groupAnimation.animations = [boundsAnimation, backgroundColorAnimation]
    groupAnimation.repeatCount = Float.infinity
    groupAnimation.duration = kAnimationDuration
    groupAnimation.removedOnCompletion = false
    groupAnimation.beginTime = beginTime
    groupAnimation.timeOffset = startTimeOffset
    squareLayer.addAnimation(groupAnimation, forKey: "looping")

  }
}
