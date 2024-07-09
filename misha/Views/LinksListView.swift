
import SwiftUI

struct LinksListView: View {
    @Binding var folder: Folder
    @State private var isButtons = false
    
    @StateObject private var linkViewModel = LinkViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(folder.title)
                    Text("230 сохраненных")
                }
                
                Spacer()
                
                Image("Points")
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        self.isButtons = !isButtons
                    }
                    .actionSheet(isPresented: $isButtons) {
                        ActionSheet(title: Text("Изменить"), buttons: [
                            .default(Text("Добавить из галереи")) {
                                
                            },
                            .default(Text("Изменить обложку")) {
                                
                            },
                            .default(Text("Удалить папку")) {
                                
                            },
                            .cancel(Text("Отмена")) {
                                self.isButtons = false
                            }
                        ])
                    }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(linkViewModel.linksList) { link in
                        LinkUIView(linkItem: link)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }.onAppear() {
                linkViewModel.getListLinks(folderID: folder.folderID)
            }
            
            Spacer()
        }.padding(.horizontal, 20)
            .padding(.top, 20)
    }
}

#Preview {
    LinksListView(folder: .constant(Folder(title: "Food", folderID: "folderID", userID: "userID", position: 0, dateOfCreated: "00/00/00")))
}
