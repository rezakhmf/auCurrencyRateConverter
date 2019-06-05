//
//  NetworkHelpers.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 3/6/19.
//
//

import Foundation

public typealias JSON = [String: Any]

extension URLRequest {
    
    mutating func addHeaders(headers: HTTPHeaders?) {
        guard let headers = headers, !headers.isEmpty else { return }
        for (key, header) in headers {
            self.addValue(header, forHTTPHeaderField: key)
        }
    }
    
}
