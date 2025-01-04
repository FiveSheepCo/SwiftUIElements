import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public struct ContentSizedPresentation<T: View>: View {
    @ViewBuilder var view: () -> T
    
    @State private var size: CGSize = .zero
    
    public init(view: @escaping () -> T) {
        self.view = view
    }
    
    public var body: some View {
        view()
            .sizeReader { newSize in
                size = newSize
            }
            .presentationDetents([.height(size.height)])
    }
}
