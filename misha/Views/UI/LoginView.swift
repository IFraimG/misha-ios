import SwiftUI
import SwiftData

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var phone: String = ""
    @State private var password: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Номер телефона", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section {
                    SecureField(text: $password, prompt: Text("Пароль")) {
                        
                    }
                }
                
                Button(action: {
                    sendData()
                }) {
                    Text("Далее")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            NavigationLink(destination: HomeView(isAuthenticated: $isAuthenticated), isActive: $isAuthenticated,
                           label: { EmptyView() }).hidden()
        }
    }
    
    private func sendData() {
        let user = User(phone: phone, password: password, id: "")
        login(with: user) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                    saveUserData(token: data.token, id: data.user.id)
                    self.phone = ""
                    self.password = ""
                    
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                }

            }
        }
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
    LoginView(isAuthenticated: .constant(false))
}
