//
//  ActivityViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 11/28/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var activity:Array<AnyObject>? = []
    
    var nameNotDuplicate:Array<String> = []
    
    var existing = ""
    var imagePath:Array<String> = []
    var distance:Array<Double> = []
    var time:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let freq = NSFetchRequest(entityName: "Activity")
        activity = try! context?.executeFetchRequest(freq)
        
        nameNotDuplicate.removeAll()
        existing = ""
        
        for var i = 0 ; i<activity!.count; i++ {
            let data:NSManagedObject = activity![i] as! NSManagedObject
            let name = data.valueForKeyPath("name") as! String
            let tim = data.valueForKey("time") as! String
            
            if name == existing {
            
            }else{
                
                let imageP = fileInDocumentsDirectory(name)
                let dis = data.valueForKey("distance") as! String
                print(dis)
                existing = name
                nameNotDuplicate.append(name)
                imagePath.append(imageP)
                distance.append(Double(dis)!)
                time.append(tim)
            }
            
        }
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameNotDuplicate.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = nameNotDuplicate[indexPath.row]
        let image = loadImageFromPath(imagePath[indexPath.row])
        cell.detailTextLabel!.text = String(format: "%0.3f", distance[indexPath.row])+" km  time: " + time[indexPath.row]
        cell.imageView?.image = resizeImage(image!,newWidth:100)
        cell.imageView?.layer.borderWidth = 1.0
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.borderColor = UIColor.whiteColor().CGColor
        cell.imageView?.layer.cornerRadius = 100/2
        cell.imageView?.clipsToBounds = true
        cell.imageView?.contentMode = .ScaleAspectFill
        return cell
    }

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        //let scale = newWidth / image.size.width
        let newHeight = CGFloat(100)
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
    
        if segue.identifier == "showMapSegue"{
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let selectedItem = nameNotDuplicate[indexPath.row]
            
            let SMH:showMapHistoryViewController = segue.destinationViewController as! showMapHistoryViewController
            
            SMH.pathname = selectedItem
    
        }
    }

}
