//
//  MainView.swift
//  Restaurants
//
//  Created by MacBook on 25.07.2022.
//

import Foundation
import UIKit

@IBDesignable class MainView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configure()
    }
    
    private func configure() {
        
    }
}
