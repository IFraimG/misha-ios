import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                let user = User(phone: "33033", password: "123", id: "")
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
            }) {
                Text("MISHA CLICK!")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
