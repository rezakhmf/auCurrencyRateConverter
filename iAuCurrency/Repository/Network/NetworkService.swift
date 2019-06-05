//
//  NetworkService.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 3/6/19.
//
//

import Foundation
import UIKit

// MARK: NetworkService

/// Network Service used to handle requests.
open class AuCurrencyNetworkService: NSObject, URLSessionDelegate {
    
    // MARK: Keys
    
    public enum Authorization {
        case basic(clientSecret: String)
        case bearer(accessToken: String)
        
        var header: String {
            switch self {
            case .basic(clientSecret: let clientSecret):
                return "Basic \(clientSecret)"
            case .bearer(accessToken: let accessToken):
                return "Bearer \(accessToken)"
            }
        }
    }
    
    public struct Keys {
        static let authorization = "Authorization"
        static let errorDomain = "iAuCurrencyNetworking"
        public static let errorResponseBody = "errorResponseBody"
        public static let errorResponseJSON = "errorResponseJSON"
    }
    
    // MARK: Completion Handlers
    
    /// Data task completion handler.
    public typealias DataTaskCompletionHandler = (Result<(URLResponse, Data), NSError>) -> Void
    
    /// JSON task completion handler.
    public typealias DataTaskJSONCompletionHandler = (Result<(URLResponse, JSON), NSError>) -> Void
    
    /// Download task completion handler.
    public typealias DownloadTaskCompletionHandler = (Result<(URLResponse, URL), NSError>) -> Void
    
    /// Image task completion handler.
    public typealias ImageDownloadCompletionHandler = (Result<UIImage, NSError>) -> Void
    
    public private(set) var session: URLSession!
    
    // MARK: Network Service
    
    public init(configuration: URLSessionConfiguration = .default) {
        super.init()
        session = makeSession(configuration: configuration)
    }
    
    /// Designated initializer.
    private override init() {
        super.init()
    }
    
    /// HTTP Request timeout. Set before making the first network request.
    public var requestTimeout: TimeInterval = 60
    
    deinit {
        finishTasksAndInvalidate()
    }
    
    /// The default URLSession for handling network requests.
    private func makeSession(configuration: URLSessionConfiguration) -> URLSession {
        configuration.timeoutIntervalForRequest = requestTimeout
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }
    
    // MARK: Generic HTTP Requests
    
