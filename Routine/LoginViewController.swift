//
//  LoginViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UITableViewController {
  
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var managedObjectContext: NSManagedObjectContext?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    managedObjectContext = appDelegate.managedObjectContext
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
}
