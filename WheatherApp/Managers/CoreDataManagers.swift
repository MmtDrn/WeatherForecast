//
//  CoreDataManagers.swift
//  WheatherApp
//
//  Created by MacBook on 4.08.2022.
//

import Foundation
import CoreData

class CoreDataServices {
    
    let context = appDelegate.persistentContainer.viewContext
    
    func fetchCoreData(completion: @escaping ([JsonCities]) -> ()) {
        
        do {
            let cities = try context.fetch(JsonCities.fetchRequest())
            completion(cities)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveCity(city:JsonData) {
        
        let citie = JsonCities(context:context)
        
        citie.id = Int16(truncatingIfNeeded: city.id!)
        citie.name = city.name!
        citie.country = city.country!
        citie.state = city.state
        citie.lat = city.coord!.lat!.debugDescription
        citie.long = city.coord!.lon!.debugDescription
        
        appDelegate.saveContext()
    }  
    
    func deleteCity(city:JsonCities) {
        
        context.delete(city)
        appDelegate.saveContext()
    }
    
}
