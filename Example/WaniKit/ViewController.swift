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
    
//    manager.fetchStudyQueue { (result) -> Void in
//      switch result {
//      case .Error(let error):
//        print(error())
//      case .Response(let response):
//        let resp = response()
//        if let userInfo = resp.userInfo {
//          print("userInfo: \(userInfo)")
//        }
//        if let studyQueue = resp.studyQInfo {
//          print("studyQueue: \(studyQueue)")
//        }
//      }
//    }
//    
//    manager.fetchLevelProgression { (result) -> Void in
//      switch result {
//      case .Error(let error):
//        print(error())
//      case .Response(let response):
//        let resp = response()
//        if let userInfo = resp.userInfo {
//          print("userInfo: \(userInfo)")
//        }
//        if let levelProgress = resp.levelProgression {
//          print("levelProgress: \(levelProgress)")
//        }
//      }
//    }
//    
//    manager.fetchUserInfo { (result) -> Void in
//      switch result {
//        case .Error(let error):
//          print(error())
//          //handle error
//        case .Response(let response):
//          if let userInfo = response() {
//            print("userInfo: \(userInfo)")
//          }
//          //handle response
//      }
//    }
    
    manager.fetchKanjiList(1) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
        //handle error
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print("userInfo: \(userInfo)")
        }
        if let kanji = resp.kanji {
          print("kanji: \(kanji)")
        }
      }
    }
    
  }
}

