//
//  CredentialTools.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import Foundation
import OSLog

func SaveCredentials(context: Context) async -> Bool {
    var success = false
    let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrAccount as String: "pushinator.test",
                                     kSecAttrServer as String: "pushinator.token.test",
                                     kSecValueData as String: context.token.data(using: .utf8)!,]
    
    var queue: DispatchQueue = DispatchQueue(label: "com.pushinator.saveCredentials")
    
    queue.async {
        let tokenQueryStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
        
        if tokenQueryStatus != errSecSuccess {
            print("Error saving token to keychain")
        } else {
            context.haveCredentials = true
        }
        
    }
        
    //    let passwordQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
    //                                     kSecAttrAccount as String: "pushinator.test",
    //                                     kSecAttrServer as String: "pushinator.password.test",
    //                                     kSecValueData as String: context.password.data(using: .utf8)!,]
    //
    //    queue.async {
    //        let passwordQueryStatus = SecItemAdd(passwordQuery as CFDictionary, nil)
    //
    //        if passwordQueryStatus != errSecSuccess {
    //            print("Error saving password to keychain")
    //        }
    //    }
    
    return context.haveCredentials
}

func LoadCredentials(context :inout Context) async -> Bool {
//    let logger = Logger(subsystem: "net.wielding.pushinator", category: "LoadCredentials")
    
    var tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrAccount as String: "pushinator.test",
                                     kSecAttrServer as String: "pushinator.token.test",
                                     kSecReturnData as String: kCFBooleanTrue as Any,
                                     kSecMatchLimit as String: kSecMatchLimitOne]
    
    var item: CFTypeRef?
    let tokenQueryStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &item)
    
    if tokenQueryStatus == errSecSuccess {
        let tokenData = item as! Data
        context.token = String(data: tokenData, encoding: .utf8)!
        context.haveCredentials = true
    } else {
        context.logger.error("Error loading token from keychain")
        
        context.haveCredentials = false
    }
    
    var passwordQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: "pushinator.test",
                                        kSecAttrServer as String: "pushinator.password.test",
                                        kSecReturnData as String: kCFBooleanTrue as Any,
                                        kSecMatchLimit as String: kSecMatchLimitOne]
    
    let passwordQueryStatus = SecItemCopyMatching(passwordQuery as CFDictionary, &item)
    
    if passwordQueryStatus == errSecSuccess {
        let passwordData = item as! Data
        context.password = String(data: passwordData, encoding: .utf8)!
        context.haveCredentials = true
    } else {
        context.logger.error("Error loading password from keychain")
        context.haveCredentials = false
    }
    
    if context.haveCredentials {
        context.logger.info("Credentials loaded successfully")
    }
    
    return context.haveCredentials
    
}



