//
//  MenuBarView.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI

class MenuBarContext: ObservableObject {
    var context = Context.shared
}

struct MenuBarView: View {
    @StateObject var context = MenuBarContext()
    
    var body: some View {
        VStack {
            Link("Login", destination: URL(string: "https://www.pushbullet.com/authorize?client_id=ealaY3f6ILh9c5unQSyHVruI5y7Jlz6z&redirect_uri=apptester%3A%2F%2Fpushbullet.com%2Flogin-success&response_type=token&scope=everything")!)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text(context.context.token)
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
