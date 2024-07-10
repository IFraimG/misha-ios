
import SwiftUI
import MijickPopupView

struct PopupFolderView: CentrePopup {
    @State private var folderTitle = ""
    
    func createContent() -> some View {
        VStack(spacing: 0) {
            Text("Введите название")
            TextField("", text: $folderTitle)
                .frame(height: 40)
                .frame(maxWidth: 300)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(7)
                .font(Font.custom("SF Pro", size: 16))
                .padding(20)
                
            
            Spacer()
            
            VStack {
                Spacer()
                Divider()
                
                HStack(alignment: .bottom) {
                    Button(action: dismiss) {
                        Text("Отменить")
                    }.padding(.horizontal, 20)
                    
                    Divider()

                    Button(action: {
                        makeFolder()
                    }) { Text("Сохранить") }.padding(.horizontal, 20)
                }
                
            }.frame(height: 50).padding()
        }
        .frame(maxHeight: 300)
    }
    
    func configurePopup(popup: BottomPopupConfig) -> BottomPopupConfig {
        popup
            .horizontalPadding(20)
            .bottomPadding(42)
            .cornerRadius(16)
//            .backgroundColour(Color.clear)
    }
 
    private func makeFolder() {
        if let storedUserID = UserDefaults.standard.string(forKey: "userID"), !storedUserID.isEmpty {
            if let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty {
                print("userID \(storedUserID)")
                folderCreateRequest(withToken: storedToken, with: Folder(
                    title: folderTitle,
                    folderID: "",
                    userID: storedUserID,
                    position: 0,
                    dateOfCreated: "" )) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.folderTitle = ""
                            dismiss()
                        case .failure(let error):
                            print("error \(error.localizedDescription)")
                            dismiss()
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    PopupFolderView().createContent()
}
