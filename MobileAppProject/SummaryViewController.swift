//
//  SummaryViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anarukbunying on 12/6/2558 BE.
//  Copyright © 2558 Nutchanon Anarukbunying. All rights reserved.
//

import UIKit
import CoreData

    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }

    func fileInDocumentsDirectory(filename: String) -> String {
    
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    
    }

class SummaryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var dbList:Array<AnyObject>? = []
    
    var imagePicker: UIImagePickerController!
    
    var saveTime:String = ""
    
    var calories = ""
    
    @IBAction func doneMethod(sender: AnyObject) {
        saveActivity()
        newRunObject.sharedInstance.latitude.removeAll()
        newRunObject.sharedInstance.longitude.removeAll()
        newRunObject.sharedInstance.distance = 0
        newRunObject.sharedInstance.statusClose = false
        newRunObject.sharedInstance.time = ""
    }
    
    @IBAction func takePhotoMethod(sender: UIButton) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let jpgImage = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImage!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: "cameraicon")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveActivity(){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Activity")
        
        if nameTextField.text != ""  {
            
            let pred = NSPredicate(format: "(name == %@)", nameTextField.text!)
            request.predicate = pred
            dbList = try! context?.executeFetchRequest(request)
        
        }
        
        
        if dbList?.count > 0 {
            
            let userTakenAlert = UIAlertController(title: "Error", message: "Username is already taken. Please choose another one", preferredStyle: UIAlertControllerStyle.Alert)
            
            userTakenAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(userTakenAlert, animated: true, completion: nil)
            
        }else{

            let formatter = NSDateFormatter()
            
            formatter .dateStyle = .MediumStyle
            formatter .timeStyle = .ShortStyle
            
            
            let name = formatter.stringFromDate(NSDate())

            
            for var i = 0 ; i < newRunObject.sharedInstance.latitude.count ; i++ {
                
                let en = NSEntityDescription.entityForName("Activity", inManagedObjectContext: context!)
               
                let newItem = Activity(entity:en! , insertIntoManagedObjectContext: context!)
                
                newItem.latitude = newRunObject.sharedInstance.latitude[i]
                
                newItem.longitude = newRunObject.sharedInstance.longitude[i]
                
                newItem.key = String(i)
                
                newItem.distance = String(newRunObject.sharedInstance.distance)
                
                newItem.time = saveTime
                
                newItem.calories = calories
                
                if nameTextField.text != "" {
                    newItem.name = nameTextField.text!
                }else{
                    newItem.name = String(name)
                    print("save Autoname")
                }
            
                do {
                    try context?.save()
                }catch _ {
                
                }
            }
            
                if nameTextField.text != "" {
                
                    let imagePath = fileInDocumentsDirectory(nameTextField.text!)
                
                            if let image = imageView.image {
                                saveImage(image, path: imagePath)
                                print("withName")
                            } else{
                                print("some error message")
                    }
                }else{
                    let imagePath = fileInDocumentsDirectory(name)
                    if let image = imageView.image {
                        saveImage(image, path: imagePath)
                        print("autoName")
                    } else {
                        print("some error message")
                    }
                }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
