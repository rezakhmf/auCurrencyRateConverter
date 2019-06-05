//
//  iAuCurrencyTests.swift
//  iAuCurrencyTests
//
//  Created by Reza Farahanion 3/6/19.
//  
//

import XCTest
@testable import iAuCurrency

class iAuCurrencyTests: XCTestCase {
    
    var currencyData: Data?

    override func setUp() {
         currencyData = try? TestUtils.jsonData(forResource: "currencies-data")
    }

    override func tearDown() {
        
    }

    func testValidCurrencyData() {
        
        // Given Currencies Rate to AUD
        guard let intCurrencyDataResponse = try? JSONDecoder().decode(JSONValue.self, from: currencyData!) else {
            XCTFail()
            return
        }
        
        let productsData = intCurrencyDataResponse.dictionary?["data"]
        XCTAssertNotNil(productsData)
    }
    
    func testValidCurrencyBrandData() {
        
        // Given Currencies Rate to AUD
        guard let intCurrencyDataResponse = try? JSONDecoder().decode(JSONValue.self, from: currencyData!) else {
            XCTFail()
            return
        }
        // When we reciece currencies  rates data
        let productsBrand = intCurrencyDataResponse.dictionary?["data"]?.dictionary?.keys.contains("Brands")
        
        // Then it shouldn't be nil
        XCTAssertNotNil((productsBrand)!)
    }
    
    func testValidCurrencyProducts() {
        
        // Given Currencies Rate to AUD
        guard let intCurrencyDataResponse = try? JSONDecoder().decode(JSONValue.self, from: currencyData!) else {
            XCTFail()
            return
        }
        
        // When we reciece currencies convert rates
        let productsDictionary = intCurrencyDataResponse.dictionary?["data"]?.dictionary?["Brands"]?.dictionary?["WBC"]?.dictionary?["Portfolios"]?.dictionary?["FX"]?.dictionary?["Products"]
        
        // Then it shouldn't be nil
        XCTAssertNotNil(productsDictionary)
    }
    
    func testValidCurrencyProductsCount() {
        
        // Given Currencies Rate to AUD
        guard let intCurrencyDataResponse = try? JSONDecoder().decode(JSONValue.self, from: currencyData!) else {
            XCTFail()
            return
        }
        
        // When we reciece currencies convert rates
        let productsDictionary = intCurrencyDataResponse.dictionary?["data"]?.dictionary?["Brands"]?.dictionary?["WBC"]?.dictionary?["Portfolios"]?.dictionary?["FX"]?.dictionary?["Products"]
        
        // Then it shouldn't be nil and count of all convert rates should be correct
        XCTAssertNotNil(productsDictionary)
        XCTAssertEqual(CurrencyProductMapper.currencyProduct(from: productsDictionary!).count, 40 )
    }
    
    func testValidCurrencyFirstProduct() {
        
        // Given Currencies Rate to AUD
        guard let intCurrencyDataResponse = try? JSONDecoder().decode(JSONValue.self, from: currencyData!) else {
            XCTFail()
            return
        }
        // When we reciece currencies convert rate for first product
        let productsDictionary = intCurrencyDataResponse.dictionary?["data"]?.dictionary?["Brands"]?.dictionary?["WBC"]?.dictionary?["Portfolios"]?.dictionary?["FX"]?.dictionary?["Products"]
        
        let product = CurrencyProductMapper.currencyProduct(from: productsDictionary!).first
        
        // Then it shouldn't be nil and product value shouldn't be empty
        XCTAssertNotEqual(product?.country!, "")
        XCTAssertNotEqual(product?.currencyName!, "")
        XCTAssertNotEqual(product?.currencyCode!, "")
        XCTAssertNotEqual(product?.buyTT!, "")
        XCTAssertNotEqual(product?.buyTC!, "")
        XCTAssertNotEqual(product?.buyNotes!, "")
        XCTAssertNotEqual(product?.updateDateFmt!, "")
        XCTAssertNotEqual(product?.effectiveDateFmt!, "")
        XCTAssertNotEqual(product?.spotRateDateFmt!, "")
        XCTAssertNotEqual(product?.lastupdated!, "")
    }
}
