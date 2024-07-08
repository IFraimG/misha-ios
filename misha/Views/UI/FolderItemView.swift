
import SwiftUI

struct FolderItemView: View {
    @Binding var title: String
    @Binding var notesCount: Int
    @Binding var dateOfCreate: String
    
    var body: some View {
        ZStack {
            Image("Food")
                .resizable()
                .frame(width: 160, height: 160)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 0)
                        .shadow(color: .black, radius: 8, x: 0, y: 2))
            VStack(alignment: .leading) {
                Spacer()
                Text(title)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                HStack {
                    Text("\(notesCount) сохраненных").font(.system(size: 8))
                    Spacer()
                    Text(dateOfCreate).font(.system(size: 8))
                }.frame(width: 140)
            }.frame(width: 160, height: 140).background(
                BottomRoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 50)
                    .offset(y: 55))
        }
    }
}

#Preview {
    FolderItemView(title: .constant("Food"), notesCount: .constant(230), dateOfCreate: .constant("02/07/2024"))
}
