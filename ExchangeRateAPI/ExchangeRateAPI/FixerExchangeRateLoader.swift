//
//  ExchangeRateLoader.swift
//  ExchangeRateAPI
//
//  Created by Hashem Aboonajmi on 1/1/21.
//

import Foundation
import ExchangeRateFeature
import Networking

public class FixerExchangeRateLoader: ExchangeRateLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case unauthorized
        case maximumAllowanceReached
    }
    
    public typealias Result = ExchangeRateLoader.Result
    
    public func latestExchangeRates(baseCurrency: String, completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: url.appendingQueryParameters(["base": "\(baseCurrency)"]))
        
        client.get(from: request) { [weak self] result in
            guard self != nil else { return }
            DispatchQueue.main.async {
                switch result {
                    case let .success((data, _)):
                        completion(FixerExchangeRateLoader.map(data))
                    case .failure(_):
                        completion(.failure(Error.connectivity))
                    
                }
            }
        }
    }
    
    private static func map(_ data: Data) -> Result {
        do {
            let remoteExchangeRates = try RemoteExchangeRateMapper.map(data)
            return .success(ExchangeRates(baseCurrency: remoteExchangeRates.baseCurrency, rates: remoteExchangeRates.exchangeRates.toModels()))
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteExchangeRate {
    func toModels() -> [CurrencyRate] {
        return map{ CurrencyRate(symbol: $0.symbol, rate: $0.rate) }
    }
}

private extension URL {
    
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        if var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
                .map { URLQueryItem(name: $0, value: $1) }
            
            return urlComponents.url ?? self
        } else {
            return self
        }
    }
}
