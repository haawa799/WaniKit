//
//  Test.swift
//  WaniKit
//
//  Created by Andriy K. on 3/13/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import XCTest
import WaniKit

class EndpointZeroTests: XCTestCase {
  
  var manager: WaniApiManager!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    manager = WaniApiManager(testBaseURL: Endpoint.Zero)
    manager.setApiKey(testAPIKey)
  }
  
  func testStudyQueue() {
    
    // given
    var user: UserInfo!
    var studyQueue: StudyQueueInfo!
    let expectation = expectationWithDescription("Study queue success")
    
    // when
    manager.fetchStudyQueue { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        
        expectation.fulfill()
        
        let resp = response()
        if let userInfo = resp.userInfo {
          user = userInfo
          
          XCTAssertEqual(user.level!, 10)
          XCTAssertEqual(user.username, "haawa")
          XCTAssertEqual(user.postsCount, 56)
          XCTAssertEqual(user.topicsCount, 2)
        }
        if let studyQueueInfo = resp.studyQInfo {
          studyQueue = studyQueueInfo
          
          XCTAssertEqual(studyQueue.lessonsAvaliable, 0)
          XCTAssertEqual(studyQueue.reviewsAvaliable, 0)
          XCTAssertEqual(studyQueue.reviewsNextHour, 0)
          XCTAssertEqual(studyQueue.reviewsNextDay, 0)
        }
      }
    }
    
    // then
    waitForExpectationsWithTimeout(2.5, handler: nil)
  }
  
  func testLevelProgression() {
    // given
    var user: UserInfo!
    var levelProgress: LevelProgressionInfo!
    let expectation = expectationWithDescription("Study queue success")
    
    // when
    
    manager.fetchLevelProgression { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        expectation.fulfill()
        let resp = response()
        if let userInfo = resp.userInfo {
          user = userInfo
          XCTAssertEqual(user.level!, 10)
          XCTAssertEqual(user.username, "haawa")
          XCTAssertEqual(user.postsCount, 56)
          XCTAssertEqual(user.topicsCount, 2)
        }
        if let levelProgressInfo = resp.levelProgression {
          levelProgress = levelProgressInfo
          XCTAssertEqual(levelProgress.radicalsProgress, 0)
          XCTAssertEqual(levelProgress.radicalsTotal, 14)
          XCTAssertEqual(levelProgress.kanjiProgress, 0)
          XCTAssertEqual(levelProgress.kanjiTotal, 38)
        }
      }
    }
    // then
    waitForExpectationsWithTimeout(2.5, handler: nil)
  }
  
  func q() {
    
    manager.fetchUserInfo { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp {
          print(userInfo)
        }
      }
    }
    
    manager.fetchRadicalsList(7) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let radicals = resp.radicals {
          print(radicals)
        }
      }
    }
    
    manager.fetchKanjiList(8) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let kanji = resp.kanji {
          print(kanji)
        }
      }
    }
    
    manager.fetchVocabList(9) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let vocab = resp.vocab {
          print(vocab)
        }
      }
    }
    
    manager.fetchCriticalItems(85) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let criticalItems = resp.criticalItems {
          print(criticalItems)
        }
      }
    }
    
  }
  
}
