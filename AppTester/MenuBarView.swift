//
//  MenuBarView.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI


struct MenuBarView: View {
    @StateObject var context = Context.shared
    @Environment(\.openWindow) var openWindow
    var settingsView = SettingsView()
    
    var body: some View {
        VStack {
            Link("Login", destination: URL(string: "https://www.pushbullet.com/authorize?client_id=ealaY3f6ILh9c5unQSyHVruI5y7Jlz6z&redirect_uri=apptester%3A%2F%2Fpushbullet.com%2Flogin-success&response_type=token&scope=everything")!)

            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button("Settings") {
                NSApplication.shared.activate(ignoringOtherApps: true)
                openWindow(id: "settings-view")
                    
            }
            Button("Logout") {
                context.haveCredentials = false
            }

        }
//        .task {
//            while !context.loggedIn {
//                await Task.sleep(1000)
//                print("waiting for login")
//            }
//        }
    }

}

#Preview {
    MenuBarView()
}
