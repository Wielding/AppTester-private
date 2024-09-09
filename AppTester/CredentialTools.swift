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
    /// Save the token to the keychain
    let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrAccount as String: "pushinator.test",
                                     kSecAttrServer as String: "pushinator.token.test",
                                     kSecValueData as String: context.token.data(using: .utf8)!,]
    
    var queue: DispatchQueue = DispatchQueue(label: "com.pushinator.saveCredentials")
    
    queue.async {
        let tokenQueryStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
        
        if tokenQueryStatus != errSecSuccess {
            context.logger.error("Error saving token to keychain")
        } else {
            context.haveCredentials = true
        }
        
    }
    
    /// Save the clientId to the keychain
    let clientIdQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: "pushinator.test",
                                        kSecAttrServer as String: "pushinator.clientId.test",
                                        kSecValueData as String: context.clientId.data(using: .utf8)!,]
    
    queue.async {
        let clientIdQueryStatus = SecItemAdd(clientIdQuery as CFDictionary, nil)
        
        if clientIdQueryStatus != errSecSuccess {
            context.logger.error("Error saving clientId to keychain")
        }
    }
    
    /// Save the password to the keychain
    let passwordQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: "pushinator.test",
                                        kSecAttrServer as String: "pushinator.password.test",
                                        kSecValueData as String: context.password.data(using: .utf8)!,]
    
    queue.async {
        let passwordQueryStatus = SecItemAdd(passwordQuery as CFDictionary, nil)
        
        if passwordQueryStatus != errSecSuccess {
            context.logger.error("Error saving password to keychain")
        }
    }
    
    
    
    return context.haveCredentials
}

func LoadCredentials(context :inout Context) async -> Bool {
    //    let logger = Logger(subsystem: "net.wielding.pushinator", category: "LoadCredentials")
    
    let clientIdQuery : [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrAccount as String: "pushinator.test",
                                         kSecAttrServer as String: "pushinator.clientId.test",
                                         kSecReturnData as String: kCFBooleanTrue as Any,
                                         kSecMatchLimit as String: kSecMatchLimitOne]
    
    var item: CFTypeRef?
    let clientIdQueryStatus = SecItemCopyMatching(clientIdQuery as CFDictionary, &item)
    
    if clientIdQueryStatus == errSecSuccess {
        let clientIdData = item as! Data
        context.clientId = String(data: clientIdData, encoding: .utf8)!
        context.haveCredentials = true
    } else {
        context.logger.error("Error loading clientId from keychain")
        context.haveCredentials = false
    }
    
    let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                     kSecAttrAccount as String: "pushinator.test",
                                     kSecAttrServer as String: "pushinator.token.test",
                                     kSecReturnData as String: kCFBooleanTrue as Any,
                                     kSecMatchLimit as String: kSecMatchLimitOne]
    

    let tokenQueryStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &item)
    
    if tokenQueryStatus == errSecSuccess {
        let tokenData = item as! Data
        context.token = String(data: tokenData, encoding: .utf8)!
        context.haveCredentials = true
    } else {
        context.logger.error("Error loading token from keychain")
        
        context.haveCredentials = false
    }
    
    let passwordQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
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



