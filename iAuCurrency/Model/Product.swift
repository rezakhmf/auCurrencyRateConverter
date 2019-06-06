//
//  Products.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 5/6/19.
//  
//

import Foundation

// MARK: - Product
public struct Product: Codable {
    let currencyCode, currencyName, country: String?
    let buyTT, sellTT, buyTC, buyNotes, sellNotes: String?
    let spotRateDateFmt: String?
    let effectiveDateFmt, updateDateFmt: String?
    let lastupdated: String?
}
