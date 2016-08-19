//
//  ScheduleViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-19.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit

protocol ScheduleViewControllerDelegate {
  /**
   * Triggers when the schedule view finishes.
   * - Parameters:
   *   - controller: the ScheduleViewController
   */
  func scheduleViewDidFinish(controller: ScheduleViewController)
}

class ScheduleViewController: UITableViewController {
  
  var delegate: ScheduleViewControllerDelegate?
  let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  /** Tracks the selection of the day of week. Starts from Monday to Sunday. */
  var selection = [false, false, false, false, false, false, false]
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    delegate?.scheduleViewDidFinish(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return days.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath)
    cell.textLabel?.text = days[indexPath.row]
    if selection[indexPath.row] {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      let row = indexPath.row
      if (cell.accessoryType == .None) {
        cell.accessoryType = .Checkmark
        selection[row] = true
      } else {
        cell.accessoryType = .None
        selection[row] = false
      }
      cell.selected = false
    }
  }
  
}
