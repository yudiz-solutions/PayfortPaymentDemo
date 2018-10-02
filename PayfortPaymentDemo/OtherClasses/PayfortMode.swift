//
//  PayFortHandler.swift
//  PayfortPaymentDemo
//
//  Created by Yudiz on 02/10/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import UIKit

/// PayfortMode
///
/// - development: Testing purpose
/// - production: While Application is live.
enum PayfortMode {
    
    case development
    case production
    
    /// Just need to make current mode `.production` while making application live.
    static var currentMode: PayfortMode = PayfortMode.development
    
    /// Variable Declaration(s)
    var merchantId: String {
        switch self {
        case .development:
            return ""
        case .production:
            return ""
        }
    }
    
    var accessCode: String {
        switch self {
        case .development:
            return ""
        case .production:
            return ""
        }
    }
    
    var shaRequestPhrase: String {
        switch self {
        case .development:
            return ""
        case .production:
            return ""
        }
    }
    
    var deviceId: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    var environment: KPayFortEnviroment {
        switch self {
        case .development:
            return KPayFortEnviromentSandBox
        case .production:
            return KPayFortEnviromentProduction
        }
    }
    
    var tokenRequestUrl: URL {
        switch self {
        case .development:
            return URL(string: kPayFortDevelopmentTokenURL)!
        case .production:
            return URL(string: kPayFortProductionTokenURL)!
        }
    }
    
    var tokenRequestParams: [String: Any] {
        var params: [String: Any] = [:]
        params["service_command"] = "SDK_TOKEN"
        params["access_code"] = accessCode
        params["merchant_identifier"] = merchantId
        params["language"] = "en"
        params["device_id"] = deviceId
        params["signature"] = getSignatureString()
        return params
    }
    
    func getSignatureString() -> String {
        var str: String = shaRequestPhrase + "access_code=" + accessCode + "device_id=" + deviceId + "language=" + "en"
        str += "merchant_identifier=" + merchantId + "service_command=SDK_TOKEN" + shaRequestPhrase
        return str.sha256()
    }
}
