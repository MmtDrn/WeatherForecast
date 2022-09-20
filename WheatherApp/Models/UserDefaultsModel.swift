//
//  struct.swift
//  WheatherApp
//
//  Created by mehmet duran on 18.09.2022.
//

import Foundation

struct UserDefaultsModel:Codable {
    
    var id:Int
    var name:String
    var state:String
    var country:String
    var coord:Coordinate
}

struct StructCoordinate:Codable {
    var lon:Double
    var lat:Double
}
