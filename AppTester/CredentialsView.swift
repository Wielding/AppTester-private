//
//  CredentialsView.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI

struct CredentialsView: View {
    @State var context = Context.shared
    @State private var token: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            TextField("Token", text: $token)
            SecureField("Password", text: $password)
            Button("Login") {
                context.loggedIn = true
                context.token = token
                context.password = password
                context.objectWillChange.send()
                dismiss()
            }

        }.padding()
    }

}

#Preview {
    CredentialsView()
}
