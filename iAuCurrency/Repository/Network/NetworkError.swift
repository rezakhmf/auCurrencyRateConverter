//
//  AuCurrencyNetworkCall.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 5/6/19.
//  
//

import Foundation

let errorDomain = "iAuConverter Network Domain"

public enum NetworkError: Error {
    
    // MARK: Error definitions
    
    public static let unknown = NSError(domain: errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Response did not contain any data"])
    
    public static let jsonConversion = NSError(domain: errorDomain,
                                               code: 1,
                                               userInfo: [NSLocalizedDescriptionKey: "Could not convert response data to JSON"])
    
    public static let imageCreation = NSError(domain: errorDomain,
                                              code: 2,
                                              userInfo: [NSLocalizedDescriptionKey: "Could not create image from reponse data"])
    
    
    public static let dataConversion = NSError(domain: errorDomain,
                                               code: 3,
                                               userInfo: [NSLocalizedDescriptionKey: "Could not convert JSON (aka dictionary) to valid data"])
    
    public static let apiGatewayConfigurationMissingUrl = NSError(domain: errorDomain,
                                                                      code: 4,
                                                                      userInfo: [NSLocalizedDescriptionKey: "the baseUrl is not provided"])
    
    public static let apiGatewayConfigurationMissingOauthUrl = NSError(domain: errorDomain,
                                                                       code: 5,
                                                                       userInfo: [NSLocalizedDescriptionKey: "the oauthUrl is not provided"])
    
    public static let apiGatewayConfigurationMissingConsumerKey = NSError(domain: errorDomain,
                                                                          code: 6,
                                                                          userInfo: [NSLocalizedDescriptionKey: "the consumer key is not provided"])
    
    public static let apiGatewayConfigurationMissingConsumerSecret = NSError(domain: errorDomain,
                                                                             code: 7,
                                                                            userInfo: [NSLocalizedDescriptionKey: "the consumer secret key is not provided"])
    
}


