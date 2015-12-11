//
//  editUserViewController.swift
//  MobileAppProject
//
//  Created by Nutchanon Anurakboonying on 12/9/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import CoreData

class editUserViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var nameText:String = ""
    
    var weightText:String = ""
    
    var heightText:String = ""
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    var existingItem:NSManagedObject?
    
    var imagePicker = UIImagePickerController()

    @IBAction func changePictureMethod(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let jpgImage = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImage!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    @IBAction func saveMethod(sender: AnyObject) {
        
        
        if(existingItem != nil){
            
            existingItem?.setValue(nameTextField.text, forKey: "name")
            
            existingItem?.setValue(weightTextField.text, forKey: "weight")
            
            existingItem?.setValue(heightTextField.text, forKey: "height")
            
        }

        let imagePath = fileInDocumentsDirectory("profileImage")
        
        if let image = imageVIew.image {
            saveImage(image, path: imagePath)
        } else{
            print("some error message")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(false)

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.blackColor()


        // Do any additional setup after loading the view.
        if existingItem != nil{
            nameTextField.text = nameText
            weightTextField.text = weightText
            heightTextField.text = heightText
        }
        let imageP = fileInDocumentsDirectory("profileImage")
        
        imageVIew.image = loadImageFromPath(imageP)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        imageVIew.layer.borderWidth = 1.0
        imageVIew.layer.masksToBounds = false
        imageVIew.layer.borderColor = UIColor.whiteColor().CGColor
        imageVIew.layer.cornerRadius = imageVIew.frame.size.width/2
        imageVIew.clipsToBounds = true
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.size.width/2
        addPhotoButton.clipsToBounds = true

    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        return image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageVIew.image = image
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.origin.y != -150{
            self.view.frame.origin.y -= 150
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
