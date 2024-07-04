//
//  SignupView.swift
//  misha
//
//  Created by MacBook on 04.07.2024.
//

import SwiftUI

struct SignupView: View {
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var isValidPhoneNumber: Bool = true


    var body: some View {
        Form {
            Section {
                TextField("Номер телефона",
                          text: $phone, onEditingChanged: { _ in
                    validatePhoneNumber()
                })
                .keyboardType(.phonePad)
                
                if !isValidPhoneNumber {
                    Text("Invalid phone number")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Section {
                SecureField(text: $password, prompt: Text("Пароль")) {
                    
                }
            }
            
            Button(action: {
                if validatePhoneNumber() {
                    sendData()
                }
            }) {
                Text("Далее")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.disabled(!isValidPhoneNumber)
        }
    }
    
    private func sendData() {
        let user = User(phone: phone, password: password, id: "")
        signup(with: user) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                    print(data.token)
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                }

            }
        }
    }
    
    private func validatePhoneNumber() -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        isValidPhoneNumber = predicate.evaluate(with: phone)
        isValidPhoneNumber = true
        
        
        return isValidPhoneNumber
    }
}

#Preview {
    SignupView()
}
