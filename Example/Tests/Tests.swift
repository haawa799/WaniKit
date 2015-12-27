// https://github.com/Quick/Quick

import Quick
import Nimble
import WaniKit

struct Endpoint {
  static let Zero = "http://haawa.org/test/wanikani/0"
  static let One = "http://haawa.org/test/wanikani/1"
  static let Two = "http://haawa.org/test/wanikani/2"
}


let doneText = "done"
let testAPIKey = "69b9b1f682946cbc42d251f41f2863d7"

class StudyQueueSpec: QuickSpec {
  override func spec() {
    
    NSURLCache.sharedURLCache().removeAllCachedResponses()
    
    describe("Test version #0 Study Q") { () -> () in
      let manager = WaniApiManager(testBaseURL: Endpoint.Zero)
      manager.setApiKey(testAPIKey)
      
      var user: UserInfo!
      var studyQueue: StudyQueueInfo!
      
      var time = "passing"
      
      it("Response is correct", closure: { () -> () in
        
        manager.fetchStudyQueue({ result -> Void in
          switch result {
          case .Error(let error):
            print(error())
          case .Response(let response):
            let resp = response()
            if let userInfo = resp.userInfo {
              user = userInfo
            }
            if let studyQueueInfo = resp.studyQInfo {
              studyQueue = studyQueueInfo
            }
          }
          time = doneText
        })
        
        waitUntil(timeout: 2.5, action: { (done) -> Void in
          NSThread.sleepForTimeInterval(2.0)
          expect(time) == doneText
          expect(user.level) == 10
          expect(user.username) == "haawa"
          expect(user.postsCount) == 56
          expect(user.topicsCount) == 2
          
          expect(studyQueue.lessonsAvaliable) == 0
          expect(studyQueue.reviewsAvaliable) == 0
          expect(studyQueue.reviewsNextHour) == 0
          expect(studyQueue.reviewsNextDay) == 0
          
          done()
        })
      })
    }
    
    describe("Test version #1 Study Q") { () -> () in
      let manager = WaniApiManager(testBaseURL: Endpoint.One)
      manager.setApiKey(testAPIKey)
      
      var user: UserInfo!
      var studyQueue: StudyQueueInfo!
      
      var time = "passing"
      
      manager.fetchStudyQueue({ (result) -> Void in
        switch result {
        case .Error(let error):
          print(error())
        case .Response(let response):
          let resp = response()
          if let userInfo = resp.userInfo {
            user = userInfo
          }
          if let studyQueueInfo = resp.studyQInfo {
            studyQueue = studyQueueInfo
          }
        }
        time = doneText
      })
      
      it("Response is correct", closure: { () -> () in
        waitUntil(timeout: 2.5, action: { (done) -> Void in
          NSThread.sleepForTimeInterval(2.0)
          expect(time) == doneText
          expect(user.level) == 10
          expect(user.username) == "haawa"
          expect(user.postsCount) == 56
          expect(user.topicsCount) == 2
          

          expect(studyQueue.lessonsAvaliable) == 2
          expect(studyQueue.reviewsAvaliable) == 3
          expect(studyQueue.reviewsNextHour) == 10
          expect(studyQueue.reviewsNextDay) == 30
          
          done()
        })
      })
    }
    
    describe("Test version #3 Study Q") { () -> () in
      let manager = WaniApiManager(testBaseURL: Endpoint.Two)
      manager.setApiKey(testAPIKey)
      
      var user: UserInfo!
      var studyQueue: StudyQueueInfo!
      
      var time = "passing"
      
      manager.fetchStudyQueue({ result -> Void in
        switch result {
        case .Error(let error):
          print(error())
        case .Response(let response):
          let resp = response()
          if let userInfo = resp.userInfo {
            user = userInfo
          }
          if let studyQueueInfo = resp.studyQInfo {
            studyQueue = studyQueueInfo
          }
        }
        time = doneText
      })
      
      it("Response is correct", closure: { () -> () in
        waitUntil(timeout: 2.5, action: { (done) -> Void in
          NSThread.sleepForTimeInterval(2.0)
          expect(time) == doneText
          expect(user.level) == 11
          expect(user.username) == "haawa"
          expect(user.postsCount) == 56
          expect(user.topicsCount) == 2
          
          let q = studyQueue
          print(q)
          
          expect(studyQueue.lessonsAvaliable) == 20
          expect(studyQueue.reviewsAvaliable) == 30
          expect(studyQueue.reviewsNextHour) == 100
          expect(studyQueue.reviewsNextDay) == 300
          
          done()
        })
      })
    }
  }
}


