// Copyright (c) 2016 Lebara. All rights reserved.
// Author:  Andrew Kharchyshyn <akharchyshyn@gmail.com>

import Foundation
import PSOperations

public class DashboardInfoGroupOperation: PSOperations.GroupOperation {
  
  private var studyQueue: StudyQueueInfo?
  private var progression: LevelProgressionInfo?
  private var lastLevelUpDate: Date?
  
  public init(baseURL: URL, handler: @escaping (DashboardInfo?) -> Void) {
    
    super.init(operations: [])
    
    let studyQueueOperation = StudyQueueGroupOperation(baseURL: baseURL) { (studyQueue, responseCode) in
      self.studyQueue = studyQueue
    }
    let progressionOperation = LevelProgressionGroupOperation(baseURL: baseURL) { (progression, responseCode) in
      self.progression = progression
    }
    
    let lastLevelUpOperation = LastLevelUpGroupOperation(baseURL: baseURL) { (date) in
      self.lastLevelUpDate = date
    }
    
    let completionOperation = PSOperations.BlockOperation { ( _ ) in
      guard let studyQueue = self.studyQueue, let progression = self.progression else {
        handler(nil)
        return
      }
      let dashboardData = DashboardInfo(levelProgressionInfo: progression, studyQueueInfo: studyQueue, lastLevelUpDate: self.lastLevelUpDate)
      handler(dashboardData)
    }
    
    completionOperation.addDependency(studyQueueOperation)
    completionOperation.addDependency(progressionOperation)
    completionOperation.addDependency(lastLevelUpOperation)
    
    addOperation(studyQueueOperation)
    addOperation(progressionOperation)
    addOperation(lastLevelUpOperation)
    addOperation(completionOperation)
  }
}
