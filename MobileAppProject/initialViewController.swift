//
//  initialViewController.swift
//  MobileAppProject
//
//  Created by Nutchanon Anurakboonying on 12/9/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import CoreData

class initialViewController: UIViewController,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?


    @IBAction func addPhotoMethod(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            //show gallary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func saveMehod(sender: AnyObject) {
    
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        
        let en = NSEntityDescription.entityForName("User", inManagedObjectContext:context!)
        
        let newItem = User(entity:en!, insertIntoManagedObjectContext:context!)
        
        newItem.name = nameTextField.text!
        
        newItem.weight = weightTextField.text!
        
        newItem.height = heightTextField.text!

        do {
    
            try context?.save()
    
        } catch _ {
    
        }
        
        let imagePath = fileInDocumentsDirectory("profileImage")
        
        if let image = imageView.image {
            saveImage(image, path: imagePath)
        } else{
            print("some error message")
        }
    
    }

    var userName:Array<AnyObject>? = []

    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let jpgImage = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImage!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.size.width/2
        addPhotoButton.clipsToBounds = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let freq = NSFetchRequest(entityName: "User")
        userName = try! context?.executeFetchRequest(freq)
        
        if userName!.count > 0 {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("myMainController") as! SWRevealViewController
            presentViewController(vc, animated: false, completion: nil)
        }else{
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //function that recieve
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.origin.y != -150{
            self.view.frame.origin.y -= 150
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
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
