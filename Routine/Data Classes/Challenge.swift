//
//  Challenge.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import Foundation
import CoreData


class Challenge: NSManagedObject {

  /**
   * Iterates through the object's schedule and appends the days
   * in the schedule.
   * - Returns: an array of days in the schedule.
   */
  func getScheduleArray() -> [Bool] {
    var scheduleArray: [Bool] = []
    scheduleArray += [monday.boolValue]
    scheduleArray += [tuesday.boolValue]
    scheduleArray += [wednesday.boolValue]
    scheduleArray += [thursday.boolValue]
    scheduleArray += [friday.boolValue]
    scheduleArray += [saturday.boolValue]
    scheduleArray += [sunday.boolValue]
    return scheduleArray
  }

}
