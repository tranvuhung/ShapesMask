//
//  ViewController.swift
//  ShapesAndMask
//
//  Created by Trần Vũ Hưng on 12/4/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import UIKit

func delay(seconds: Double, complete: @escaping () -> ()){
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: complete)
}

class ViewController: UIViewController {
  @IBOutlet weak var avatar1: ShapeMask!
  @IBOutlet weak var avatar2: ShapeMask!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    updateUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func updateUI(){
    let avatarSize = avatar1.frame.size
    let bounceXOffset = avatarSize.width / 1.9
    let morphSize = CGSize(width: avatarSize.width * 0.85, height: avatarSize.height * 1.1)
    let rightBouncePoint = CGPoint(x: (view.frame.size.width/2 + bounceXOffset), y: avatar1.center.y)
    let leftBouncePoint = CGPoint(x: view.frame.size.width/2 - bounceXOffset, y: avatar1.center.y)
    
    avatar1.bounceOff(point: leftBouncePoint, morphSize: morphSize)
    avatar2.bounceOff(point: rightBouncePoint, morphSize: morphSize)
    
    delay(seconds: 10.0) { 
      self.avatar1.shouldTransitionFinishedState = true
      self.avatar2.shouldTransitionFinishedState = true
    }
  }

}

