//
//  CitiesVC.swift
//  WheatherApp
//
//  Created by MacBook on 26.04.2022.
//

import UIKit

final class CitiesVC: UIViewController {
        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var jsonData = [JsonData]()
    private var searchingJsonData = [JsonData]()
    private var userDefaultCities = [UserDefaultsModel]()
    private var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserdefaults()
    }
}

// MARK: Fav Button&Funcs
extension CitiesVC:CitiesProtocol {
    
    func addToFav(indexPath: IndexPath) {
      
        if searching{
            let city = searchingJsonData[indexPath.row]

            let citie = UserDefaultsModel(id: city.id!, name: city.name!, state: city.state!, country: city.country!, coord: city.coord!)
            self.userDefaultCities.append(citie)
            UserDefaultsServices.userdefaultAdd(userDefaultCities: self.userDefaultCities)

        }else{
            let city = (jsonData[indexPath.row])

            let citie = UserDefaultsModel(id: city.id!, name: city.name!, state: city.state!, country: city.country!, coord: city.coord!)
            self.userDefaultCities.append(citie)
            UserDefaultsServices.userdefaultAdd(userDefaultCities: self.userDefaultCities)
        }
    }
    
    func deletefFromFav(indexPath: IndexPath) {
        
        print("delete")
        
    }
    
    private func fetchUserdefaults(){
        
        UserDefaultsServices.userdefaultFetch { userdefaultCities in
            self.userDefaultCities = userdefaultCities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    func setupData(jsondata:[JsonData]) {
        self.jsonData = jsondata
        self.tableView.reloadData()
    }
}

extension CitiesVC:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{
            return searchingJsonData.count
        }else{
            return jsonData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesCell", for: indexPath) as! CitiesTableViewCell
        
        if searching{
            let city = searchingJsonData[indexPath.row]
            var ids = [Int]()
            for citie in self.userDefaultCities {
                ids.append(citie.id)
            }
            if ids.contains(city.id!) {
                cell.configFav(city: city)
            }
        }else{
            let city = jsonData[indexPath.row]
            cell.config(city: city)
            
            var ids = [Int]()
            for citie in self.userDefaultCities {
                ids.append(citie.id)
            }
            if ids.contains(city.id!) {
                cell.config(city: city)
            }
        }
   
        cell.citiesProtocol = self
        cell.indexPath = indexPath
        
        return cell
    }
}

extension CitiesVC:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            self.searching = false
        }else{
            self.searching = true
            
            self.searchingJsonData = self.jsonData.filter({ jsonData in
                jsonData.name!.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}
