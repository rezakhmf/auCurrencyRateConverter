//
//  Enironment.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 6/6/19.
//  Copyright © Farahani Consulting. All rights reserved.
//

import Foundation

/// Networking environment.
public struct Environment {
    
    private let configuration: ConfigurationProvider
    
    init(configuration: ConfigurationProvider = Configuration.shared) {
        self.configuration = configuration
    }
    
    var baseUrl: String? {
        return  configuration.endpoints.baseURL
    }
    
    var ratesEndpoint: String? {
        return configuration.endpoints.ratesEndpoint
    }
}
