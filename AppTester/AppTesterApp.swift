//
//  AppTesterApp.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI
import OSLog

class Context : ObservableObject {
    static let shared = Context()
    var haveCredentials: Bool = false
    var token: String = ""
    var password = ""
    var clientId = ""
    var logger = Logger(subsystem: "net.wielding.pushinator", category: "Context")
}

@main
struct AppTesterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var context = Context.shared
    
    init() {
    }
    
    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
            Divider()
            Button("Quit") { NSApp.terminate(nil) }
        } label: {
            Image(systemName: "bolt.fill")
        }
        WindowGroup(id: "settings-view") {
            SettingsView()
                .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }
        .defaultSize(CGSize(width: 400, height: 200))
        
    }
}



class AppDelegate: NSObject, NSApplicationDelegate {
    
    var context = Context.shared
    
    func application(_ application: NSApplication, open urls: [URL]) {
        
        let firstUrl = URLComponents(url: urls[0], resolvingAgainstBaseURL: false)
        // parse last value after =
        let tokenFragment = firstUrl?.fragment
        
        let token = tokenFragment?.components(separatedBy: "=").last
        
        if let token = token {
            context.haveCredentials = true
            Task {
                _ = await LoadCredentials(context: &context)
                context.token = token
                _ = await SaveCredentials(context: context)
                
            }
            context.objectWillChange.send()
        }
        
        
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        context.logger.debug("applicationDidFinishLaunching")
        
        
        Task {
            _ = await LoadCredentials(context: &context)
            context.objectWillChange.send()
            
        }
        NSApp.setActivationPolicy(.accessory)
        
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        context.logger.debug("applicationWillFinishLaunching")
    }
}


