import Foundation
import SwiftUI

extension View {
    /// Adds a view that displays a root view and enables you to present additional views over the root view.
    /// - Parameters:
    ///   - stack: The stack of sheets, popovers or full screen covers that are shown.
    ///   - alertStack: The stack of alerts that are shown.
    ///   - content: The view for a specific item of the stack.
    @ViewBuilder public func presentationStack<Element: PresentationStackElement, Content: View>(
        stack: Binding<[Element]>,
        alertStack: Binding<[PresentationStackAlert]> = .constant([]),
        content: @escaping (Element) -> Content
    ) -> some View {
        _PresentationStackSupportView(
            index: 0,
            stack: stack,
            alertStack: alertStack,
            content: self,
            contentBuilder: content
        )
    }
}

struct _PresentationStackSupportView<Element: PresentationStackElement, Content: View, ContentBuilder: View>: View {
    let index: Int
    @Binding var stack: [Element]
    @Binding var alertStack: [PresentationStackAlert]
    let content: Content
    let contentBuilder: (Element) -> ContentBuilder
    
    private var isSheetPresented: Binding<Bool> {
        .init {
            stack.count > index && stack[index].presentationMode == .sheet
        } set: { newValue in
            if newValue == false {
                stack = Array(stack.prefix(index))
            }
        }
    }
    
    private var isFullScreenCoverPresented: Binding<Bool> {
        .init {
            stack.count > index && stack[index].presentationMode == .fullScreenCover
        } set: { newValue in
            if newValue == false {
                stack = Array(stack.prefix(index))
            }
        }
    }
    
    private var isPopoverPresented: Binding<Bool> {
        .init {
            stack.count > index && stack[index].presentationMode == .popover
        } set: { newValue in
            if newValue == false {
                stack = Array(stack.prefix(index))
            }
        }
    }
    
    private var isAlertPresented: Binding<Bool> {
        .init {
            stack.count == index && !alertStack.isEmpty
        } set: { newValue in
            if newValue == false {
                alertStack = Array(alertStack.dropFirst())
            }
        }
    }
    
    struct AlertPrimaryView: View {
        let alert: PresentationStackAlert
        @State var textFieldValues: [String]
        
        init(alert: PresentationStackAlert) {
            self.alert = alert
            _textFieldValues = .init(initialValue: alert.textFields.map(\.initialValue))
        }
        
        var body: some View {
            ForEach(Array(alert.textFields.enumerated()), id: \.offset) { (offset, field) in
                if field.isPassword {
                    SecureField(field.placeholder, text: $textFieldValues[offset])
                } else {
                    TextField(field.placeholder, text: $textFieldValues[offset])
                }
            }
            ForEach(Array(alert.actions.enumerated()), id: \.offset) { (offset, action) in
                if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
                    Button(action.title, role: action.style.role) {
                        action.handler?(textFieldValues)
                    }
                } else {
                    Button(action.title) {
                        action.handler?(textFieldValues)
                    }
                }
            }
        }
    }
    
    private var nextSupportView: some View {
        _PresentationStackSupportView<Element, ContentBuilder, ContentBuilder>(
            index: index + 1,
            stack: $stack,
            alertStack: $alertStack,
            content: contentBuilder(stack[index]),
            contentBuilder: contentBuilder
        )
    }
    
    @ViewBuilder private var fullScreenCoverContent: some View {
        #if os(iOS)
        if #available(iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
            content
                .fullScreenCover(isPresented: isFullScreenCoverPresented) { nextSupportView }
        } else {
            content
                .sheet(isPresented: isFullScreenCoverPresented) { nextSupportView }
        }
        #else
        if #available(macOS 12.0, *) {
            content
                .sheet(isPresented: isFullScreenCoverPresented) { nextSupportView.interactiveDismissDisabled() }
        } else {
            content
                .sheet(isPresented: isFullScreenCoverPresented) { nextSupportView }
        }
        #endif
    }
    
    @ViewBuilder private var presentationContent: some View {
        fullScreenCoverContent
            .sheet(isPresented: isSheetPresented) { nextSupportView }
            .popover(isPresented: isPopoverPresented) { nextSupportView }
    }
    
    var body: some View {
        let alert = alertStack.first
        if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
            presentationContent
                .alert(alert?.title ?? .init(.empty), isPresented: isAlertPresented) {
                    if let alert {
                        AlertPrimaryView(alert: alert)
                    }
                } message: {
                    if let text = alert?.message {
                        text
                    }
                }
        } else {
            presentationContent
                .alert(isPresented: isAlertPresented, content: {
                    if let secondaryButton = alert?.actions[ifExists: 1]?.compatabilityButton {
                        Alert(
                            title: Text(alert?.title ?? .init(.empty)),
                            message: alert?.message,
                            primaryButton: alert?.actions.first?.compatabilityButton ?? .cancel(),
                            secondaryButton: secondaryButton
                        )
                    } else {
                        Alert(
                            title: Text(alert?.title ?? .init(.empty)),
                            message: alert?.message,
                            dismissButton: alert?.actions.first?.compatabilityButton ?? .cancel()
                        )
                    }
                })
        }
        
    }
}
