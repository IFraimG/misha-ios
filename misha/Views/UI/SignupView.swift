import SwiftUI
import SwiftData

struct SignupView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var isValidPhoneNumber: Bool = true
    @State private var isRepeatPhoneNumber: Bool = false
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Номер телефона",
                              text: $phone, onEditingChanged: { _ in
                        //                    validatePhoneNumber()
                    })
                    .padding()
                    .keyboardType(.phonePad)
                    .font(Font.custom("SFProDisplay-Medium", size: 14))
                    
                    if isRepeatPhoneNumber {
                        Text("Телефон уже используется")
                            .foregroundColor(.red)
                            .font(.caption)
                            .font(Font.custom("SFProDisplay-Medium", size: 14))
                    }
                }.frame(height: 60)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                
                
                Section {
                    SecureField(text: $password, prompt: Text("Пароль").font(Font.custom("SFProDisplay-Medium", size: 14))) {
                        
                    }.padding().frame(height: 60)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
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
                        .font(Font.custom("SFProDisplay-Semibold", size: 17))
                }.disabled(!isValidPhoneNumber)
            }.background(Color.white).scrollContentBackground(.hidden)
            
            NavigationLink(destination: HomeView(isAuthenticated: $isAuthenticated), isActive: $isAuthenticated,
                           label: { EmptyView() }).hidden()
        }
    }
    
    private func sendData() {
        if !phone.isEmpty && !password.isEmpty {
            let user = User(phone: phone, password: password, id: "")
            signup(with: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        saveUserData(token: data.token, id: data.user.id)
                        
                        self.phone = ""
                        self.password = ""
                        self.isRepeatPhoneNumber = false
                    case .failure(let error):
                        if let nsError = error as NSError?, nsError.code == 403 {
                            self.isRepeatPhoneNumber = true
                            print("Access forbidden: \(nsError.localizedDescription)")
                        } else {
                            print("error \(error.localizedDescription)")
                        }
                    }
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
    
    private func saveUserData(token: String, id: String) {
        let user: UserData = UserData(id: id, token: token)
        modelContext.insert(user)
        
        do {
            try modelContext.save()
            UserDefaults.standard.set(token, forKey: "token")
            UserDefaults.standard.set(id, forKey: "userID")
            
            isAuthenticated = true
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SignupView(isAuthenticated: .constant(true))
}
