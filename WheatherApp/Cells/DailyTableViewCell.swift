//
//  DailyTableViewCell.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dereceLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(daily:Daily) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: daily.dt!)
        
        dateLabel.text = dayName
        dereceLabel.text = String(format: "%0.0f°",daily.temp!.day!)
        weatherDesc.text = daily.weather![0].description!.capitalized
        
        guard let icon = daily.weather![0].icon else { return }
        weatherImage.af.setImage(withURL: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!)
    }
}
