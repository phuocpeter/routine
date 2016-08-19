//
//  NewChallengeViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-19.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class NewChallengeViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ScheduleViewControllerDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var managedObjectContext: NSManagedObjectContext?
  var user: User!
  var scheduleSelection: [Bool]?
  /** 
   * This variable tracks the number of quantity selected
   * by the stepper
   */
  var quantity = 1
  let categories: [String] = ["Appearance", "Intelligence", "Speed", "Strength"]
  let categoryPicker = UIPickerView()
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descTextField: UITextView!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var categoryField: UITextField!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    managedObjectContext = appDelegate.managedObjectContext
    setupViews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - UI Table View Methods
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if indexPath.row == 4 { return indexPath }
    return nil
  }
  
  // MARK: - UI Text Field Delegate Methods
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: - UI Picker View Data Source Methods
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categories.count
  }
  
  // MARK: - UI Picker View Delegate Methods
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categories[row]
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    categoryField.text = categories[row]
  }
  
  @IBAction func cancelled(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveClicked(sender: AnyObject) {
    if (nameTextField.text == "" || categoryField.text == "") { return }
    if scheduleSelection == nil { return }
    var selected = false
    for sel in scheduleSelection! {
      if sel {
        selected = true
        break
      }
    }
    if !selected { return }
    if saveNewChallenge() {
      self.dismissViewControllerAnimated(true, completion: nil)
    } else {
      print("Save failed")
    }
  }
  
  @IBAction func quantityChanged(sender: UIStepper) {
    quantity = Int(sender.value)
    quantityLabel.text = "\(quantity)"
  }
  
  // MARK: - Prepare for Segue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "scheduleView" {
      let controller = segue.destinationViewController as! ScheduleViewController
      controller.delegate = self
      if let sel = scheduleSelection {
        controller.selection = sel
      }
    }
  }
  
  // MARK: - Schedule View Controller Delegate Methods
  
  func scheduleViewDidFinish(controller: ScheduleViewController) {
    self.scheduleSelection = controller.selection
  }
  
  // MARK: - Helper Methods
  
  /**
   * Setups picker views by assigning category and schedule's
   * text fields to be picker views. Assigns "self" as the
   * picker views' delegate.
   */
  func setupViews() {
    nameTextField.delegate = self
    categoryField.delegate = self
    categoryPicker.delegate = self
    categoryField.inputView = categoryPicker
  }
  
  /**
   * Saves new challenge to core data.
   * - Returns: true if saves successfullly / false if exception caught.
   */
  func saveNewChallenge() -> Bool {
    let challengeEntity = NSEntityDescription.entityForName("Challenge", inManagedObjectContext: managedObjectContext!)
    let challenge = NSManagedObject(entity: challengeEntity!, insertIntoManagedObjectContext: managedObjectContext!) as! Challenge
    // Sets value for object
    challenge.setValue(nameTextField.text, forKey: "name")
    challenge.setValue(descTextField.text, forKey: "desc")
    challenge.setValue(quantity, forKey: "quantity")
    challenge.setValue(categoryField.text, forKey: "category")
    challenge.setValue(0, forKey: "times")
    challenge.setValue(1, forKey: "exp")
    challenge.setValue(user, forKey: "user")
    challenge.setValue(scheduleSelection![0], forKey: "monday")
    challenge.setValue(scheduleSelection![1], forKey: "tuesday")
    challenge.setValue(scheduleSelection![2], forKey: "wednesday")
    challenge.setValue(scheduleSelection![3], forKey: "thursday")
    challenge.setValue(scheduleSelection![4], forKey: "friday")
    challenge.setValue(scheduleSelection![5], forKey: "saturday")
    challenge.setValue(scheduleSelection![6], forKey: "sunday")
    
    do {
      try challenge.managedObjectContext?.save()
      return true
    } catch {
      print(error)
      return false
    }
  }
  
}
