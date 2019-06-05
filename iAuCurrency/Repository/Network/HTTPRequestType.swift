//
//  HTTPRequestType.swift
//  iAuCurrency
//
//  Created by Reza Farahanion 3/6/19.
//  
//

import Foundation

public typealias HTTPHeaders = [String: String]

public struct HeaderKeys {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    static let accept = "Accept"
}

public enum HTTPRequestType {
    /// - get: GET
    case get
    /// - head: HEAD
    case head
    /// - delete: DELETE
    case delete
    /// - put: PUT - With the JSON to POST
    case put(JSON)
    /// - post: POST - With the JSON to POST
    case post(JSON)
    
    /// HTTP Method.
    public var httpMethod: String {
        switch self {
        case .get:
            return "GET"
        case .head:
            return "HEAD"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .post:
            return "POST"
        }
    }
    
    /// Create a HTTP Request from the HTTPRequestType
    public var request: URLRequest? {
        let request = NSMutableURLRequest()
        request.httpMethod = httpMethod
        request.addValue(HeaderKeys.applicationJSON, forHTTPHeaderField: HeaderKeys.accept)
        switch self {
        case .post(let json), .put(let json):
            guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions()) else { return nil }
            request.addValue(HeaderKeys.applicationJSON, forHTTPHeaderField: HeaderKeys.contentType)
            request.httpBody = data
        default:
            break
        }
        return request as URLRequest
    }
    
    /// Build a URL request from the HTTPRequestType.
    ///
    /// - Parameters:
    ///   - url: The request URL.
    ///   - headers: Any headers that need to be added to the request.
    /// - Returns: A `URLRequest` to use with NetworkService.
    public func makeRequest(withURL url: URL, headers: HTTPHeaders?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addHeaders(headers: headers)
        return request
    }
}
