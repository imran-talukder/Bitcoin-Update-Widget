//
//  DataModel.swift
//  BitCoinUpdate
//
//  Created by Appnap WS01 on 24/9/20.
//

import Foundation
import WidgetKit
struct DataModel {
    let rate: Float = 10075858.00
    let currency: String = "USD"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
}

struct ExchangeInfo: Codable, Identifiable {
    
    var rate: Double
    var asset_id_quote: String
    var id: Double{rate}
}

var finalRate = 0.0
var finalCurrency = "USD"

