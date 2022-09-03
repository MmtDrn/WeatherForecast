//
//  Hourly.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

struct Hourly:Codable {
    var dt:Date?
    var temp:Double?
    var weather:[Weather]?
}
