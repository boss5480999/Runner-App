//
//  newRunObject.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 12/6/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import Foundation

class newRunObject {
    var latitude:Array<String> = []
    var longitude:Array<String> = []
    var distance:Double = 0.00
    var speed:Double = 0.00
    var time:String = ""
    var statusClose = false
    var numberOfStep = 0
    static let sharedInstance = newRunObject()
}