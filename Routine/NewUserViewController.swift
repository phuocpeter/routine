//
//  ViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-16.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UITableViewController, UITextFieldDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var managedObjectContext: NSManagedObjectContext?
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var dobSelector: UIDatePicker!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    managedObjectContext = appDelegate.managedObjectContext
    // Setup UI
    let today = NSDate()
    dobSelector.maximumDate = today
    nameTextField.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - UI Text Field Delegate Methods
  
  /** Hides keyboard on RETURN. */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: - UI Table View Controller Methods
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
  /**
   * Checks if information is valid then saves and dimisses the
   * view.
   */
  @IBAction func doneClicked(sender: AnyObject) {
    if let name = nameTextField.text {
      if name == "" { return }
      setupUser()
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  /**
   * Dimisses view without saving.
   */
  @IBAction func cancelled(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /**
   * Adds user's profile into database. User's profile includes
   * name, date of birth and empty stats.
   */
  func setupUser() {
    let userEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
    let profile = NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: managedObjectContext!)
    profile.setValue(nameTextField.text, forKey: "name")
    profile.setValue(dobSelector.date, forKey: "dob")
    
    // Adds empty stats to profile
    let statsEntity = NSEntityDescription.entityForName("Stats", inManagedObjectContext: managedObjectContext!)
    let stats = NSManagedObject(entity: statsEntity!, insertIntoManagedObjectContext: managedObjectContext!)
    
    profile.setValue(stats, forKey: "stats")
    
    do {
      try profile.managedObjectContext?.save()
    } catch {
      print(error)
    }
  }

}

