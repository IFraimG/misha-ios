import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Image("Image")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
            
            Spacer()
            
            Text("Misha")
                .font(.title)
                .padding(.bottom, 80)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LaunchScreenView()
}
