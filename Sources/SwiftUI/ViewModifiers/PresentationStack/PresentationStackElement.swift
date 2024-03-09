import Foundation

public protocol PresentationStackElement {
    var presentationMode: StackPresentationMode { get }
}

public extension PresentationStackElement {
    var presentationMode: StackPresentationMode { .sheet }
}
