//
//  SceneDelegate.swift
//  MainApp
//
//  Created by Hashem Aboonajmi on 1/2/21.
//

import UIKit
import ExchangeRateiOS
import Networking
import ExchangeRateAPI
import CurrencyConvertoriOS
import OfflineCurrencyConvertor

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        navigationController = UINavigationController(rootViewController: createExchangeRateScene())
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    
    func createExchangeRateScene() -> ExchangeRateViewController {
        
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let exchangeRateLoader = FixerExchangeRateLoader(url:URL(string: "http://data.fixer.io/latest?access_key=537cc99b954a0e53d1c6e5f9fbbb04b4")!, client: client)
        
        let exchangeRateVC = ExchangeRateUIComposer.ExchangeRateComposedWith(ratesLoader: exchangeRateLoader) { baseCurrency, selectedCurrencyRate  in
            
            let currencyConvertorVC = CurrencyConvertorUIComposer.CurrencyConvertorComposedWith(convertor: OfflineCurrencyConvertor(targetCurrencyRate: selectedCurrencyRate.rate), conversionInfo: ConvertorInfo(baseSymbol: baseCurrency, targetSymbol: selectedCurrencyRate.symbol, targetSymboleRate: selectedCurrencyRate.rate))
            
            self.navigationController?.pushViewController(currencyConvertorVC, animated: true)
            
        }
        
        return exchangeRateVC
    }


}
