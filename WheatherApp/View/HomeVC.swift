//
//  ViewController.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit
import CoreLocation
import AlamofireImage

final class HomeVC: UIViewController {
    
    let locationmanager = CLLocationManager()
    
    var lat:String?
    var long:String?
    
    @IBOutlet weak var imageCurrent: UIImageView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var currentWeather = Current()
    var hourlyWeather = [Hourly]()
    var dailyWeather = [Daily]()
    var jsonData = [JsonData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        getData()
        setupCurrent()
        configView()
    }
    
    @objc func citiesVC() {
     
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let citiesVC = storyboard.instantiateViewController(withIdentifier: "CitiesVC") as! CitiesVC
        DispatchQueue.main.async {
            citiesVC.setupData(jsondata: self.jsonData)
        }
        present(citiesVC, animated: true)
    }
    
}

// MARK: Funcs
extension HomeVC {
    
    func locationSetup(){
        
        if let lokasyon = locationmanager.location {
            lat = lokasyon.coordinate.latitude.debugDescription
            long = lokasyon.coordinate.longitude.debugDescription
        }
    }
    
    func setupCurrent(){
        
        currentLabel.text = String(format: "%0.0f°\n\(currentWeather.weather![0].description!.capitalized)",currentWeather.temp!)
        
        guard let icon = currentWeather.weather![0].icon else { return }
        imageCurrent.af.setImage(withURL: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
    }
    
    func getData(){
        
        guard let lat = lat, let long = long  else { return }
        
        WebService.getCurrentWeather(lat: lat, lon: long) { [weak self] currently in
            
            guard let currently = currently else { return }
            self?.currentWeather = currently
        }
        WebService.getDailyWeather(lat: lat, lon: long) { [weak self] daily in
            
            guard let daily = daily else { return }
            for indeks in 0...6 {
                self?.dailyWeather.append(daily[indeks])
            }
        }
        WebService.getHourlyWeather(lat: lat, lon: long) { [weak self] hourly in
            
            guard let hourly = hourly else { return }
            for indeks in 0...23 {
                self?.hourlyWeather.append(hourly[indeks])
            }
        }
        WebService.shared.getCities { [weak self] cities in
            guard let cities = cities else { return }
            self?.jsonData = cities
        }
        
    }
    
    private func configView() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(citiesVC))
        
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
        hourlyCollectionView.collectionViewLayout = layout
    }
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let daily = dailyWeather[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyTableViewCell
        
        cell.config(daily: daily)
        
        return cell
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let hourly = hourlyWeather[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCollectionViewCell
        
        cell.config(hourly: hourly)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
