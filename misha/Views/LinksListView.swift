
import SwiftUI

struct LinksListView: View {
    @Binding var folder: Folder
    
    var body: some View {
        Text(folder.title)
    }
}

#Preview {
    LinksListView(folder: .constant(Folder(title: "title", folderID: "folderID", userID: "userID", position: 0, dateOfCreated: "00/00/00")))
}
