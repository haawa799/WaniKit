//
//  WaniParsedDataTests.swift
//  WaniKit
//
//  Created by Andriy K. on 3/24/17.
//  Copyright © 2017 @haawa799. All rights reserved.
//

import XCTest
@testable import WaniKit

class WaniParsedDataTests: XCTestCase {
  
  func testEmptyInitialisation() {
    do {
      let _ = try WaniParsedData(root: [String : Any]())
    } catch let error as ParsingError {
      XCTAssert(error == ParsingError.noUserInfo)
    } catch {}
  }
  
  func testOnlyUserInfo() {
    do {
      let _ = try WaniParsedData(root: ["user_information": ["":0]])
    } catch let error as ParsingError {
      XCTAssert(error == ParsingError.noRequestedInfo)
    } catch {}
  }
  
  func testRequestedInfoIncorrect() {
    do {
      let _ = try WaniParsedData(root: ["user_information": ["":0], "requested_information": 0])
    } catch let error as ParsingError {
      XCTAssert(error == ParsingError.requestedInfoNotCorrect)
    } catch {}
  }
}
