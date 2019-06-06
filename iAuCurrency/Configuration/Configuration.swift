//
//  Configuration.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 6/6/19.
//  Copyright © Farahani Consulting. All rights reserved.
//

import Foundation

protocol ConfigurationProvider: class {
    var endpoints: EndpointConfig { get }
}

struct EndpointConfig: Codable {
    let baseURL: String
    let ratesEndpoint: String
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "BaseUrl"
        case ratesEndpoint = "RatesEndpoint"
    }
}

private struct Config: Codable {
    let endpoints: EndpointConfig
    
    enum CodingKeys: String, CodingKey {
        case endpoints = "Endpoints"
    }
}

/// App Configuration obtained from bundled Config.plist
class Configuration: ConfigurationProvider {
    
    static var shared: Configuration = {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist") else {
            fatalError("Config.plist not found in target")
        }
        guard let config = Configuration(plistURL: url) else {
            fatalError("Unable to read Config.plist")
        }
        return config
    }()
    
    let endpoints: EndpointConfig
    
    init?(plistURL url: URL) {
        guard let data = try? Data(contentsOf: url),
            let config = try? PropertyListDecoder().decode(Config.self, from: data) else {
                print("Unable to read \(url.absoluteString)")
                return nil
        }
        self.endpoints = config.endpoints
        
    }
}
