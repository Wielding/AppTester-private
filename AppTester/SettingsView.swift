//
//  CredentialsView.swift
//  AppTester
//
//  Created by Andrew Kunkel on 9/8/24.
//

import SwiftUI

struct SettingsView: View {
    var context = Context.shared
    @State private var password: String = Context.shared.password
    @State private var clientId: String = Context.shared.clientId
    @State private var encryptionEnabled: Bool = !Context.shared.password.isEmpty
    @Environment(\.dismiss) var dismiss
    
    init() {
        if !context.password.isEmpty {
            encryptionEnabled = true
        }
    }
        
    var body: some View {

        VStack {
            Text("You need to create a Client ID in your PushBullet settings at pushbullet.com")
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            TextField("Client ID", text: $clientId).frame(width: 200)
            VStack {
                Toggle("Enable encryption", isOn: $encryptionEnabled)
            }.toggleStyle(.switch)
            SecureField("Encryption Password", text: $password).disabled(!encryptionEnabled).frame(width: 200)
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Button("Save") {
                    
                    Task {
                        if encryptionEnabled {
                            context.password = password
                        } else {
                            context.password = ""
                            password = ""
                        }

                        context.clientId = clientId
                        
                        _ = await SaveCredentials(context: context)
                        context.objectWillChange.send()
                    }

                    dismiss()
                }
            }
            
        }.padding()
//            .onOpenURL(perform: { url in
//            context.logger.debug("SettingsView onOpenURL")
//        })
        
    }
    
}

class SettingsViewDelegate: NSObject, NSWindowDelegate {
    var context = Context.shared

    func windowWillClose(_ notification: Notification) {
        print("windowWillClose")
        
        Task {
            await SaveCredentials(context: context)
        }
        
        
    }
}

#Preview {
    SettingsView()
}
