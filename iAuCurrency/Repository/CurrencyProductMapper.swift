//
//  CurrencyProductMapper.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation

public class CurrencyProductMapper {
    
    public static func currencyProduct(from jsonValue: JSONValue) -> [Product] {
        
        
        var products: [Product] = []
        
        
        var currencyCode: String = ""
        var currencyName: String = ""
        var country: String = ""
        var buyTT:  String = ""
        var sellTT: String = ""
        var buyTC: String = ""
        var buyNotes: String = ""
        var sellNotes: String = ""
        var spotRateDateFmt: String = ""
        var effectiveDateFmt: String = ""
        var updateDateFmt: String = ""
        var lastupdated: String = ""
        
        for(keys, vals) in jsonValue.dictionary ?? [:] {
            if let _product = vals.dictionary?["Rates"]?.dictionary?[keys] {
                for(key, val) in _product.dictionary ?? [:] {
                    if key == "country" {
                        country = val.string!
                        
                    } else if key == "currencyName" {
                        currencyName = val.string!
                    }
                    else if key == "currencyCode" {
                        currencyCode = val.string!
                    }
                    else if key == "buyTT" {
                        buyTT = val.string!
                    }
                    else if key == "sellTT" {
                        sellTT = val.string!
                    }
                    else if key == "buyTC" {
                        buyTC = val.string!
                    }
                    else if key == "buyNotes" {
                        buyNotes = val.string!
                    }
                    else if key == "sellNotes" {
                        sellNotes = val.string!
                    }
                    else if key == "SpotRate_Date_Fmt" {
                        spotRateDateFmt = val.string!
                    }
                    else if key == "effectiveDate_Fmt" {
                        effectiveDateFmt = val.string!
                    }
                    else if key == "updateDate_Fmt" {
                        updateDateFmt = val.string!
                    }
                    else if key == "LASTUPDATED" {
                        lastupdated = val.string!
                    }
                    
                }
                let product = Product(currencyCode: currencyCode, currencyName: currencyName,
                                      country: country, buyTT: buyTT,
                                      sellTT: sellTT, buyTC: buyTC,
                                      buyNotes: buyNotes, sellNotes: sellNotes,
                                      spotRateDateFmt: spotRateDateFmt, effectiveDateFmt: effectiveDateFmt,
                                      updateDateFmt: updateDateFmt, lastupdated: lastupdated)
                
                products.append(product)
            }
        }
        
        return products
    }
}
