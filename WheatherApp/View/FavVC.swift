//
//  FavVC.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit

final class FavVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var favCitiesTableView: UITableView!
    
    var cities = [JsonCities]()
    var currentWeather = [Current]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favCitiesTableView.delegate = self
        favCitiesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchCoreData()
        fetchWeatherData()
    }
    
}

// MARK: Funcs
extension FavVC {
    
    
    
    private func fetchCoreData() {
        
        CoreDataServices().fetchCoreData { jsonCities in
            
            self.cities = jsonCities
            
            DispatchQueue.main.async {
                self.favCitiesTableView.reloadData()
            }
        }
    }
    
    private func fetchWeatherData(){
        
        for city in cities {
            WebService.getCurrentWeather(lat: city.lat!, lon: city.long!) { current in
                guard let current = current else { return }
                self.currentWeather.append(current)
            }
        }
    }
}

extension FavVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = cities[indexPath.row]
        let weather = currentWeather[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        cell.config(city: city, weather: weather)
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let city = cities[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil"){ [self]
            (contextualAction, view, boolValue) in
            
            CoreDataServices().deleteCity(city: city)
            fetchCoreData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
