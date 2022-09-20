//
//  FavTableViewCell.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit

class FavTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(city:UserDefaultsModel, weather:Current) {
        
        
        cityNameLabel.text = city.name.capitalized
        degreesLabel.text = String(format: "%0.0f°",weather.temp!)
        weatherDescp.text = weather.weather![0].description!.capitalized
        
        guard let icon = weather.weather![0].icon else { return }
        weatherImage.af.setImage(withURL: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
    }
    
    
}
