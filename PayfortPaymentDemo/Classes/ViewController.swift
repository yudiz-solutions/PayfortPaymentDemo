//
//  ViewController.swift
//  PayfortPaymentDemo
//
//  Created by Yudiz on 02/10/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import UIKit

/// ViewController
class ViewController: UIViewController {
    
    /// IBOutlet(s)
    @IBOutlet weak var btnPay: UIButton!
    
    /// Variable Declaration(s)
    var payFortController: PayFortController {
        return PayFortController(enviroment: PayfortMode.currentMode.environment)
    }
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

// MARK: - UI Related Method(s)
extension ViewController {
    
    func prepareUI() {
        print("kevin")
    }
}

// MARK: - UIButton Action(s)
extension ViewController {
    
    @IBAction func tapBtnPay(_ sender: UIButton) {
        makePayfortTokenRequest()
    }
}

// MARK: - WebCall(s)
extension ViewController {
    
    func makePayfortTokenRequest() {
        var request = URLRequest(url: PayfortMode.currentMode.tokenRequestUrl)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        do {
            let data = try JSONSerialization.data(withJSONObject: PayfortMode.currentMode.tokenRequestParams, options: .prettyPrinted)
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { [weak self] (kData, kResponse, kError) in
                guard let self = self, kError == nil else {
                    print(kError?.localizedDescription as Any)
                    return
                }
                if let response = kResponse as? HTTPURLResponse, response.statusCode == 200, let jsonData = kData {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                            /*
                             Response:
                                ["signature": 7b7c54*********************,
                                "service_command": SDK_TOKEN,
                                "response_message": Success,
                                "language": en,
                                "access_code": 6r1***********,
                                "merchant_identifier": K*******,
                                "response_code": 22000,
                                "device_id": 34EA4191-0F7D-40C3-8180-FEDE052B8C23,
                                "status": 22,
                                "sdk_token": 7647**************]
                            */
                            if let token = jsonDict["sdk_token"] as? String {
                                /// Presenting Payfort Gateway Screen in main thread.
                                DispatchQueue.main.async {
                                    self.presentPayfortGateWayScreen(token)
                                }
                            } else {
                                print("Unable to find payfort sdk token.")
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                }
            }.resume()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func presentPayfortGateWayScreen(_ token: String) {
        var params: [String: Any] = [:]
        params["amount"] = "200"
        params["command"] = "AUTHORIZATION"
        params["currency"] = "SAR"
        params["customer_email"] = "email@gmail.com"
        params["language"] = "en"
        params["sdk_token"] = token
        params["payment_option"] = ""
        
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        let merchant_reference = "12586" + "_" + String(format: "%0.2d", currentTime)
        /// merchant_reference should be always unique.
        params["merchant_reference"] = merchant_reference
        
        let requestDict: NSMutableDictionary = NSMutableDictionary(dictionary: params)
        
        payFortController.callPayFort(withRequest: requestDict, currentViewController: self, success: { (requestDict, responseDict) in
            print("------------------------------- SUCCESS ------------------------------------")
            if let responseDict = responseDict {
                print(responseDict)
            }
        }, canceled: { (requestDict, responseDict) in
            print("------------------------------- CANCEL ------------------------------------")
        }) { (requestDict, responseDict, message) in
            print("------------------------------- FAILED ------------------------------------")
            print(message as Any)
        }
    }
}
