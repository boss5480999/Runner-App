//
//  TimerViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 11/29/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timer: UILabel!
    
    var time = NSTimer()
    var counter = 0
    var currenttime:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        time = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCounter(){
       
        counter++
        
        let (h, m, s) = convertToTime(counter);
        
        newRunObject.sharedInstance.time = convertToString(h, m: m, s: s)
        timer.text = newRunObject.sharedInstance.time
    }
    
    func convertToTime(totalSeconds: Int) -> (h:Int, m:Int, s:Int){
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        return (hours, minutes, seconds)
    }
    
    func convertToString(h:Int, m:Int, s:Int) -> String {
        
        let h = String(format: "%02d", h)
        let m = String(format: "%02d", m)
        let s = String(format: "%02d", s)
        
        return "\(h):\(m):\(s)"
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
