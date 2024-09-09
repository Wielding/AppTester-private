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
    var credentialsDelegate = CredentialsViewDelegate()
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)

    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        
        Task {
            let success = await LoadCredentials(context: &context)
            
            if !context.loggedIn || !success {
                let credentialsView = CredentialsView()
                
                window.center()
                window.setFrameAutosaveName("Credentials Window")
                window.contentView = NSHostingView(rootView: credentialsView)
                window.delegate = credentialsDelegate
                window.makeKeyAndOrderFront(nil)
                
            } else {
                context.objectWillChange.send()
            }
            
        }
        
        
        print("applicationDidFinishLaunching")
        
        
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