class LevelProgressionSpec: QuickSpec {
  override func spec() {
    
    NSURLCache.sharedURLCache().removeAllCachedResponses()
    
    describe("Test version #0 Level Progression") { () -> () in
      let manager = WaniApiManager(testBaseURL: Endpoint.Zero)
      manager.setApiKey(testAPIKey)
      
      var user: UserInfo!
      var levelProgress: LevelProgressionInfo!
      
      var time = "passing"
      
      it("Response is correct", closure: { () -> () in
        
        manager.fetchLevelProgression({ result -> Void in
          switch result {
          case .Error(let error):
            print(error())
          case .Response(let response):
            let resp = response()
            if let userInfo = resp.userInfo {
              user = userInfo
            }
            if let levelProgressInfo = resp.levelProgression {
              levelProgress = levelProgressInfo
            }
          }
          time = doneText
        })
        
        waitUntil(timeout: 2.5, action: { (done) -> Void in
          NSThread.sleepForTimeInterval(2.0)
          expect(time) == doneText
          expect(user.level) == 10
          expect(user.username) == "haawa"
          expect(user.postsCount) == 56
          expect(user.topicsCount) == 2
          
          expect(levelProgress.radicalsProgress) == 0
          expect(levelProgress.radicalsTotal) == 14
          expect(levelProgress.kanjiProgress) == 0
          expect(levelProgress.kanjiTotal) == 38
          
          done()
        })
      })
    }
    
    
    describe("Test version #1 Level Progression") { () -> () in
      let manager = WaniApiManager(testBaseURL: Endpoint.One)
      manager.setApiKey(testAPIKey)
      
      var user: UserInfo!
      var levelProgress: LevelProgressionInfo!
      
      var time = "passing"
      
      it("Response is correct", closure: { () -> () in
        
        manager.fetchLevelProgression({ result -> Void in
          switch result {
          case .Error(let error):
            print(error())
          case .Response(let response):
            let resp = response()
            if let userInfo = resp.userInfo {
              user = userInfo
            }
            if let levelProgressInfo = resp.levelProgression {
              levelProgress = levelProgressInfo
            }
          }
          time = doneText
        })
        
        waitUntil(timeout: 2.5, action: { (done) -> Void in
          NSThread.sleepForTimeInterval(2.0)
          expect(time) == doneText
          expect(user.level) == 10
          expect(user.username) == "haawa"
          expect(user.postsCount) == 56
          expect(user.topicsCount) == 2
          
          expect(levelProgress.radicalsProgress) == 5
          expect(levelProgress.radicalsTotal) == 14
          expect(levelProgress.kanjiProgress) == 10
          expect(levelProgress.kanjiTotal) == 38
          
          done()
        })
      })
    }
    
    describe("Test version #2 Level Progression") { () -> () in
      let manager = WaniApiManager(testBaseURL: Endpoint.Two)
      manager.setApiKey(testAPIKey)
      
      var user: UserInfo!
      var levelProgress: LevelProgressionInfo!
      
      var time = "passing"
      
      it("Response is correct", closure: { () -> () in
        
        manager.fetchLevelProgression({ result -> Void in
          switch result {
          case .Error(let error):
            print(error())
          case .Response(let response):
            let resp = response()
            if let userInfo = resp.userInfo {
              user = userInfo
            }
            if let levelProgressInfo = resp.levelProgression {
              levelProgress = levelProgressInfo
            }
          }
          time = doneText
        })
        
        waitUntil(timeout: 2.5, action: { (done) -> Void in
          NSThread.sleepForTimeInterval(2.0)
          expect(time) == doneText
          expect(user.level) == 11
          expect(user.username) == "haawa"
          expect(user.postsCount) == 56
          expect(user.topicsCount) == 2
          
          expect(levelProgress.radicalsProgress) == 10
          expect(levelProgress.radicalsTotal) == 14
          expect(levelProgress.kanjiProgress) == 25
          expect(levelProgress.kanjiTotal) == 38
          
          done()
        })
      })
    }
    
  }
}
