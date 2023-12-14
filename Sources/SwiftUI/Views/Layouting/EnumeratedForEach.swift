import SwiftUI

/// A SwiftUI view that iterates over a collection and provides the content with an integer offset and
/// the element.
///
/// It is similar to SwiftUI's `ForEach` but additionally provides
/// the integer offset of each element in the collection to the content closure.
///
/// This view is particularly useful when you need both the element and its integer position within the
/// collection, for instance, to display a list with index labels.
///
/// The `Data` generic parameter is the type of the `RandomAccessCollection` to iterate over, `ID` is the
/// type of the identifier used to uniquely identify each element, and `Content` is the type of the view
/// to be returned for each element in the collection.
///
/// - Parameters:
///   - data: The collection of data that the `EnumeratedForEach` iterates over.
///   - id: A key path to a property that uniquely identifies each element.
///   - content: A closure that takes an integer offset and an element of `data` and returns a view.
///
/// Example:
/// ```swift
/// EnumeratedForEach(items, id: \.element) { offset, item in
///     Text("Offset: \(offset), Item: \(item)")
/// }
/// ```
///
/// - Note: `id` must be a unique identifier for each element in `data`.
/// - Attention: If you intend to use `\.self` as the `id`, in most cases you'll have to use `\.element` instead,
/// since the type of the `KeyPath` is different from the one used in `ForEach`.
public struct EnumeratedForEach<Data, ID, Content>: View
    where
        Data: RandomAccessCollection,
        ID: Hashable,
        Content: View
{
    typealias EnumeratingKeyPath = KeyPath<Array<EnumeratedSequence<Data>.Element>.Element, ID>
    
    private var data: Data
    private var content: (Int, Data.Element) -> Content
    private var idKeyPath: EnumeratingKeyPath
    
    init(
        _ data: Data,
        id: EnumeratingKeyPath,
        @ViewBuilder content: @escaping (Int, Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.idKeyPath = id
    }

    public var body: some View {
        ForEach(Array(data.enumerated()), id: idKeyPath) { (offset, element) in
            self.content(offset, element)
        }
    }
}

public extension EnumeratedForEach where Data.Element: Identifiable, ID == Data.Element.ID {
    init(_ data: Data, @ViewBuilder content: @escaping (Int, Data.Element) -> Content) {
        self.init(data, id: \.element.id, content: content)
    }
}


#Preview {
    VStack {
        EnumeratedForEach(["Foo", "Bar", "Baz"], id: \.element) { i, value in
            Text("[\(i)] \(value)")
        }
    }
}
