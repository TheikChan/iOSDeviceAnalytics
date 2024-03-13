//
//  ApplicationInformation.swift
//
//
//  Created by Theik Chan on 13/03/2024.
//

import Foundation

public class ApplicationInformation {
    
    ///current installed app name
    public func getAppName() -> String {
        return (Bundle.main.infoDictionary?["CFBundleName"] as? String)!
    }
    
    /// Current installed version of your app bundle id.
    public func getAppIdString() -> String {
        return Bundle.main.bundleIdentifier! // return type is String?
    }
    
    /// Current installed version of your app .
    public func getAppVersion() -> String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
    }
    
    
    /// Current install build version of your app
    public func getBuildVersion() -> String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
    }
}
