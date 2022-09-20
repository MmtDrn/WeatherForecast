//
//  FavVC.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit

final class FavVC: UIViewController {
    
    @IBOutlet weak var favCitiesTableView: UITableView!
    
    var cities = [JsonCities]()
    var currentWeather = [Current]()
    private var userDefaultCities = [UserDefaultsModel]()
    private var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favCitiesTableView.delegate = self
        favCitiesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.fetchUserdefaults()
            self.fetchWeatherData()
        }
        
    }
}

// MARK: Funcs
extension FavVC {
    
    private func fetchUserdefaults(){
        
        UserDefaultsServices.userdefaultFetch { userdefaultCities in
            
            self.userDefaultCities = userdefaultCities
            DispatchQueue.main.async {
                self.favCitiesTableView.reloadData()
            }
        }
    }
    
    private func fetchWeatherData(){
        
        for city in userDefaultCities {
            WebService.getCurrentWeather(lat: city.coord.lat!.debugDescription, lon: city.coord.lon!.debugDescription) { current in
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
        return userDefaultCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = userDefaultCities[indexPath.row]
        let weather = currentWeather[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        cell.config(city: city, weather: weather)
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil"){ [weak self]
            (contextualAction, view, boolValue) in
            
            guard let self = self else { return }
            self.userDefaultCities.remove(at: indexPath.row)
            UserDefaultsServices.userdefaultAdd(userDefaultCities: self.userDefaultCities)
            self.fetchUserdefaults()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
