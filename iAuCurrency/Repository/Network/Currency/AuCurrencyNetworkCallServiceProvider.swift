//
//  AuCurrencyNetworkCallService.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 3/6/19.
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
    private let apiConfiguration: APIConfigurationProvider
    
    public init(networkService: AuCurrencyNetworkService = AuCurrencyNetworkService(), apiConfiguration: APIConfigurationProvider = APIConfigurationProvider(baseUrl: "https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json")) {
        self.networkService = networkService
        self.apiConfiguration = apiConfiguration
    }
    
    
    public func fetchCurrencyData(completion: @escaping (Result<[Product], NSError>) -> Void) {
        
        guard let baseUrl = apiConfiguration.baseUrl, !baseUrl.isEmpty else {
            completion(.failure(NetworkError.apiGatewayConfigurationMissingBaseUrl))
            return
        }
        
        let url = URL(string: baseUrl)!
        
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

