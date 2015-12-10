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
    
    WaniApiManager.sharedInstance().setApiKey("69b9b1f682946cbc42d251f41f2863d7")
    try! WaniApiManager.sharedInstance().fetchStudyQueue { (usr) -> () in
      //
    }
    
  }
}

