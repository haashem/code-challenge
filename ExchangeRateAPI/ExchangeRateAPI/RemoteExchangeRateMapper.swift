//
//  RemoteExchangeRateMapper.swift
//  ExchangeRateAPI
//
//  Created by Hashem Aboonajmi on 1/2/21.
//

import Foundation

class RemoteExchangeRateMapper {
    
    struct RemoteError: Decodable, Error {
        let code: Int
        let info: String
    }
    
    struct Root: Decodable {
        let exchangeRates: [RemoteExchangeRate]
        let baseCurrency: String
        
        
        enum CodingKeys: String, CodingKey {
            case rates, base, success, error
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if (try container.decode(Bool.self, forKey: .success)) {
                baseCurrency = try container.decode(String.self, forKey: .base)
                let rates = try container.decode([String: Double].self, forKey: .rates)
                
                var exchangeRates: [RemoteExchangeRate] = []
                for key in rates.keys {
                    exchangeRates.append(RemoteExchangeRate(symbol: key, rate: rates[key]!))
                }
                self.exchangeRates = exchangeRates.sorted(by: {$0.symbol < $1.symbol})
            } else {
                let error = try container.decode(RemoteError.self, forKey: .error)
                throw error
            }
        }
    }
    
    static func map(_ data: Data) throws -> Root {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let root = try decoder.decode(Root.self, from: data)
            return root
        } catch let error as RemoteError {
            switch error.code {
            case 101:
                throw FixerExchangeRateLoader.Error.unauthorized
            case 104:
                throw FixerExchangeRateLoader.Error.maximumAllowanceReached
            default:
                throw FixerExchangeRateLoader.Error.invalidData
            }
        } catch {
            throw FixerExchangeRateLoader.Error.invalidData
        }
    }
}
