//
//  LoginViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  /** Received from AppDelegate. */
  var managedObjectContext: NSManagedObjectContext!
  
  /**
   * Manages fetched results from entity __User__. The results
   * are sorted alphabetically from A to Z.
   * - Returns:
   * The initialised NSFetchedResultsController.
   */
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetchRequest = NSFetchRequest(entityName: "User")
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error)
    }
  }
  
  // MARK: - UI Table View Controller Methods
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let sectionInfo = sections[section]
      return sectionInfo.numberOfObjects
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell")
    configureCell(cell!, withIndexPath: indexPath)
    return cell!
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Allows edit in table view
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    switch editingStyle {
    case .Delete:
      // Deletes user from table view
      let record = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
      managedObjectContext.deleteObject(record)
      saveCoreData()
      break
    default:
      break
    }
  }
  
  func configureCell(cell: UITableViewCell, withIndexPath indexPath: NSIndexPath) {
    // Fetch record
    let record = fetchedResultsController.objectAtIndexPath(indexPath) as! User
    // Setup cell
    cell.textLabel?.text = record.name
  }
  
  // MARK: - Fetched Results Controller Delegate Methods
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    tableView.endUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    // Handle tableView animation
    switch (type) {
    case .Insert:
      // Insert new Row
      if let indexPath = newIndexPath {
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
      break;
    case .Delete:
      // Delete Row
      if let indexPath = indexPath {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
      break;
    case .Move:
      // Move row
      if let indexPath = indexPath {
        // Remove old row
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
      if let newIndexPath = newIndexPath {
        // Add new row
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
      }
      break;
    case .Update:
      // Update Row
      if let indexPath = indexPath {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        configureCell(cell!, withIndexPath: indexPath)
      }
      break;
    }
  }
  
  // MARK: - Prepare Segue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "logIn") {
      let tabBarController = segue.destinationViewController as! UITabBarController
      let navigationController = tabBarController.viewControllers![0] as! UINavigationController
      let controller = navigationController.topViewController as! AccountViewController
      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        let record = fetchedResultsController.objectAtIndexPath(indexPath) as! User
        controller.user = record
        controller.managedObjectContext = self.managedObjectContext
      }
    }
  }

  // MARK: - Helper Methods
  
  /**
   * Saves data.
   */
  func saveCoreData() {
    do {
      try managedObjectContext.save()
    } catch {
      print(error)
    }
  }
  
}
