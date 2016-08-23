//
//  TodayViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-23.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
  var managedObjectContext: NSManagedObjectContext!
  var weekday: Int!
  
  // Fetched Results Controller Initialisation
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetchRequest = NSFetchRequest(entityName: "Challenge")
    let sortDesc = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDesc]
    
    if let predicate = Challenge.getPredicate(self.weekday) {
      fetchRequest.predicate = predicate
    }
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDate() 
    managedObjectContext = appDel.managedObjectContext
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print(error)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - UI Table View Methods
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let sectionInfo = sections[section]
      return sectionInfo.numberOfObjects
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("challengeCell") as! ChallengeCell
    configureCell(cell, withIndexPath: indexPath)
    return cell
  }
  
  func configureCell(cell: ChallengeCell, withIndexPath indexPath: NSIndexPath) {
    let challenge = fetchedResultsController.objectAtIndexPath(indexPath) as! Challenge
    cell.name.text = challenge.name!
    cell.exp.text = "\(challenge.exp!) EXP"
    cell.icon.image = challenge.getIconImage()
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChallengeCell
        configureCell(cell, withIndexPath: indexPath)
      }
      break;
    }
  }
  
  // MARK: - Helper Methods
  
  /** Finds today's date and initialises the weekday variable. */
  func setupDate() {
    let today = NSDate()
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let calComponent = calendar?.component(.Weekday, fromDate: today)
    weekday = calComponent
  }
  
}
