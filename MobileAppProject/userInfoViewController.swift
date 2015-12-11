//
//  userInfoViewController.swift
//  MobileAppProject
//
//  Created by Nutchanon Anurakboonying on 12/9/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import CoreData

class userInfoViewController: UIViewController {

    var user:Array<AnyObject>? = []
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var name:String = ""
    var weight:String = ""
    var height:String = ""
    
    var data:NSManagedObject?
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()

        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
    }

    override func viewDidAppear(animated: Bool) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let freq = NSFetchRequest(entityName: "User")
        user = try! context?.executeFetchRequest(freq)
        
        data = (user![0] as! NSManagedObject)
        name = data!.valueForKeyPath("name") as! String
        weight = data!.valueForKey("weight") as! String
        height = data!.valueForKey("height") as! String
        
        nameLabel.text = name
        weightLabel.text = weight
        heightLabel.text = height
        
        let imageP = fileInDocumentsDirectory("profileImage")

        imageView.image = loadImageFromPath(imageP)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        return image
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editSegue" {
            
            let EUV:editUserViewController = segue.destinationViewController as! editUserViewController
            
            EUV.nameText = name
            EUV.weightText = weight
            EUV.heightText = height
            EUV.existingItem = data
        }
    }
    

}
