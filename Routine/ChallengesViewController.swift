//
//  ChallengesViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-17.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class ChallengesViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  var user: User!
  var managedObjectContext: NSManagedObjectContext!
  
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetchRequest = NSFetchRequest(entityName: "Challenge")
    let sortDesc = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDesc]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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
    // Fetchs challenge
    let challenge = fetchedResultsController.objectAtIndexPath(indexPath) as! Challenge
    cell.name.text = challenge.name!
    cell.exp.text = "\(challenge.exp!.doubleValue) EXP"
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    switch editingStyle {
    case .Delete:
      let record = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
      managedObjectContext.deleteObject(record)
      saveCoreData()
      break
    default:
      break
    }
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
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

  // MARK: - Prepare for Segue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "addChallenge" {
      let navigation = segue.destinationViewController as! UINavigationController
      let controller = navigation.topViewController as! NewChallengeViewController
      controller.user = self.user
    }
    if segue.identifier == "challengeDetailView" {
      let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
      let challengeChosen = fetchedResultsController.objectAtIndexPath(indexPath!) as! Challenge
      let controller = segue.destinationViewController as! ChallengeDetailViewController
      controller.challenge = challengeChosen
    }
  }
  
  // MARK: - Helper Methods
  
  func saveCoreData() {
    do {
      try managedObjectContext.save()
    } catch {
      print(error)
    }
  }
  
}
