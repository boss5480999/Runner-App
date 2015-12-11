//
//  showMapHistoryViewController.swift
//  MobileAppProject
//
//  Created by Nutchanon Anurakboonying on 12/8/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class showMapHistoryViewController: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!

    
    var pathname = ""
    
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    var dbList:Array<AnyObject>? = []
    
    var count = 0
    
    var minLat = 0.00
    
    var maxLat = 0.00
    
    var minLong = 0.00
    
    var maxLong = 0.00
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationItem.title = pathname
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.blackColor()
        // Do any additional setup after loading the view.
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext? = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Activity")
        let pred = NSPredicate(format: "(name == %@)", pathname)
        request.predicate = pred
        //let sortDescriptor = NSSortDescriptor(key: "key", ascending: true)
        //request.sortDescriptors = [sortDescriptor]
        
        dbList = try! context?.executeFetchRequest(request)
        
        for var i = 0 ; i < dbList!.count ; i++ {
            let data:NSManagedObject = dbList![i] as! NSManagedObject
            let latitude = data.valueForKeyPath("latitude") as! String
            let longitude = data.valueForKeyPath("longitude") as! String

            if i == 0 {
                minLat = Double(latitude)!
                maxLat = Double(latitude)!
                minLong = Double(longitude)!
                maxLong = Double(longitude)!
            }else{
                if Double(latitude) < minLat {
                    
                    minLat = Double(latitude)!
                    
                }else{
                    if Double(latitude) > maxLat
                    {
                        maxLat = Double(latitude)!
                    }
                }
                if Double(longitude) < minLong {

                        minLong = Double(longitude)!
                    
                }else{
                    if Double(longitude) > maxLong {
                        
                        maxLong = Double(longitude)!
                        
                    }
                }
            }
            
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
            points.append(location)
        }
        updateMapView()
        let data:NSManagedObject = dbList![0] as! NSManagedObject
        let distance = data.valueForKey("distance") as! String
        let time = data.valueForKey("time") as! String
        let cal = data.valueForKey("calories") as! String
        distanceLabel.text = String(format: "%.1f", Double(distance)!)
        timeLabel.text =  time
        caloriesLabel.text = String(format: "%.1f", Double(cal)!)
        
        let imageP = fileInDocumentsDirectory(pathname)

        let image = loadImageFromPath(imageP)
        imageView.image = image
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true


    }
    
    func updateMapView(){
        
        let theSpan: MKCoordinateSpan = MKCoordinateSpanMake((maxLat-minLat)*1.1, (maxLong-minLong)*1.1)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((minLat+maxLat)/2), longitude: ((minLong+maxLong)/2))
        
        let theRegion:MKCoordinateRegion = MKCoordinateRegion(center: location,span: theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        
        let polyLine = MKPolyline(coordinates: &points, count: (points.count))
        
        mapView.addOverlay(polyLine)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {

        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = UIColor.greenColor()
            polyLineRenderer.lineWidth = 5

        return polyLineRenderer
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
