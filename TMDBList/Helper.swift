//
//  Helper.swift
//  TMDBList
//
//  Created by Victor Robertson on 26/07/17.
//  Copyright © 2017 magpali. All rights reserved.
//

import UIKit

class Helper {
    class func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
    
    class func reversedPrint(seperator: String, terminator: String, items: Any...) {
        for item in items {
            print(item)
        }
    }
}

extension UIColor {
    public class var grafity: UIColor { return UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0) }
}

extension UIViewController {
    func showErrorAlert(title: String? = R.string.localizable.unexpected_error_title(),
                        errorMessage: String? = R.string.localizable.unexpected_error_message(),
                        tryAgainAction: ((UIAlertAction) -> Void)? = nil) {
        let errorAlert = UIAlertController(title: title,
                                           message: errorMessage,
                                           preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: R.string.localizable.global_cancel(),
                                           style: .cancel,
                                           handler: nil))
        
        if let action = tryAgainAction {
            errorAlert.addAction(UIAlertAction(title: R.string.localizable.global_try_again(),
                                               style: .default,
                                               handler: action))
        }
        
        _ = self.present(errorAlert, animated: true, completion: nil)
    }
}
