import SwiftUI

/// A SwiftUI component that presents a custom action dialog with dynamic content.
///
/// This view displays an overlay and a customizable content area. It appears with a transition
/// animation and can be dismissed by tapping the overlay or pressing a cancel button.
@available(iOS 15.0, macOS 12.0, *)
internal struct ActionDialogViewModifier<InnerContent: View, Actions: View, Item>: ViewModifier {
    
    @Binding
    private var item: Item?
    private let content: (Item) -> InnerContent
    private let actions: ((Item) -> Actions)?
    private let onDismiss: (() -> Void)?
    
    /// Initializes an action dialog with an `Identifiable` item.
    ///
    /// The dialog is presented when the item is some value, and dismissed when set to nil.
    /// The builtin means of closing the action dialog will set the item back to nil.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional `Identifiable` item that controls the presentation of the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    init(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        content: @escaping (Item) -> InnerContent,
        actions: ((Item) -> Actions)?
    ) where Item: Identifiable {
        self._item = item
        self.onDismiss = onDismiss
        self.content = content
        self.actions = actions
    }
    
    
    /// Initializes an action dialog with a Boolean binding.
    ///
    /// This initializer is a convenience for cases where the dialog's visibility is controlled by a Boolean flag.
    /// The builtin means of closing the action dialog will set the flag back to false.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether the dialog is currently presented.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    init(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> InnerContent,
        actions: (() -> Actions)?
    ) where Item == Bool {
        self._item = isPresented.map(
            forward: { $0 ? Optional.some(true) : Optional.none },
            reverse: { $0 ?? false }
        )
        self.onDismiss = onDismiss
        self.content = { _ in content() }
        if let actions {
            self.actions = { _ in actions() }
        } else {
            self.actions = nil
        }
    }
    
    var transition: AnyTransition {
        if #available(iOS 16.0, macOS 13.0, *) {
            AnyTransition.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top))
        } else {
            AnyTransition.scale
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .disabled(self.item != nil)
            .overlay {
                
                // The setup here might be a bit strange.
                // We need to handle transitions specifically for the content,
                // and if we put the transition anywhere else without the if, it doesn't work.
                ZStack(alignment: .bottom) {
                    
                    // Overlay
                    if item != nil {
                        Color.black
                            .ignoresSafeArea(.all, edges: .all)
                            .opacity(0.7)
                            .onTapGesture {
                                withAnimation {
                                    self.item = nil
                                }
                                self.onDismiss?()
                            }
                            .frame(maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .transition(.opacity)
                    }
                    
                    // Content area
                    if let item {
                        VStack {
                            
                            // Main content
                            VStack {
                                
                                // Inner content
                                self.content(item)
                                
                                // Actions
                                if let actions {
                                    Divider()
                                    VStack {
                                        actions(item)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            // Workaround to set background with a clipping shape
                            // without causing it to clip under the safe area.
                            .background {
                                Color.clear
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Cancel button
                            Button(role: .cancel) {
                                withAnimation {
                                    self.item = nil
                                }
                                self.onDismiss?()
                            } label: {
                                Text(NSLocalizedString("Cancel", comment: "Cancel button"))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            // Workaround to set background with a clipping shape
                            // without causing it to clip under the safe area.
                            .background {
                                Color.clear
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.bottom, 4)
                        .transition(transition)
                    }
                } // ZStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.snappy, value: self.item == nil)
            } // overlay
    } // body
}


@available(iOS 15.0, macOS 12.0, *)
public extension View {
    
    /// Initializes an action dialog with a Boolean binding.
    ///
    /// This initializer is a convenience for cases where the dialog's visibility is controlled by a Boolean flag.
    /// The builtin means of closing the action dialog will set the flag back to false.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether the dialog is currently presented.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    func actionDialog<Content: View, Actions: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier(
                isPresented: isPresented,
                onDismiss: onDismiss,
                content: content,
                actions: actions
            )
        )
    }
    
    /// Initializes an action dialog with a Boolean binding.
    ///
    /// This initializer is a convenience for cases where the dialog's visibility is controlled by a Boolean flag.
    /// The builtin means of closing the action dialog will set the flag back to false.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether the dialog is currently presented.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    func actionDialog<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier<Content, AnyView, Bool>(
                isPresented: isPresented,
                onDismiss: onDismiss,
                content: content,
                actions: nil
            )
        )
    }
    
    /// Initializes an action dialog with an `Identifiable` item.
    ///
    /// The dialog is presented when the item is some value, and dismissed when set to nil.
    /// The builtin means of closing the action dialog will set the item back to nil.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional `Identifiable` item that controls the presentation of the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog, based on the item.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    func actionDialog<Content: View, Actions: View, Item: Identifiable>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder actions: @escaping (Item) -> Actions
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier(
                item: item,
                onDismiss: onDismiss,
                content: content,
                actions: actions
            )
        )
    }
    
    /// Initializes an action dialog with an `Identifiable` item.
    ///
    /// The dialog is presented when the item is some value, and dismissed when set to nil.
    /// The builtin means of closing the action dialog will set the item back to nil.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional `Identifiable` item that controls the presentation of the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog, based on the item.
    func actionDialog<Content: View, Item: Identifiable>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier<Content, AnyView, Item>(
                item: item,
                onDismiss: onDismiss,
                content: content,
                actions: nil
            )
        )
    }
}

@available(iOS 15.0, macOS 12.0, *)
struct PreviewView: View {
    @State private var isOn = false
    
    var body: some View {
        TabView {
            VStack {
                Button {
                    isOn = true
                } label: {
                    Text("Show action dialog")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .actionDialog(isPresented: $isOn) {
                VStack(alignment: .leading) {
                    Text("Action Dialog").bold()
                    Toggle("Supports any component", isOn: .constant(true))
                }
            } actions: {
                Button {} label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
            }
            .tabItem {
                Label("Preview", systemImage: "house")
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
#Preview {
    PreviewView()
}
