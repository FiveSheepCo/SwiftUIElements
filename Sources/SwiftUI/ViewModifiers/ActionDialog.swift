import SwiftUI

/// Represents the methods for dismissing an action dialog in a user interface.
///
/// This enum provides options to specify how an action dialog can be dismissed, enhancing the flexibility
/// and user experience of dialog interactions.
public enum ActionDialogDismissKind {
    
    /// Dismiss the dialog by tapping the background overlay.
    /// This case represents the scenario where a user taps outside the dialog content, typically on a dimmed or
    /// semi-transparent overlay, to close the dialog.
    case tapBackground

    /// Dismiss the dialog using a dedicated cancel button.
    /// This case is used when the dialog should be closed as a result of the user interacting with a cancel
    /// button explicitly provided as part of the dialog's interface.
    case cancelButton
}

/// A SwiftUI component that presents a custom action dialog with dynamic content.
///
/// This view displays an overlay and a customizable content area. It appears with a transition
/// animation and can be dismissed by tapping the overlay or pressing a cancel button.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
internal struct ActionDialogViewModifier<InnerContent: View, Actions: View, Item>: ViewModifier {
    
    @Binding
    private var item: Item?
    private let content: (Item) -> InnerContent
    private let actions: ((Item) -> Actions)?
    private let onDismiss: (() -> Void)?
    private let dismissKinds: Set<ActionDialogDismissKind>
    
