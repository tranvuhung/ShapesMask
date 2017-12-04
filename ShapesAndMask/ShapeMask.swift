//
//  ShapeMask.swift
//  ShapesAndMask
//
//  Created by Trần Vũ Hưng on 12/4/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class ShapeMask: UIView {
  
  let lineWidth: CGFloat = 6.0
  let animationDuration = 1.0
  
  let photoLayer = CALayer()
  let circleLayer = CAShapeLayer()
  let maskLayer = CAShapeLayer()
  let label: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Avenir Next", size: 18.0)
    label.textAlignment = .center
    label.textColor = UIColor.black
    return label
  }()
  
  @IBInspectable
  var image: UIImage? = nil {
    didSet{
      photoLayer.contents = image?.cgImage
    }
  }
  
  @IBInspectable
  var name: String? = nil {
    didSet{
      label.text = name
    }
  }
  
  var shouldTransitionFinishedState = false
  var isSquare = false
  
  override func didMoveToWindow() {
    layer.addSublayer(photoLayer)
    photoLayer.mask = maskLayer
    layer.addSublayer(circleLayer)
    addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard let image = image else { return }
    
    photoLayer.frame = CGRect(x: (bounds.size.width - image.size.width + lineWidth)/2, y: (bounds.size.height - image.size.height - lineWidth)/2, width: image.size.width, height: image.size.height)
    
    circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
    circleLayer.strokeColor = UIColor.white.cgColor
    circleLayer.lineWidth = lineWidth
    circleLayer.fillColor = UIColor.clear.cgColor
    
    maskLayer.path = circleLayer.path
    maskLayer.position = CGPoint(x: 0.0, y: 10.0)
    
    label.frame = CGRect(x: 0.0, y: bounds.size.height + 10, width: bounds.size.width, height: 24.0)
  }
  
  func bounceOff(point: CGPoint, morphSize: CGSize){
    let originalCenter = center
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
      self.center = point
    }, completion: {_ in
      if self.shouldTransitionFinishedState {
        self.animateToSquare()
      }
    })
    
    UIView.animate(withDuration: animationDuration, delay: animationDuration, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: { 
      self.center = originalCenter
    }, completion: {_ in
      delay(seconds: 0.1, complete: { 
        if !self.isSquare {
         self.bounceOff(point: point, morphSize: morphSize)
        }
      })
    })
    
    let morphed = (originalCenter.x > point.x) ? CGRect(x: 0.0, y: bounds.size.height - morphSize.height, width: morphSize.width, height: morphSize.height) : CGRect(x: bounds.size.width - morphSize.width, y: bounds.size.height - morphSize.height, width: morphSize.width, height: morphSize.height)
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = animationDuration
    animation.toValue = UIBezierPath(ovalIn: morphed).cgPath
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
    circleLayer.add(animation, forKey: nil)
    maskLayer.add(animation, forKey: nil)
  }
  
  func animateToSquare(){
    isSquare = true
    let sourcePath = UIBezierPath(rect: bounds).cgPath
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 0.25
    animation.fromValue = circleLayer.path
    animation.toValue = sourcePath
    
    circleLayer.add(animation, forKey: nil)
    circleLayer.path = sourcePath
    
    maskLayer.add(animation, forKey: nil)
    maskLayer.path = sourcePath
  }
}
