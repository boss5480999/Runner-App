//
//  User.swift
//  MobileAppProject
//
//  Created by Nutchanon Anurakboonying on 12/9/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class User:NSManagedObject {
    @NSManaged var name:String
    @NSManaged var weight:String
    @NSManaged var height:String
}