    /// Initializes an action dialog with an `Identifiable` item.
    ///
    /// The dialog is presented when the item is some value, and dismissed when set to nil.
    /// The builtin means of closing the action dialog will set the item back to nil.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional `Identifiable` item that controls the presentation of the dialog.
    ///   - dismiss: A set of methods to dismiss the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    init(
        item: Binding<Item?>,
        dismiss: Set<ActionDialogDismissKind>,
        onDismiss: (() -> Void)?,
        content: @escaping (Item) -> InnerContent,
        actions: ((Item) -> Actions)?
    ) where Item: Identifiable {
        self._item = item
        self.onDismiss = onDismiss
        self.dismissKinds = dismiss
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
    ///   - dismiss: A set of methods to dismiss the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    init(
        isPresented: Binding<Bool>,
        dismiss: Set<ActionDialogDismissKind>,
        onDismiss: (() -> Void)?,
        @ViewBuilder content: @escaping () -> InnerContent,
        actions: (() -> Actions)?
    ) where Item == Bool {
        self._item = isPresented.map(
            forward: { $0 ? Optional.some(true) : Optional.none },
            reverse: { $0 ?? false }
        )
        self.onDismiss = onDismiss
        self.dismissKinds = dismiss
        self.content = { _ in content() }
        if let actions {
            self.actions = { _ in actions() }
        } else {
            self.actions = nil
        }
    }
    
    var transition: AnyTransition {
        if #available(iOS 16.0, tvOS 16.0, watchOS 9.0, macOS 13.0, *) {
            AnyTransition.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top))
        } else {
            AnyTransition.scale
        }
    }
    
    func dismiss(_ requiredKind: ActionDialogDismissKind) {
        guard dismissKinds.contains(requiredKind) else { return }
        withAnimation {
            self.item = nil
        }
        self.onDismiss?()
    }
    
    @ViewBuilder
    var sheetBackground: some View {
        if #available(watchOS 10.0, *) {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    @ViewBuilder
    var dimBackground: some View {
        Color.black
            .ignoresSafeArea(.all, edges: .all)
            .opacity(0.7)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .transition(.opacity)
    }
    
    public func body(content: Content) -> some View {
        content
            .disabled(self.item != nil)
            .overlay(alignment: .bottom) {
                
                // The setup here might be a bit strange.
                // We need to handle transitions specifically for the content,
                // and if we put the transition anywhere else without the if, it doesn't work.
                ZStack(alignment: .bottom) {
                    
                    // Overlay
                    if item != nil {
                        if #available(tvOS 16.0, *) {
                            dimBackground
                                .onTapGesture {
                                    dismiss(.tapBackground)
                                }
                        } else {
                            dimBackground
                        }
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
                                sheetBackground
                            }
                            
                            // Cancel button
                            if dismissKinds.contains(.cancelButton) {
                                Button(role: .cancel) {
                                    dismiss(.cancelButton)
                                } label: {
                                    Text(NSLocalizedString("Cancel", comment: "Cancel button"))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                // Workaround to set background with a clipping shape
                                // without causing it to clip under the safe area.
                                .background {
                                    sheetBackground
                                }
                            }
                        } // VStack
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


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    
    /// Initializes an action dialog with a Boolean binding.
    ///
    /// This initializer is a convenience for cases where the dialog's visibility is controlled by a Boolean flag.
    /// The builtin means of closing the action dialog will set the flag back to false.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether the dialog is currently presented.
    ///   - dismiss: A set of methods to dismiss the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    func actionDialog<Content: View, Actions: View>(
        isPresented: Binding<Bool>,
        dismiss: Set<ActionDialogDismissKind> = [.cancelButton, .tapBackground],
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier(
                isPresented: isPresented,
                dismiss: dismiss,
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
    ///   - dismiss: A set of methods to dismiss the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog.
    func actionDialog<Content: View>(
        isPresented: Binding<Bool>,
        dismiss: Set<ActionDialogDismissKind> = [.cancelButton, .tapBackground],
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier<Content, AnyView, Bool>(
                isPresented: isPresented,
                dismiss: dismiss,
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
    ///   - dismiss: A set of methods to dismiss the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog, based on the item.
    ///   - actions: A closure that provides the actions to be displayed at the bottom of the dialog.
    func actionDialog<Content: View, Actions: View, Item: Identifiable>(
        item: Binding<Item?>,
        dismiss: Set<ActionDialogDismissKind> = [.cancelButton, .tapBackground],
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder actions: @escaping (Item) -> Actions
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier(
                item: item,
                dismiss: dismiss,
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
    ///   - dismiss: A set of methods to dismiss the dialog.
    ///   - onDismiss: A closure that's called when the action dialog is dismissed.
    ///   - content: A closure that provides the content to be displayed in the dialog, based on the item.
    func actionDialog<Content: View, Item: Identifiable>(
        item: Binding<Item?>,
        dismiss: Set<ActionDialogDismissKind> = [.cancelButton, .tapBackground],
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier<Content, AnyView, Item>(
                item: item,
                dismiss: dismiss,
                onDismiss: onDismiss,
                content: content,
                actions: nil
            )
        )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    
    /// Initializes an action sheet with a Boolean binding.
    ///
    /// This initializer is a convenience for cases where the sheet's visibility is controlled by a Boolean flag.
    /// The builtin means of closing the action sheet will set the flag back to false.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether the sheet is currently presented.
    ///   - canDismiss: Whether the sheet can be dismissed by tapping outside of its area.
    ///   - onDismiss: A closure that's called when the action sheet is dismissed.
    ///   - content: A closure that provides the content to be displayed in the sheet.
    func simpleActionDialog<Content: View>(
        isPresented: Binding<Bool>,
        canDismiss: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier<Content, AnyView, Bool>(
                isPresented: isPresented,
                dismiss: canDismiss ? [.tapBackground] : [],
                onDismiss: onDismiss,
                content: content,
                actions: nil
            )
        )
    }
    
    /// Initializes an action sheet with an `Identifiable` item.
    ///
    /// The sheet is presented when the item is some value, and dismissed when set to nil.
    /// The builtin means of closing the action sheet will set the item back to nil.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional `Identifiable` item that controls the presentation of the sheet.
    ///   - dismiss: A set of methods to dismiss the sheet.
    ///   - onDismiss: A closure that's called when the action sheet is dismissed.
    ///   - content: A closure that provides the content to be displayed in the sheet, based on the item.
    func simpleActionDialog<Content: View, Item: Identifiable>(
        item: Binding<Item?>,
        canDismiss: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.modifier(
            ActionDialogViewModifier<Content, AnyView, Item>(
                item: item,
                dismiss: canDismiss ? [.tapBackground] : [],
                onDismiss: onDismiss,
                content: content,
                actions: nil
            )
        )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct PreviewView: View {
    @State private var isOn = false
    
    let showCancelButton: Bool
    
    init(showCancelButton: Bool = true) {
        self.showCancelButton = showCancelButton
    }
    
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
            .actionDialog(
                isPresented: $isOn,
                dismiss: Set((showCancelButton ? [.cancelButton] : []) + [.tapBackground])
            ) {
                VStack(alignment: .leading) {
                    Text("Action Dialog").bold()
                    Toggle("Supports any component", isOn: .constant(true))
                }
            } actions: {
                if showCancelButton {
                    Button {} label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    HStack {
                        Button(role: .cancel) {
                            isOn = false
                        } label: {
                            Text("No")
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            isOn = false
                        } label: {
                            Text("Yes")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .tabItem {
                Label("Preview", systemImage: "house")
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct PreviewView2: View {
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
            .simpleActionDialog(isPresented: $isOn) {
                VStack(alignment: .leading) {
                    Text("Action Dialog").bold()
                    Toggle("Supports any component", isOn: .constant(true))
                }
                Spacer().frame(maxHeight: 24)
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading) {
                            Text("Foo").bold()
                            Text("Lorem ipsum dolor sit amet")
                        }
                        .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 16) {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading) {
                            Text("Bar").bold()
                            Text("Lorem ipsum dolor sit amet")
                        }
                        .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(maxWidth: .infinity)
                }
            }
            .tabItem {
                Label("Preview", systemImage: "house")
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview("Default") {
    PreviewView()
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview("No cancel button") {
    PreviewView(showCancelButton: false)
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview("Custom style") {
    PreviewView2()
}
