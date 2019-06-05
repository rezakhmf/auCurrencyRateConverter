//
//  Parser+Conveniece.swift
//  iAuCurrency
//
//  Created by Reza Farahani on 5/6/19.
//  Copyright © 2019 Farahani Consulting. All rights reserved.
//

import Foundation

// MARK: - Convenience
extension JSONValue {
    public var string: String? {
        switch self {
        case .string(let value):
            return value
        default:
            return nil
        }
    }
    public var double: Double? {
        switch self {
        case .double(let value):
            return value
        default:
            return nil
        }
    }
    public var float: Float? {
        switch self {
        case .float(let value):
            return value
        default:
            return nil
        }
    }
    public var bool: Bool? {
        switch self {
        case .bool(let value):
            return value
        default:
            return nil
        }
    }
    public var dictionary: [String: JSONValue]? {
        switch self {
        case .dictionary(let value):
            return value
        default:
            return nil
        }
    }
    public var array: [JSONValue]? {
        switch self {
        case .array(let value):
            return value
        default:
            return nil
        }
    }
    public var isNil: Bool {
        switch self {
        case .nil:
            return true
        default:
            return false
        }
    }
}
