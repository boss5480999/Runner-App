//
//  MapViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 11/29/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var location:Array<CLLocation> = []
    
    var locationManager = CLLocationManager()
    
    var distance = 0.00
    
    var count = 0

    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    var time = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        
       time = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("stopUpdate"), userInfo: nil, repeats: true)
       
        startLocationUpdate()

    }
    
    func stopUpdate(){
        
        if newRunObject.sharedInstance.statusClose {
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    func startLocationUpdate(){
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.activityType = CLActivityType.Fitness
        
        self.locationManager.distanceFilter = 2
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations{
            if newLocation.horizontalAccuracy < 20{
                if self.location.count>0 {
                    self.distance += newLocation.distanceFromLocation(self.location.last!)
                    newRunObject.sharedInstance.distance = self.distance/1000
                }
                self.location.append(newLocation)
                newRunObject.sharedInstance.latitude.append(String(newLocation.coordinate.latitude))
                newRunObject.sharedInstance.longitude.append(String(newLocation.coordinate.longitude))
                updateMap()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMap(){
    
        let location = self.location.last?.coordinate
        
        let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)

        let theRegion:MKCoordinateRegion = MKCoordinateRegion(center: location!,span: theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        
        points.append(location!)
        
        let kph = (locationManager.location?.speed)!*3.6
        
        newRunObject.sharedInstance.speed = kph
        
        let polyLine = MKPolyline(coordinates: &points, count: points.count)
        
        if count != 0 {

            mapView.addOverlay(polyLine)
            
            
        }else{
            count++
        }
    }

    
func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
        polyLineRenderer.strokeColor = UIColor.greenColor()
        polyLineRenderer.lineWidth = 5
        
        return polyLineRenderer
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
