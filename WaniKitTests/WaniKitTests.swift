//
//  WatchKitTests.swift
//  WatchKitTests
//
//  Created by Andriy K. on 9/9/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import XCTest
@testable import WaniKit
import PSOperations

class WaniKitTests: XCTestCase {
  
  let apiManager = WaniKitAPIManager(apiKey: "c6ce4072cf1bd37b407f2c86d69137e3")
  
  func testUserInfo() {
    let expectation = self.expectation(description: "user info OK")
    apiManager.fetchUserInfo { (userInfo, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssert(userInfo?.username == "haawa")
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testLevelProgression() {
    let expectation = self.expectation(description: "level progression OK")
    apiManager.fetchLevelProgression { (levelProgression, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(levelProgression?.kanjiProgress)
      XCTAssert((levelProgression!.kanjiProgress)! > 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testStudyQueue() {
    let expectation = self.expectation(description: "Study queue OK")
    apiManager.fetchStudyQueue { (studyQueue, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(studyQueue?.nextReviewDate)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testKanjiList() {
    let expectation = self.expectation(description: "Kanji list OK")
    apiManager.fetchKanjiList(level: 8)  { (kanjiList, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(kanjiList)
      XCTAssert(kanjiList!.count > 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testRadicalsList() {
    let expectation = self.expectation(description: "Radicals list OK")
    apiManager.fetchRadicalList(level: 8)  { (radicalsList, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(radicalsList)
      XCTAssert(radicalsList!.count > 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testWordsList() {
    let expectation = self.expectation(description: "Words list OK")
    apiManager.fetchWordsList(level: 8)  { (wordsList, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(wordsList)
      XCTAssert(wordsList!.count > 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testDashboardData() {
    let expectation = self.expectation(description: "Dashboard data OK")
    apiManager.fetchDashboard { (dashboardInfo) in
      XCTAssertNotNil(dashboardInfo)
      XCTAssertNotNil(dashboardInfo!.lastLevelUpDate)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testCriticalItemsList() {
    let expectation = self.expectation(description: "Critical items OK")
    apiManager.fetchCriticalItems(maxPercentage: 80)  { (itemsList, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(itemsList)
      XCTAssert(itemsList!.count > 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testRecentUnlocksItemsList() {
    let expectation = self.expectation(description: "Recents OK")
    let limit = 4
    apiManager.fetchRecentUnlocksItems(limit: limit)  { (itemsList, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(itemsList)
      XCTAssert(itemsList!.count == limit)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testLastLevelUp() {
    let expectation = self.expectation(description: "Last level up OK")
    apiManager.fetchLastLevelUp { (date) in
      XCTAssertNotNil(date)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testSRSDistribution() {
    let expectation = self.expectation(description: "SRS OK")
    
    apiManager.fetchSRSDistribution { (srs, responseCode) in
      XCTAssert(responseCode == .Success)
      XCTAssertNotNil(srs)
      XCTAssert(srs!.burned.kanji > 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testAllKanji() {
    let expectation = self.expectation(description: "SRS OK")
    
    apiManager.fetchAllKanji { (kanji) in
      for (index, levelKanji) in kanji {
        if levelKanji.count <= 25 {
          print(index)
        }
        XCTAssert(levelKanji.count > 25 )
      }
      expectation.fulfill()
    }
    waitForExpectations(timeout: 20.0, handler: nil)
  }
  
}
