import SwiftUI

@available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *)
public extension View {

    /// Attaches a `GeometryReader` to the view to monitor size changes.
    ///
    /// The main difference between this and an enclosing `GeometryReader` is that the `sizeReader` modifier
    /// won't change the size of the view, preventing many common layouting and sizing issues.
    ///
    /// - Parameter onSizeChange: A closure that is called when the size of the view changes.
    ///                           The closure receives the new size as a `CGSize`.
    /// - Returns: A modified view that will call `onSizeChange` with the new size when the size of the view changes.
    func sizeReader(onSizeChange: @escaping (CGSize) -> Void) -> some View {
        self
            .background(
                GeometryReader { reader in
                    Rectangle().fill(Color.clear)
                        .onAppear {
                            onSizeChange(reader.size)
                        }
                        .compatibleOnChange(of: reader.size) { size in
                            onSizeChange(size)
                        }
                }
            )
    }
}
