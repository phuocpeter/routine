//
//  NewChallengeViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-19.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class NewChallengeViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var managedObjectContext: NSManagedObjectContext?
  var user: User!
  /** 
   * This variable tracks the number of quantity selected
   * by the stepper
   */
  var quantity = 1
  let categories: [String] = ["Appearance", "Intelligence", "Speed", "Strength"]
  let categoryPicker = UIPickerView()
  let schedulePicker = UIPickerView()
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descTextField: UITextView!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var categoryField: UITextField!
  @IBOutlet weak var scheduleField: UITextField!
  
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
    switch pickerView {
    case categoryPicker:
      return categories.count
    case schedulePicker:
      return 1
    default:
      return 0
    }
  }
  
  // MARK: - UI Picker View Delegate Methods
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView {
    case categoryPicker:
      return categories[row]
    default:
      return ""
    }
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView {
    case categoryPicker:
      categoryField.text = categories[row]
      break
    default:
      break
    }
  }
  
  @IBAction func cancelled(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveClicked(sender: AnyObject) {
    if (nameTextField.text == "" || categoryField.text == "" || scheduleField.text == "") {
      return
    }
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
    scheduleField.delegate = self
    schedulePicker.delegate = self
    scheduleField.inputView = schedulePicker
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
    
    do {
      try challenge.managedObjectContext?.save()
      return true
    } catch {
      print(error)
      return false
    }
  }
  
}
