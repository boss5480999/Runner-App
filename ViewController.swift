//
//  ViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 10/1/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData

class ViewController: UIViewController {
    
    //initiallize variables

    @IBOutlet weak var stepCount: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let manager = CMMotionActivityManager()
    
    let pedo = CMPedometer()

    @IBOutlet weak var distanceText: UILabel!
    

    @IBOutlet weak var caloriesText: UILabel!

    var userWeight = 0.00
    
    var UserData:Array<AnyObject>? = []
    
    var caloriesBurned:Double?
    
    //start viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //init date-time to midnight of that day
        
        let calendar = NSCalendar.currentCalendar()
        
        let comps = calendar.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: NSDate())
      
        comps.hour = 0
        
        comps.minute = 0
        
        comps.second = 0
        
        let timez = NSTimeZone.systemTimeZone()
        
        calendar.timeZone = timez
        
        let dayStart  = calendar.dateFromComponents(comps)
        
        //check whether CMMotion is avaliable
        if CMMotionActivityManager.isActivityAvailable() {
            
            self.manager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue()) { data in
                
                if let data = data {
                
                    dispatch_async(dispatch_get_main_queue(), {
                
                        if(data.stationary == true){
                            //self.stage.text = "Stationary"
                        } else if (data.walking == true){
                            //self.stage.text = "Walking"
                        } else if (data.running == true){
                            //self.stage.text = "Running"
                        } else if (data.automotive == true){
                            //self.stage.text = "Automotive"
                        }
                    })
                }
            }
        }

        //Check if have Pedometer
        if CMPedometer.isStepCountingAvailable() {
           
            //set date NOW
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            
            //get History data
            self.pedo.queryPedometerDataFromDate(fromDate, toDate: NSDate()) { (data , error) -> Void in

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                    if(error == nil){
                    
                        self.stepCount.text = "\(data!.numberOfSteps)"
                    
                    }
                })

            }
            
            //Get Counting step since midnight
            self.pedo.startPedometerUpdatesFromDate(dayStart!) { (data, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if error == nil {
                    
                            self.stepCount.text = "\(data!.numberOfSteps)"
                        
                            newRunObject.sharedInstance.numberOfStep = Int(data!.numberOfSteps)
                        
                            let distance = Float(data!.distance!)/1000
                        
                            self.distanceText.text = String(format: "%0.3f", distance)+" km"
                        }
                })
            }
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
//        self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0xF1F900)
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()

        
    }
    //end ViewDidload
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Start viewDidAppear to update calories burned everytime this page is execute
    override func viewDidAppear(animated: Bool) {
    
        //get calories
        updateCaloriesBurned()
        
        caloriesText.text = String(format:"%0.1f",caloriesBurned!) + " kcal"
        print(caloriesBurned)
    }

    
    func updateCaloriesBurned() {
        //fetch data from Database
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        
        let freq = NSFetchRequest(entityName: "User")
        
        UserData = try! context?.executeFetchRequest(freq)
        
        let data:NSManagedObject = UserData![0] as! NSManagedObject
        
        //get weight
        let weight = data.valueForKey("weight") as! String
        
        
        userWeight = Double(weight)!
        
        let caloriesBurnedPerKilo = (userWeight*0.35625)
        
        let caloriesBurnedPerStep = caloriesBurnedPerKilo/1150
        
        caloriesBurned = Double(newRunObject.sharedInstance.numberOfStep)*caloriesBurnedPerStep

    
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


}

