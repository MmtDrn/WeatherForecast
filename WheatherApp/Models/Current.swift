//
//  Current.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

struct Current:Codable {
    
    var dt:Date?
    var temp:Double?
    var weather:[Weather]?
}
