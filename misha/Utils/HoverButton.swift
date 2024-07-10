

import Foundation
import SwiftUI

struct HoverButton<Label: View>: View {
    var action: () -> Void
    var label: () -> Label

    @State private var isHovered = false

    var body: some View {
        label()
            .onHover { inside in
                if inside {
                    action()
                }
                isHovered = inside
            }
    }
}
