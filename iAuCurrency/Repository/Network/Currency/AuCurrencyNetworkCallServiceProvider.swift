//
//  AuCurrencyNetworkCallService.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 5/6/19.
//  
//

import Foundation

public protocol AuCurrencyNetworkCallServiceProvider: class {
    func fetchCurrencyData(completion: @escaping (Result<[Product], NSError>) -> Void)
}


final class AuCurrencyNetworkCallService: AuCurrencyNetworkCallServiceProvider {
    
    // MARK: - Singleton
    static let shared = AuCurrencyNetworkCallService()
    
    // MARK: - Dependencies
    
    private let networkService: AuCurrencyNetworkService
    let environment: Environment
    
    public init(networkService: AuCurrencyNetworkService = AuCurrencyNetworkService(), environment: Environment = Environment()) {
        self.networkService = networkService
        self.environment = environment
    }
    
    
    public func fetchCurrencyData(completion: @escaping (Result<[Product], NSError>) -> Void) {
        
        guard let baseUrl = environment.baseUrl, !baseUrl.isEmpty else {
            completion(.failure(NetworkError.apiGatewayConfigurationMissingUrl))
            return
        }
        
        guard let ratesEndpointUrl = environment.ratesEndpoint, !ratesEndpointUrl.isEmpty else {
            completion(.failure(NetworkError.apiGatewayConfigurationMissingUrl))
            return
        }
        
        let url = URL(string: baseUrl + ratesEndpointUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPRequestType.get.httpMethod
        
        networkService.genericDataTask(withRequest: request) { result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(_, let data):
                    
                    guard let intCurrencyDataResponse = try? JSONDecoder().decode(JSONValue.self, from: data) else {
                        completion(.failure(NetworkError.jsonConversion))
                        return
                    }
                    
                    let productsDictionary = intCurrencyDataResponse.dictionary?["data"]?.dictionary?["Brands"]?.dictionary?["WBC"]?.dictionary?["Portfolios"]?.dictionary?["FX"]?.dictionary?["Products"]
                    
                    guard let _productsDictionary = productsDictionary else {
                        completion(.failure(NetworkError.jsonConversion))
                        return
                    }
                    
                    completion(.success(CurrencyProductMapper.currencyProduct(from: _productsDictionary)))
                }
            }
            
        }
    }
}

