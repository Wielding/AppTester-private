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
    var loggedIn: Bool = false
    var token: String = ""
    var password = ""
    var clientId = ""
    var logger = Logger(subsystem: "net.wielding.pushinator", category: "Context")
}

@main
struct AppTesterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var context = Context.shared
//    let logger = Logger(subsystem: "net.wielding.pushinator", category: "AppTester")
    
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
        
        //        WindowGroup {
        //            CredentialsView()
        //                .frame(maxWidth: .infinity, maxHeight: .infinity)
        //                .padding()
        //        }
    }
}



class AppDelegate: NSObject, NSApplicationDelegate {
    
    var context = Context.shared

//    var credentialsDelegate = CredentialsViewDelegate()
//    let window = NSWindow(
//        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//        backing: .buffered, defer: false)

    func application(_ application: NSApplication, open urls: [URL]) {
        let firstUrl = URLComponents(url: urls[0], resolvingAgainstBaseURL: false)
       // parse last value after =
        let tokenFragment = firstUrl?.fragment
        
        let token = tokenFragment?.components(separatedBy: "=").last
        
        if let token = token {
            context.token = token
            context.password = "Logged In"
            context.loggedIn = true
            Task {
                await SaveCredentials(context: context)
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
        
//
//        
//        print("applicationDidFinishLaunching")
        NSApp.setActivationPolicy(.prohibited)
        
        //        NSApplication.shared.setActivationPolicy(.regular)
        //        NSApplication.shared.activate(ignoringOtherApps: true)
        
//        if context.loggedIn {
//            NSApp.setActivationPolicy(.prohibited)
//        } else {
//            //            NSApp.setActivationPolicy(.regular)
//            //            NSApp.activate(ignoringOtherApps: true)
//        }
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        context.logger.debug("applicationWillFinishLaunching")
    }
}


