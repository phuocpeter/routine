//
//  User.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

  /**
   * Converts NSDate to a medium date string.
   * - Returns: Medium style date string.
   */
  func getDOBString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = .MediumStyle
    return dateFormatter.stringFromDate(self.dob)
  }
  
  /**
   * Finds the approximate age of the user.
   * - Returns: The age in years.
   */
  func getAge() -> Double {
    let ageInSeconds = self.dob.timeIntervalSinceNow
    let ageInYears = ageInSeconds / 31104000 * (-1)
    return ageInYears
  }
  
}
