//
//  AppTesterApp.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI

class Context : ObservableObject {
    static let shared = Context()
    var loggedIn: Bool = false
    var token: String = ""
    var password = ""
}

@main
struct AppTesterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var context = Context.shared
    
    init() {
        
    }
    
    var body: some Scene {
        MenuBarExtra {
            Text("Hello Status Bar Menu!")
            Text(context.password)
            Divider()
            Button("Quit") { NSApp.terminate(nil) }
        } label: {
            Image(systemName: "bolt.fill")
        }
        
        //        WindowGroup {
        //            CredentialsView()
        //                .frame(maxWidth: .infinity, maxHeight: .infinity)
        //                .padding()
        //        }
    }
}



class AppDelegate: NSObject, NSApplicationDelegate {
    
    var context = Context.shared
    var credentialsDelegate = CredentialsViewDelegate()
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        if !context.loggedIn {
            let credentialsView = CredentialsView()
            
            window.center()
            window.setFrameAutosaveName("Credentials Window")
            window.contentView = NSHostingView(rootView: credentialsView)
            window.delegate = credentialsDelegate
            window.makeKeyAndOrderFront(nil)
            
        }
        
        //        NSApplication.shared.setActivationPolicy(.regular)
        //        NSApplication.shared.activate(ignoringOtherApps: true)
        
        if context.loggedIn {
            NSApp.setActivationPolicy(.prohibited)
        } else {
            //            NSApp.setActivationPolicy(.regular)
            //            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        print("applicationWillFinishLaunching")
    }
}

class CredentialsViewDelegate: NSObject, NSWindowDelegate {
    var context = Context.shared
    func windowWillClose(_ notification: Notification) {
        print("windowWillClose")
        // save password and token in keychain
        context.loggedIn = true
        let tokenQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: "pushinator.test",
                                    kSecAttrServer as String: "pushinator.token.test",
                                    kSecValueData as String: context.token.data(using: .utf8)!,]
        
        let tokenQueryStatus = SecItemAdd(tokenQuery as CFDictionary, nil)
        
        if tokenQueryStatus != errSecSuccess {
            print("Error saving token to keychain")
        }
        
        let passwordQuery: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: "pushinator.test",
                                    kSecAttrServer as String: "pushinator.password.test",
                                    kSecValueData as String: context.password.data(using: .utf8)!,]
        
        let passwordQueryStatus = SecItemAdd(passwordQuery as CFDictionary, nil)
        
        if passwordQueryStatus != errSecSuccess {
            print("Error saving password to keychain")
        }
        
        
        
    }
}
