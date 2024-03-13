//
//  TelephonyInformation.swift
//
//
//  Created by Theik Chan on 13/03/2024.
//

import Foundation
import CoreTelephony

public class TelephonyManager {
    public func isSimAvailable() -> Bool {
        let info = CTTelephonyNetworkInfo()
        let carr = info.subscriberCellularProvider
        guard let carrier = carr else {
            return false
        }
        guard let carrierCode = carrier.mobileNetworkCode else {
            return false
        }
        guard carrierCode != "" else {
            return false
        }
        return true
    }

    public func getMncCode() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier!.mobileNetworkCode!
    }

    public func isAllowVoip() -> Bool {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier!.allowsVOIP
    }

    public func getCarrierName() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier!.carrierName!
    }

    public func getMccCode() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        return carrier!.mobileCountryCode!
    }
}
