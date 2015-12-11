//
//  RunningViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 11/29/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
///Users/Boss/Desktop/MobileAppProject/MobileAppProject/MobileAppProject.entitlements

import UIKit
import CoreData

class RunningViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    var timer = NSTimer()
    
    var time:String = ""
    
    var UserData:Array<AnyObject>? = []
    
    var lastDistance = 0.00
    
    var weight = ""
    
    @IBOutlet weak var caroriesLabel: UILabel!
    
    var userWeight = 0.00
    
    var collectSpeed:Array<Double> = []
    
    var caloriesBurned = 0.00
    
    @IBAction func finishedMethod(sender: AnyObject) {

        let MVC:MapViewController = MapViewController()

        MVC.locationManager.stopUpdatingLocation()
        
        newRunObject.sharedInstance.statusClose = true
        
        time = newRunObject.sharedInstance.time
        
        print(time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        distanceLabel.text = String(newRunObject.sharedInstance.distance)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: Selector("updateDistance"), userInfo: nil, repeats: true)
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let freq = NSFetchRequest(entityName: "User")
        UserData = try! context?.executeFetchRequest(freq)
        let data:NSManagedObject = UserData![0] as! NSManagedObject
        weight = data.valueForKey("weight") as! String
        userWeight = Double(weight)!
        
        distanceLabel.text = "0.0"
        caroriesLabel.text = "0.0"
        speedLabel.text = "0.0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDistance(){
        
        distanceLabel.text = String(format: "%0.1f", newRunObject.sharedInstance.distance)
        
        collectSpeed.append(newRunObject.sharedInstance.speed)
        
        //let avgSpeed = getAvgSpeed()
        
        if newRunObject.sharedInstance.distance != lastDistance {
            caloriesBurned = caloriesBurned+(newRunObject.sharedInstance.distance * userWeight)
            lastDistance = newRunObject.sharedInstance.distance
        }
        
        speedLabel.text = String(format:"%0.1f", newRunObject.sharedInstance.speed)
        
        caroriesLabel.text = String(format:"%0.1f", caloriesBurned)
    }
    
    func getAvgSpeed()->Double{
        var avgSpeed = 0.00
        for var i = 0 ; i < collectSpeed.count; i++ {
            
            avgSpeed = avgSpeed+collectSpeed[i]
            
        }
        
        avgSpeed = avgSpeed/Double(collectSpeed.count)
        
        return avgSpeed
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "toSumSegue" {
            
            let SMV:SummaryViewController = segue.destinationViewController as! SummaryViewController
            
            SMV.saveTime = time
            SMV.calories = String(caloriesBurned)
        }     
    }
    
}
