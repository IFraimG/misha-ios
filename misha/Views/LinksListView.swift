import SwiftUI
import UniformTypeIdentifiers

struct LinksListView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var folder: Folder
    @State private var isButtons = false
    
    @State private var draggedItem: String?
    
    @StateObject private var linkViewModel = LinkViewModel()
    
    @State private var buttonText = "Удалить (удерживай и тяни сюда)"
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var isTargeted: Bool = false
    
    var body: some View {
        VStack {
            Text(folder.title).font(.custom("SFProDisplay-Semibold", size: 16))
                
//                Spacer()
                
//                Image("Points")
//                    .frame(width: 32, height: 32)
//                    .onTapGesture {
//                        self.isButtons = !isButtons
//                    }
//                    .actionSheet(isPresented: $isButtons) {
//                        ActionSheet(title: Text("Изменить"), buttons: [
//                            .default(Text(!linkViewModel.isDeleteLink ? "Удалить ссылку" : "Отмена")) {
//                                linkViewModel.setDeleteLink(isDeleteLink: !linkViewModel.isDeleteLink)
//                            },
//                            .default(Text("Удалить папку")) {
//                                linkViewModel.deleteFolder(folderID: folder.folderID)
//                                dismiss()
//                            }
//                        ])
//                    }
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 20)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(linkViewModel.linksList, id: \.self) { link in
                        LinkUIView(viewModel: linkViewModel, linkItem: link)
                            .onDrag({
                                self.draggedItem = link.linkID
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
                    Text(buttonText)
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
                        }
                    }
                    return true
                })
            }
        }.navigationTitle("").toolbar {
            Button("", systemImage: "ellipsis", action: {
                self.isButtons = !isButtons
            })
            .actionSheet(isPresented: $isButtons) {
                    ActionSheet(title: Text("Изменить"), buttons: [
                        .default(Text(!linkViewModel.isDeleteLink ? "Удалить ссылку" : "Отмена")) {
                            linkViewModel.setDeleteLink(isDeleteLink: !linkViewModel.isDeleteLink)
                        },
                        .default(Text("Удалить папку")) {
                            linkViewModel.deleteFolder(folderID: folder.folderID)
                            dismiss()
                        }
                    ])
                }
        }
    }
}

#Preview {
    LinksListView(folder: .constant(Folder(title: "Food", folderID: "folderID", userID: "userID", position: 0, dateOfCreated: "00/00/00")))
}
