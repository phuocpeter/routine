//
//  Challenge.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData


class Challenge: NSManagedObject {

  /**
   * Initializes the approriate NSPredicate to fetch.
   * - Parameters:
   *   - weekday: an Int represents the weekday. It range from 1 to 7 (Sunday through Saturday).
   * - Returns: the predicate to fetch.
   */
  static func getPredicate(weekday: Int) -> NSPredicate? {
    var id = ""
    switch weekday {
    case 1: // Sunday
      id = "sunday"
      break
    case 2: // Monday
      id = "monday"
      break
    case 3: // Tuesday
      id = "tuesday"
      break
    case 4: // Wednesday
      id = "wednesday"
      break
    case 5: // Thursday
      id = "thursday"
      break
    case 6: // Friday
      id = "friday"
      break
    case 7: // Saturday
      id = "saturday"
      break
    default:
      return nil
    }
    let predicate = NSPredicate(format: "%K == true", id)
    return predicate
  }
  
  /**
   * - Returns: UIImage with the category's name file.
   */
  func getIconImage() -> UIImage! {
    return UIImage(named: category!)
  }
  
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
