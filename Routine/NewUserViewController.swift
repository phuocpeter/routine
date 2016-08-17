//
//  ViewController.swift
//  Routine
//
//  Created by Tran Thai Phuoc on 2016-08-16.
//  Copyright © 2016 Tran Thai Phuoc. All rights reserved.
//

import UIKit
import CoreData

class NewUserViewController: UIViewController, UITextFieldDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var managedObjectContext: NSManagedObjectContext?
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var dobSelector: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    managedObjectContext = appDelegate.managedObjectContext
    let today = NSDate()
    dobSelector.maximumDate = today
    nameTextField.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Hide keyboard
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  @IBAction func doneClicked(sender: AnyObject) {
    if let name = nameTextField.text {
      if name == "" { return }
      setupUser()
    }
  }
  
  func setupUser() {
    let userDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext!)
    let profile = NSManagedObject(entity: userDescription!, insertIntoManagedObjectContext: managedObjectContext!)
    profile.setValue(nameTextField.text, forKey: "name")
    profile.setValue(dobSelector.date, forKey: "dob")
    
    do {
      try profile.managedObjectContext?.save()
    } catch {
      print(error)
    }
  }

}

