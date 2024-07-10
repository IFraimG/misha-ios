import SwiftUI
import UniformTypeIdentifiers

struct LinksListView: View {
    @Binding var folder: Folder
    @State private var isButtons = false
    
    @State private var draggedItem: String?
    
    @StateObject private var linkViewModel = LinkViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var isTargeted: Bool = false
    
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
                            .default(Text("Удалить ссылку")) {
                                linkViewModel.setDeleteLink(isDeleteLink: true)
                            },
//                            .default(Text("Изменить обложку")) {
//
//                            },
                            .default(Text("Удалить папку")) {
                                
                            },
                            .cancel(Text("Отмена")) {
                                self.isButtons = false
                            }
                        ])
                    }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(linkViewModel.linksList, id: \.self) { link in
                        LinkUIView(viewModel: linkViewModel, linkItem: link)
                            .onDrag({
                                self.draggedItem = link.linkID
                                print("iiii \(self.draggedItem)")
                                return NSItemProvider(item: link.linkID as NSString, typeIdentifier: UTType.plainText.identifier)
                            })
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .onAppear {
                linkViewModel.getListLinks(folderID: folder.folderID)
            }
            
            Spacer()
            
            if linkViewModel.isDeleteLink {
                Button(action: {
                    if let draggedItem = draggedItem {
                        linkViewModel.removeLink(linkID: draggedItem)
                        self.draggedItem = nil
                    }
                }) {
                    Text("Удалить")
                        .frame(width: 300)
                        .padding()
                        .background(!isTargeted ? Color.red : Color.red.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
                .onDrop(of: [UTType.plainText], isTargeted: $isTargeted, perform: { providers in
                    providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier,
                                              options: nil) { (item, error) in
                        if let item = item as? NSString {
                            self.draggedItem = item as String
                            
                            linkViewModel.removeLink(linkID: self.draggedItem ?? "")
                            self.draggedItem = nil
                        }
                    }
                    return true
                })
            }
        }
    }
}

#Preview {
    LinksListView(folder: .constant(Folder(title: "Food", folderID: "folderID", userID: "userID", position: 0, dateOfCreated: "00/00/00")))
}
