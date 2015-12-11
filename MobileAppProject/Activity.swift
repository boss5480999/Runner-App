//
//  Locations.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 12/6/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import Foundation
import CoreData

@objc(Activity)
class Activity:NSManagedObject {
    @NSManaged var latitude:String
    @NSManaged var longitude:String
    @NSManaged var distance:String
    @NSManaged var name:String
    @NSManaged var key:String
    @NSManaged var time:String
    @NSManaged var calories:String

}