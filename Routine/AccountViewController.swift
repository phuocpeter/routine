//
//  AccountViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UITableViewController {
  
  var managedObjectContext: NSManagedObjectContext!
  var user: User!
  var stats: Stats!
  
  @IBOutlet weak var dobCell: UITableViewCell!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = user.name
    self.stats = user.stats
    setupCells()
  }
  
  func setupCells() {
    dobCell.detailTextLabel?.text = user.dob!.description
  }
  
  // MARK: - UI Table View Controller Methods
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
}
