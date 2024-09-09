//
//  MenuBarView.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI

struct MenuBarView: View {
    @StateObject var context = Context.shared
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text(context.password)
        }.task {
            while !context.loggedIn {
                await Task.sleep(1000)
                print("waiting for login")
            }
        }
    }

}

#Preview {
    MenuBarView()
}
