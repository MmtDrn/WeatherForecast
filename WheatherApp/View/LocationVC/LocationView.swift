//
//  LocationView.swift
//  Restaurants
//
//  Created by MacBook on 25.07.2022.
//

import UIKit

@IBDesignable class LocationView: MainView {

    @IBOutlet weak var buttonPermission:UIButton!
    @IBOutlet weak var buttonDenclided:UIButton!
    
    var permissionSucces:(() ->Void)?
    var permissionDenclided:(() ->Void)?
    
    @IBAction func getPermission(_ sender:UIButton) {
        permissionSucces?()
    }
    
    @IBAction func getDenclided(_ sender:UIButton) {
        permissionDenclided?()
    }
}
