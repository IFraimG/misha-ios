import SwiftUI
import SwiftData

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var phone: String = ""
    @State private var password: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Section {
                    TextField("Номер телефона", text: $phone)
                        .padding()
                        .frame(height: 60)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                        .keyboardType(.phonePad)
                        .font(Font.custom("SFProDisplay-Medium", size: 14))
                }
                
                Section {
                    SecureField(text: $password, prompt: Text("Пароль")
                        .font(Font.custom("SFProDisplay-Medium", size: 14))) {
                        
                    }.padding()
                        .frame(height: 60)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
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
                        .font(Font.custom("SFProDisplay-Semibold", size: 17))
                }
                
                Spacer()
            }.background(Color.white).scrollContentBackground(.hidden)
            
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
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(id, forKey: "userID")
        
        self.isAuthenticated = true
    }
}

#Preview {
    LoginView(isAuthenticated: .constant(false))
}
