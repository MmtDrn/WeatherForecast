//
//  JsonData.swift
//  WheatherApp
//
//  Created by MacBook on 26.04.2022.
//

import Foundation

struct JsonDataResult:Codable {
    
    var jsonData:[JsonData]?
}

struct JsonData:Codable {
    
    var id:Int?
    var name:String?
    var state:String?
    var country:String?
    var coord:Coordinate?
}

struct Coordinate:Codable {
    var lon:Double?
    var lat:Double?
}
