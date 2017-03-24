//
//  WaniKitTests.swift
//  WaniKitTests
//
//  Created by Andriy K. on 9/19/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import XCTest
@testable import WaniKit
import Promise
import WaniModel

class WaniKitManagerTests: XCTestCase {

  let manager = WaniKitManager(apiKey: "thisApiKeyIsIgnoredBecauseOfStubs")
  let timeOut: TimeInterval = 0.5

  override func tearDown() {
    super.tearDown()
    removeAllStubs()
  }

  func testUserInfo() {
    stubJson("level-progression")
    let exp = expectation(description: "userInfo")
    manager.fetchUserInfo().then { (userInfo) in
      XCTAssert(userInfo.username == "haawa")
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testLevelProgression() {
    stubJson("level-progression")
    let exp = expectation(description: "levelProgression")
    manager.fetchLevelProgression().then { (levelProgression) in
      XCTAssert(levelProgression.userInfo.level == 22)
      XCTAssert(levelProgression.kanjiTotal! > 0)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testCriticalItems() {
    stubJson("critical-items")
    let exp = expectation(description: "critical items")
    manager.fetchCriticalItems(percentage: 85).then { (criticalItems) in
      XCTAssert(criticalItems.count > 0)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testRadicals() {
    stubJson("radicals")
    let exp = expectation(description: "radicals")
    manager.fetchRadicalPromise(level: 20).then { (radicals) in
      XCTAssert(radicals.count == 4)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testKanji() {
    stubJson("kanji")
    let exp = expectation(description: "kanji")
    manager.fetchKanjiPromise(level: 200).then { (kanji) in
      XCTAssert(kanji.count == 32)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: 200, handler: nil)
  }

  func testVocab() {
    stubJson("vocabulary")
    let exp = expectation(description: "vocabulary")
    manager.fetchVocabPromise(level: 20).then { (words) in
      XCTAssert(words.count == 6)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testRecents() {
    stubJson("recent-unlocks")
    let exp = expectation(description: "recents")
    let limit = 5
    manager.fetchRecentUnlocks(limit: limit).then { (items) in
      XCTAssert(items.count == limit)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testSrs() {
    stubJson("srs-distribution")
    let exp = expectation(description: "srs-distribution")
    manager.fetchSRS().then { (srs) in
      XCTAssert(srs.burned.kanji == 577)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testStudyQueue() {
    stubJson("study-queue")
    let exp = expectation(description: "studyQueue")
    manager.fetchStudyQueue().then { (studyQueue) in
      XCTAssert(studyQueue.lessonsAvaliable == 63)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testLastLevelUp() {
    stubJson("recent-unlocks")
    let exp = expectation(description: "levelUp")
    manager.fetchLastLevelUp().then { (date) in
      XCTAssert(date.timeIntervalSince1970 == 1485630028)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut, handler: nil)
  }

  func testDashboard() {
    stubJson("study-queue")
    stubJson("srs-distribution")
    stubJson("level-progression")
    stubJson("recent-unlocks")
    let exp = expectation(description: "dashboard")
    manager.fetchDashboard().then { (dashboard) in
      XCTAssert(dashboard.levelProgressionInfo.kanjiTotal == 31)
      exp.fulfill()
      }.catch { (error) in
        debugPrint(error)
    }
    waitForExpectations(timeout: timeOut * 4, handler: nil)
  }
}