    /// Generic asynchronous network request that will be started immediately. Fully customizable with an `URLRequest`.
    ///
    /// - Parameters:
    ///   - request: An `URLRequest` object.
    ///   - completion: Upon success, returns the `Data` and `URLHTTPResponse`. Failure will return an `NSError`.
    /// - Returns: The corresponding `URLSessionDataTask` created by `URLSession` that will handle the request. This may be used to cancel the request.
    @discardableResult open func genericDataTask(withRequest request: URLRequest,
                                                 authorization: Authorization? = nil,
                                                 completion: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        var mutableRequest = request
        
        if let authorization = authorization {
            mutableRequest.addValue(authorization.header, forHTTPHeaderField: Keys.authorization)
        }
        
        let task = session.dataTask(with: mutableRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else {
                    if let data = data, let response = response, let httpResponse = response as? HTTPURLResponse {
                        if (httpResponse.statusCode >= 200) && (httpResponse.statusCode < 300) {
                            completion(.success((response, data)))
                        } else {
                            var userInfo: [String: Any] = [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode), Keys.errorResponseBody: data]
                            
                            if let errorJSON = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? JSON {
                                userInfo[Keys.errorResponseJSON] = errorJSON
                            }
                            
                            let serverError = NSError(domain: Keys.errorDomain, code: httpResponse.statusCode, userInfo: userInfo)
                            completion(.failure(serverError))
                        }
                    } else {
                        completion(.failure(NetworkError.unknown))
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    /// Generic synchronous network request that will be started immediately. Fully customizable with an `URLRequest`. Returns `JSON` instead of `Data`.
    ///
    /// - Parameters:
    ///   - request: An `URLRequest` object.
    ///   - completion: Upon success, returns `JSON` and `URLHTTPResponse`. Failure will return an `NSError`.
    /// - Returns: The corresponding `URLSessionDataTask` created by `URLSession` that will handle the request. This may be used to cancel the request.
    @discardableResult open func genericJSONDataTask(withRequest request: URLRequest,
                                                     authorization: Authorization? = nil,
                                                     completion: @escaping DataTaskJSONCompletionHandler) -> URLSessionDataTask {
        let task = genericDataTask(withRequest: request, authorization: authorization) { result in
            switch result {
            case .success(let (response, data)):
                // If data is empty, but status is success. We pass through empty data (or else the serialization would fail).
                if data.isEmpty,
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 204 {
                    completion(.success((response, JSON())))
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSON else {
                        completion(.failure(NetworkError.jsonConversion))
                        return
                    }
                    completion(.success((response, json)))
                } catch (let error) {
                    completion(.failure(error as NSError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    /// Generic asynchronous network download request that will be started immediately. Fully customizable with an `URLRequest`.
    ///
    /// - Parameters:
    ///   - request: A `URLRequest` object.
    ///   - completion: Upon success, returns a filepath `URL` and `URLHTTPResponse`. Failure will return an NSError.
    /// - Returns: The corresponding `URLSessionDownloadTask` created by `URLSession` that will handle the request. This may be used to cancel the request.
    @discardableResult open func genericDownloadTask(withRequest request: URLRequest,
                                                     authorization: Authorization? = nil,
                                                     completion: @escaping DownloadTaskCompletionHandler) -> URLSessionDownloadTask {
        var mutableRequest = request
        
        if let authorization = authorization {
            mutableRequest.addValue(authorization.header, forHTTPHeaderField: Keys.authorization)
        }
        
        let task = session.downloadTask(with: mutableRequest) { (url: URL?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    completion(.failure(error))
                } else {
                    guard let url = url, let response = response else {
                        completion(.failure(NetworkError.unknown))
                        return
                    }
                    completion(.success((response, url)))
                }
            }
        }
        task.resume()
        return task
    }
    
    // MARK: Convenience HTTP REST Data Methods
    
    /// Asynchronous network request that will be started immediately using a request type (`.get` or `.post`)
    ///
    /// - Parameters:
    ///   - requestType: The `HTTPRequestType` object. E.g. `.get` or `.post(JSON)`.
    ///   - headers: Any extra HTTP headers.
    ///   - url: The request URL.
    ///   - completion:  Upon success, returns the `Data` and `URLHTTPResponse`. Failure will return an `NSError`.
    /// - Returns: The corresponding `URLSessionDataTask` created by `URLSession` that will handle the request. This may be used to cancel the request.
    @discardableResult open func performDataTask(requestType: HTTPRequestType,
                                                 authorization: Authorization? = nil,
                                                 additionalHeaders headers: HTTPHeaders?,
                                                 url: URL,
                                                 completion: @escaping DataTaskCompletionHandler) -> URLSessionDataTask? {
        guard var request = requestType.request else {
            completion(.failure(NetworkError.dataConversion))
            return nil
        }
        
        request.url = url
        request.addHeaders(headers: headers)
        
        return genericDataTask(withRequest: request, authorization: authorization, completion: completion)
    }
    
    /// Asynchronous network request that will be started immediately using a request type (`.get` or `.post`)
    ///
    /// - Parameters:
    ///   - requestType: The `HTTPRequestType` object. E.g. `.get` or `.post(JSON)`.
    ///   - headers: Any extra HTTP headers.
    ///   - url: The request URL.
    ///   - completion:  Upon success, returns `JSON` and `URLHTTPResponse`. Failure will return an `NSError`.
    /// - Returns: The corresponding URLSessionDataTask created by URLSession that will handle the request. This may be used to cancel the request.
    @discardableResult open func performJSONDataTask(requestType: HTTPRequestType,
                                                     authorization: Authorization? = nil,
                                                     additionalHeaders headers: HTTPHeaders?,
                                                     url: URL,
                                                     completion: @escaping DataTaskJSONCompletionHandler) -> URLSessionDataTask? {
        guard var request = requestType.request else {
            completion(.failure(NetworkError.dataConversion))
            return nil
        }
        
        request.url = url
        request.addHeaders(headers: headers)
        
        return genericJSONDataTask(withRequest: request, authorization: authorization, completion: completion)
    }
    
    // MARK: Downloading Data
    
    /// Asynchronous network request to download data with a URL.
    ///
    /// - Parameters:
    ///   - url: `URL` to the data.
    ///   - progressHandler: An optional progress handler that will get called with the progress completed so far.
    ///   - completion: Upon success, returns a filepath `URL` and `URLHTTPResponse`. Failure will return an `NSError`.
    /// - Returns: The corresponding `URLSessionDownloadTask` created by `URLSession` that will handle the request. This may be used to cancel the request.
    @discardableResult open func downloadData(withURL url: URL,
                                              authorization: Authorization? = nil,
                                              completion: @escaping DownloadTaskCompletionHandler) -> URLSessionDownloadTask {
        return genericDownloadTask(withRequest: URLRequest(url: url), authorization: authorization, completion: completion)
    }
    
    // MARK: Downloading UIImage
    
    /// Asynchronous network request to retrieve an image using an image URL.
    ///
    /// - Parameters:
    ///   - url: The image URL.
    ///   - completion: Upon success, returns a `UIImage`. Failure will return an `NSError`.
    /// - Returns: The corresponding `URLSessionDataTask` created by `URLSession` that will handle the request. This may be used to cancel the request.
    @discardableResult open func getImage(withURL url: URL,
                                          completion: @escaping ImageDownloadCompletionHandler) -> URLSessionDataTask? {
        let task = performDataTask(requestType: .get, additionalHeaders: ["Accept": "image/*"], url: url) { result in
            switch result {
            case .success(let (_, data)):
                guard let image = UIImage(data: data) else {
                    completion(.failure(NetworkError.imageCreation))
                    return
                }
                completion(.success(image))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    // MARK: Session Cancelling
    
    /// Cancels any current requests and the serivces URLSession.
    /// Call this before releasing the iAuCurrencyNetworkService instance to prevent retain cycles.
    public func cancelAndInvalidateService() {
        session.invalidateAndCancel()
    }
    
    /// Finishes any current requests and the serivces URLSession.
    /// Call this before releasing the iAuCurrencyNetworkService instance to prevent retain cycles.
    public func finishTasksAndInvalidate() {
        session.finishTasksAndInvalidate()
    }
    
}

