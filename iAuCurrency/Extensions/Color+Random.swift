//
//  Color+Random.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
   public static var randomColor: UIColor? {
        
        let colorsName: [String] = ["blue_currency","green_currency","orange_currency","purple_currency","red_currency"]
        let color = UIColor(named: colorsName[Int.random(in: 0 ..< colorsName.count)])
        
        return color
    }
}
