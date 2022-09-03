//
//  GetData.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

enum WeatherForecast {
    
    case Daily(lat:String,lon:String)
    case Current(lat:String,lon:String)
    case Hourly(lat:String,lon:String)
    case Cities
    
    var url:URL {
        switch self {
        case .Daily(let lat, let lon):
            return URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts,hourly,current&lang=tr&appid=1d835fa8095dc0443598e78b3d71882a")!
            
        case .Current(let lat, let lon):
            return URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts,hourly,daily&lang=tr&appid=1d835fa8095dc0443598e78b3d71882a")!
            
        case .Hourly(let lat, let lon):
            return URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts,daily,current&lang=tr&appid=1d835fa8095dc0443598e78b3d71882a")!
        case .Cities:
            return URL(string: "https://raw.githubusercontent.com/MmtDrn/CitiesData/master/cityList.json")!
        }
    }
}

class WebService {
    
    static var shared = WebService()
    private let citiesAPI = "https://raw.githubusercontent.com/MmtDrn/CitiesData/master/cityList.json"
    
    static func getDailyWeather(lat:String,lon:String,completion: @escaping ([Daily]?) -> ()) {
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: WeatherForecast.Daily(lat: lat, lon: lon).url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        let daily = try? JSONDecoder().decode(DailyResponse.self, from: data)
            
            if let daily = daily {
                completion(daily.daily)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    static func getHourlyWeather(lat:String,lon:String,completion: @escaping ([Hourly]?) -> ()) {
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: WeatherForecast.Hourly(lat: lat, lon: lon).url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        let hourly = try? JSONDecoder().decode(HourlyResponse.self, from: data)
            
            if let hourly = hourly {
                completion(hourly.hourly)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    static func getCurrentWeather(lat:String,lon:String,completion: @escaping (Current?) -> ()) {
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: WeatherForecast.Current(lat: lat, lon: lon).url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        let current = try? JSONDecoder().decode(CurrentResponse.self, from: data)
            
            if let current = current {
                completion(current.current)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getCities(completion: @escaping ([JsonData]?) -> ()) {
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: citiesAPI)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        DispatchQueue.global().async {
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
              guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
              }
                let cities = try? JSONDecoder().decode(JsonDataResult.self, from: data)
                
                if let data = cities?.jsonData {
                    completion(data)
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        }
    }
}
