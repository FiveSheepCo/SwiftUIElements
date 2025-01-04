import SwiftUI

public extension View {
    @available(iOS 16.0, macOS 13.0, *)
    func contentSizedSheet<T: View>(isPresented: Binding<Bool>, _ view: @escaping () -> T) -> some View {
        self
            .sheet(isPresented: isPresented, content: {
                ContentSizedPresentation(view: view)
            })
    }
}
