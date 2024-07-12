
import SwiftUI

struct FolderItemView: View {
    @Binding var title: String
    @Binding var preview: String
    @Binding var dateOfCreate: String
    
    var body: some View {
        ZStack {
//            Image("Food")
//                .resizable()
//                .frame(width: 160, height: 160)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(lineWidth: 0)
//                        .shadow(color: .black, radius: 8, x: 0, y: 2))
            LinkPreviewImage(url: "http://95.163.221.125:8080/image/\(preview)")
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(title)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Text(dateOfCreate)
                        .font(.system(size: 8))
                        .foregroundStyle(Color.black.opacity(0.5))
                }.frame(width: 140)
            }.frame(width: 160, height: 140).background(
                BottomRoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.7))
                    .frame(height: 40)
                    .offset(y: 60))
            
        }
    }
}

#Preview {
    FolderItemView(title: .constant("Food"), preview: .constant(""), dateOfCreate: .constant("02/07/2024"))
}
