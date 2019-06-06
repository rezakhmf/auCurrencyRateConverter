//
//  CurrencyViewModel.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation

public protocol CurrencyViewModelProvider {
    func fetchCurrencies( completion: @escaping ([Product]) -> Void)
}

public class CurrencyViewModel: CurrencyViewModelProvider {
    
    // MARK: - Dependencies
    
    private let networkService: AuCurrencyNetworkCallService = AuCurrencyNetworkCallService.shared
    
    
    public func fetchCurrencies(completion: @escaping ([Product]) -> Void) {
        
        networkService.fetchCurrencyData { currencyData in
            switch currencyData {
            case .failure(let error):
                print(error.description)
            case .success(let currencyProducts):
                completion(currencyProducts)
            }
        }
    }
}
