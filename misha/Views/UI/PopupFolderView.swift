
import SwiftUI
import MijickPopupView

struct PopupFolderView: CentrePopup {
    @ObservedObject var viewModel: UserViewModel
    
    @State private var folderTitle = ""
    
    func createContent() -> some View {
        VStack(spacing: 0) {
            Text("Введите название")
                .padding(.top, 60)
                .font(Font.custom("SFProDisplay-Bold", size: 17))
            TextField("", text: $folderTitle)
                .frame(height: 40)
                .frame(maxWidth: 300)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(7)
                .font(Font.custom("SFProDisplay-Medium", size: 16))
                .padding(20)
            
            Spacer()
            
            VStack {
                Spacer()
                Divider()
                
                HStack(alignment: .bottom) {
                    Button(action: dismiss) {
                        Text("Отменить")
                            .font(Font.custom("SFProDisplay-Medium", size: 17))
                    }.padding(.horizontal, 20)
                    
                    Divider()

                    Button(action: {
                        makeFolder()
                    }) { Text("Сохранить")
                            .font(Font.custom("SFProDisplay-Semibold", size: 17))
                    }.padding(.horizontal, 20)
                }
                
            }.frame(height: 50).padding()
        }
        .frame(maxHeight: 300)
    }
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup
            .horizontalPadding(20)
            .cornerRadius(16)
    }
 
    private func makeFolder() {
        if !folderTitle.isEmpty {
            viewModel.makeFolder(title: folderTitle)
            self.folderTitle = ""
            dismiss()
        }
    }
}

#Preview {
    PopupFolderView(viewModel: UserViewModel()).createContent()
}
