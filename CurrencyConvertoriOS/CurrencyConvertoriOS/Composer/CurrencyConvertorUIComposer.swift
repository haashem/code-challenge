//
//  CurrencyConvertorComposer.swift
//  CurrencyConvertoriOS
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import UIKit
import CurrencyConvertorFeature

public final class CurrencyConvertorUIComposer {
    public static func CurrencyConvertorComposedWith(convertor: CurrencyConvertor, conversionInfo: ConvertorInfo) -> CurrencyConvertorViewController {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle(for: self.self)).instantiateInitialViewController() as! CurrencyConvertorViewController
        vc.convertor = convertor
        vc.convertorInfo = conversionInfo
        
        return vc
    }
}
