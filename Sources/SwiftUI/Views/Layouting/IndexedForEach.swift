import SwiftUI
import FoundationPlus

/// A SwiftUI view that iterates over a collection, providing both the index and element to the content closure.
///
/// Unlike SwiftUI's standard `ForEach`, this struct provides the actual index of
/// each element in the collection along with the element itself. This is particularly useful for
/// collections where index types are not integers.
///
/// The generic parameters are `Data`, a `RandomAccessCollection` to iterate over; `ID`, a `Hashable`
/// type used to uniquely identify each element; and `Content`, the type of the view returned for each
/// element.
///
/// - Parameters:
///   - data: The collection of data that the `IndexedForEach` iterates over.
///   - id: A key path to a property that uniquely identifies each element.
///   - content: A closure that takes an index and an element of `data` and returns a view.
///
/// Example:
/// ```swift
/// IndexedForEach(array, id: \.element) { index, item in
///     Text("Index: \(index), Item: \(item)")
/// }
/// ```
///
/// - Note: The `id` must uniquely identify each element in `data`. If `Data.Element` is `Identifiable`,
///   the default identifier is the element's `id` property.
/// - Attention: If you intend to use `\.self` as the `id`, in most cases you'll have to use `\.element` instead,
///   since the type of the `KeyPath` is different from the one used in `ForEach`.
public struct IndexedForEach<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        Content: View
{
    typealias IndexingKeyPath = KeyPath<Array<AnyIterator<(
        index: Data.Index, element: Data.Element
    )>.Element>.Element, ID>
    
    private var data: Data
    private var content: (Data.Index, Data.Element) -> Content
    private var idKeyPath: IndexingKeyPath
    
    init(
        _ data: Data,
        id: IndexingKeyPath,
        @ViewBuilder content: @escaping (Data.Index, Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.idKeyPath = id
    }

    public var body: some View {
        ForEach(Array(data.indexed()), id: idKeyPath) { (index, element) in
            self.content(index, element)
        }
    }
}

public extension IndexedForEach where Data.Element: Identifiable, ID == Data.Element.ID {
    init(_ data: Data, @ViewBuilder content: @escaping (Data.Index, Data.Element) -> Content) {
        self.init(data, id: \.element.id, content: content)
    }
}

#Preview {
    VStack {
        IndexedForEach(["a", "b", "c"], id: \.element) { i, value in
            Text("[\(i)] \(value)")
        }
    }
}
