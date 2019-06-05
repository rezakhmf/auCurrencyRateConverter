//
//  APIConfigurationProvider.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 3/6/19.
//  
//

import Foundation

public struct APIConfigurationProvider {
    
    public var baseUrl: String?

    public init(baseUrl: String){
        
        self.baseUrl = baseUrl
    }
}
