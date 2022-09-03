//
//  Daily.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

struct Daily:Codable {
    
    var dt:Date?
    var temp:Temp?
    var weather:[Weather]?
}
