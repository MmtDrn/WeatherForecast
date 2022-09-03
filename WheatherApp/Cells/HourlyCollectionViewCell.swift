//
//  HourlyCollectionViewCell.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit
import AlamofireImage

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    func config(hourly:Hourly) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let hour = dateFormatter.string(from: hourly.dt!)
        
        degreeLabel.text = String(format: "%0.0f°",hourly.temp!)
        hourLabel.text = hour
        
        if let icon = hourly.weather![0].icon {
            weatherImage.af.setImage(withURL: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
        }
    }
}
