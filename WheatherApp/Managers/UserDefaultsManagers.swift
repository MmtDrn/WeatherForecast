//
//  UserDefaultsManagers.swift
//  WheatherApp
//
//  Created by mehmet duran on 20.09.2022.
//

import Foundation

class UserDefaultsServices {
    
    static func userdefaultAdd(userDefaultCities:[UserDefaultsModel]) {
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userDefaultCities)
            UserDefaults.standard.set(data, forKey: "cities")
            print("successss")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func userdefaultFetch(completion: @escaping ([UserDefaultsModel]) -> ()) {
        
        if let data = UserDefaults.standard.data(forKey: "cities") {
            
            do {
                let decoder = JSONDecoder()
               let userDefaultCities = try decoder.decode([UserDefaultsModel].self, from: data)
                completion(userDefaultCities)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
