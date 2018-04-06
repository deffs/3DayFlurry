//
//  Globals.swift
//  3DayFlurry
//
//  Created by Alex de France on 4/5/18.
//  Copyright © 2018 Def Labs. All rights reserved.
//

import Foundation



let startURL = "https://api.wunderground.com/api/fe91ae8fda75e6a9/forecast/q/"

var state: String?
var city: String?

typealias DownloadComplete = () -> ()

struct WeatherData {
    var icon: String?
    var title: String?
    var text: String?
    var highTemp: String?
    var lowTemp: String?
}
