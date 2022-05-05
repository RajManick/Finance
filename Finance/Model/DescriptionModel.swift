//
//  DescriptionModel.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import Foundation

// MARK: - Welcome
struct DescriptionModel: Codable {
    let quoteType: QuoteType
}

// MARK: - QuoteType
struct QuoteType: Codable {
    let exchange, shortName, exchangeTimezoneName, exchangeTimezoneShortName: String?
    let isEsgPopulated: Bool?
    let gmtOffSetMilliseconds, underlyingSymbol, quoteType, symbol: String?
    let underlyingExchangeSymbol, headSymbol, market: String?
}
