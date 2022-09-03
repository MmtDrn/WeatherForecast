//
//  LocationVC.swift
//  Restaurants
//
//  Created by MacBook on 25.07.2022.
//

import UIKit

final class LocationVC: UIViewController {
    
    @IBOutlet weak var locationView:LocationView!
    
    var locationServices:LocationServices?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPermission()
        denclidedButton()
        changeLocation()
    }
}

extension LocationVC {
    
    private func getPermission() {
        locationView.permissionSucces = { [weak self] in
            
            self?.locationServices?.getPermisson()
        }
    }
    
    private func denclidedButton() {
        locationView.permissionDenclided = { 
            exit(1)
        }
    }
    
    private func changeLocation() {
        
        locationServices?.changeLocation = { [weak self] auth in
            
            if auth {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "MainTableVC")
                mainVC.modalPresentationStyle = .fullScreen
                
                self?.present(mainVC, animated: true)
            }
        }
    }
}
