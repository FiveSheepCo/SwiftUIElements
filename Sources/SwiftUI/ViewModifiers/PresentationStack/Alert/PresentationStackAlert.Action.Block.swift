import Foundation

extension PresentationStackAlert.Action {
    /// A block corresponding to a certain `PresentationStackAlert.Action`.
    public typealias Block = (_ fieldValues: [String]) -> Void
}
