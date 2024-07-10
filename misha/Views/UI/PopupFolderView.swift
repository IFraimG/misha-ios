
import SwiftUI
import MijickPopupView

struct PopupFolderView: CentrePopup {
    @ObservedObject var viewModel: UserViewModel
    
    @State private var folderTitle = ""
    
    func createContent() -> some View {
        VStack(spacing: 0) {
            Text("Введите название")
                .padding(.top, 60)
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
    }
 
    private func makeFolder() {
        viewModel.makeFolder(title: folderTitle)
        self.folderTitle = ""
        dismiss()
    }
}

#Preview {
    PopupFolderView(viewModel: UserViewModel()).createContent()
}
