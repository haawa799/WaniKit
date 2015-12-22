//
//  ViewController.swift
//  WaniKit
//
//  Created by Andriy K. on 12/10/2015.
//  Copyright (c) 2015 Andriy K.. All rights reserved.
//

import UIKit
import WaniKit


class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let manager = WaniApiManager()
    manager.setApiKey("69b9b1f682946cbc42d251f41f2863d7")
    
    manager.fetchStudyQueue({ (userInfo, studyQInfo) -> Void in
      print("userInfo: \(userInfo)")
      print("studyQInfo: \(studyQInfo)")
    })
    
    manager.fetchLevelProgression({ (userInfo, levelProgression) -> Void in
      print("userInfo: \(userInfo)")
      print("levelProgression: \(levelProgression)")
    })
    
    manager.fetchUserInfo { (userInfo) -> Void in
      print("userInfo: \(userInfo)")
    }
    
  }
}

