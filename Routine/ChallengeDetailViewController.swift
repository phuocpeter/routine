//
//  ChallengeDetailViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-21.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: UITableViewController {
  
  var challenge: Challenge!
  var scheduleArray: [Bool]!
  
  /** Collections of UI Table View Cell for schedule section. */
  @IBOutlet var scheduleCellsCollection: [UITableViewCell]!
  @IBOutlet weak var descField: UITextView!
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var timesLabel: UILabel!
  @IBOutlet weak var expLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
  // MARK: - Helper Methods
  
  /** Injects information into the view. */
  func setupView() {
    title = challenge.name
    categoryLabel.text = challenge.category
    timesLabel.text = "\(challenge.times!)"
    expLabel.text = "\(challenge.exp!)"
    if challenge.desc == "" {
      descField.text = "No Description"
    } else {
      descField.text = challenge.desc
    }
    setupScheduleCells()
  }
  
  /** Adds checkmark to scheduled cells. */
  func setupScheduleCells() {
    scheduleArray = challenge.getScheduleArray()
    for index in 0 ..< scheduleArray.count {
      if scheduleArray[index] {
        scheduleCellsCollection[index].accessoryType = .Checkmark
      }
    }
  }
  
}
