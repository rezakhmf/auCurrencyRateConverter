//
//  Parser.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation

public enum JSONValue: Decodable {
    
    case double(Double)
    case float(Float)
    case string(String)
    case bool(Bool)
    case dictionary([String : JSONValue])
    case array([JSONValue])
    case `nil`
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let value = try? singleValueContainer.decode(Bool.self) {
            self = .bool(value)
            return
        } else if let value = try? singleValueContainer.decode(String.self) {
            self = .string(value)
            return
        } else if let value = try? singleValueContainer.decode(Double.self) {
            self = .double(value)
            return
        } else if let value = try? singleValueContainer.decode(Float.self) {
            self = .float(value)
            return
        }
        else if let value = try? singleValueContainer.decode([String: JSONValue].self) {
            self = .dictionary(value)
            return
        } else if let value = try? singleValueContainer.decode([JSONValue].self) {
            self = .array(value)
            return
        } else if singleValueContainer.decodeNil() {
            self = .nil
            return
        }
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not find reasonable type to map to JSONValue"))
    }
}


