//
//  ExchangeRateUIComposer.swift
//  ExchangeRateiOS
//
//  Created by Hashem Aboonajmi on 1/2/21.
//

import UIKit
import ExchangeRateFeature

public final class ExchangeRateUIComposer {
    public static func ExchangeRateComposedWith(ratesLoader: ExchangeRateLoader, selection: @escaping (_ baseCurrency: String, _ rate: CurrencyRate) -> Void = { _, _  in }) -> ExchangeRateViewController {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle(for: self.self)).instantiateInitialViewController() as! ExchangeRateViewController
        vc.exchangeRateLoader = ratesLoader
        vc.onCurrencyRateSelection = selection

        return vc
    }
}
