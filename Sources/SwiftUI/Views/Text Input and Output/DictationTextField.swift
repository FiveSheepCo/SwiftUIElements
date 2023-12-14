import SwiftUI

/// Configuration options for ``DictationTextField``.
public struct DictationTextFieldConfiguration {
    
    /// Whether to show a live transcription preview while the user is talking.
    /// Temporarily swaps the internal `TextField` with a `Text` component.
    public let showLivePreview: Bool
    
    /// Whether to allow the live preview to span multiple lines.
    /// - NOTE: Only applies if ``showLivePreview`` is set to `true`.
    public let autoExpandLivePreview: Bool
    
    /// The maximum amount of lines the live preview can span.
    /// - NOTE: Only applies if both ``showLivePreview`` and ``autoExpandLivePreview`` is set to `true`.
    public let livePreviewLineLimit: Int?
    
    /// Whether to clear the transcribed text upon start of a new dictation session.
    /// If this is enabled, dictation will start from the beginning.
    /// Otherwise, dictation will continue from the last point.
    public let resetTranscriptOnDictationSessionStart: Bool
    
    /// Whether to dismiss the keyboard from the inner `TextField` upon start of a new dictation session.
    public let dismissKeyboardOnDictationSessionStart: Bool
}

extension DictationTextFieldConfiguration {
    
    /// The default configuration of the ``DictationTextField``.
    /// Provides an auto-expanding live preview without line limits.
    public static let `default`: Self = .init(
        showLivePreview: true,
        autoExpandLivePreview: true,
        livePreviewLineLimit: nil,
        resetTranscriptOnDictationSessionStart: true,
        dismissKeyboardOnDictationSessionStart: true
    )
}

/// A `TextField` with text dictation capabilities.
/// Supports live preview of dictated text.
@available(macOS 12.0, iOS 15.0, tvOS 16.0, watchOS 8.0, *)
public struct DictationTextField: View {
    
    /// Speech recognizer.
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    /// Whether speech transcription is currently running.
    @State var isTranscribing: Bool = false
    
    /// Label of the inner `TextField`.
    var label: Text
    
    /// Text binding of the inner `TextField`.
    @Binding var text: String
    
    /// Focus state of the inner `TextField`.
    @FocusState var textFieldIsFocused: Bool
    
    /// View configuration.
    let config: DictationTextFieldConfiguration
    
    // MARK: Initializers
    
    public init(
        label: Text,
        text: Binding<String>,
        locale: Locale = .current,
        config: DictationTextFieldConfiguration = .default
    ) {
        self.speechRecognizer = SpeechRecognizer(locale: locale)
        self.label = label
        self._text = text
        self.config = config
    }
    
    // MARK: Convenience Initializers
    
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>) {
        self.init(label: Text(titleKey), text: text)
    }
    
    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, locale: Locale = .current, config: DictationTextFieldConfiguration = .default) {
        self.init(label: Text(titleKey), text: text, locale: locale, config: config)
    }
    
    // MARK: Helper Functions
    
    /// Start transcription unless it's already running.
    func startTranscription() {
        guard !isTranscribing else { return }
        
        // Dismiss keyboard if requested
        if config.dismissKeyboardOnDictationSessionStart {
            textFieldIsFocused = false
        }
        
        // Reset transcript if requested
        if config.resetTranscriptOnDictationSessionStart {
            speechRecognizer.resetTranscript()
        }
        
        speechRecognizer.startTranscribing()
        
        // Animate UI changes
        withAnimation {
            isTranscribing = true
        }
    }
    
    /// End transcription unless it's already finished.
    func endTranscription() {
        guard isTranscribing else { return }
        
        speechRecognizer.stopTranscribing()
        
        // Animate UI changes
        withAnimation {
            isTranscribing = false
        }
    }
    
    /// Toggle transcription depending on the current state.
    func toggleTranscription() {
        if isTranscribing {
            endTranscription()
        } else {
            startTranscription()
        }
    }
    
    // MARK: Body
    
    public var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                if config.showLivePreview && isTranscribing {
                    
                    // Live preview
                    Text(speechRecognizer.transcript)
                        .animation(.default, value: speechRecognizer.transcript)
                        .opacity(0.75)
                        .minimumScaleFactor(0.75)
                        .lineLimit(config.autoExpandLivePreview ? config.livePreviewLineLimit : 1)
                } else {
                    
                    // Inner TextField
                    TextField(text: $text) {
                        label
                    }
                    .focused($textFieldIsFocused)
                }
            }
            .animation(.default, value: isTranscribing)
            
            // Make sure the dictation preview is leading-aligned,
            // while the dictation icon stays trailing-aligned.
            if config.showLivePreview && isTranscribing {
                Spacer(minLength: 8)
            }
            
            VStack {
                if isTranscribing {
                    Group {
                        if #available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *) {
                            Image(systemName: "waveform.badge.mic")
                                .symbolRenderingMode(.palette)
                                .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing)
                                .foregroundStyle(.red, .blue)
                        } else {
                            Image(systemName: "waveform.badge.mic")
                                .symbolRenderingMode(.palette)
                        }
                    }
                    .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                } else {
                    Image(systemName: "mic.fill")
                }
            }
            
            // Apply transitions and animations
            .transition(.scale)
            .animation(.default, value: isTranscribing)
            
            // Increase hit-testing surface
            .contentShape(Rectangle())
            
            // Handle tap-to-record and tap-to-finish
            .onTapGesture {
                toggleTranscription()
            }
            
            #if !os(tvOS)
            // Handle press-and-hold recording
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.25, maximumDistance: 64)
                    .onEnded { _ in
                        
                        // Start transcription on long press
                        startTranscription()
                    }
                    .sequenced(before: DragGesture(minimumDistance: 0)
                        .onChanged { state in
                            
                            // Stop transcription when moving too far away from the dictation symbol
                            let autoReleaseDistance = 32.0
                            let distance = max(state.translation.width, state.translation.height)
                            if distance > autoReleaseDistance {
                                endTranscription()
                            }
                        }
                        .onEnded { state in
                            
                            // Stop transcription on gesture release
                            endTranscription()
                        }
                    )
            )
            #endif
        } // End of HStack
        
        // React to changes of the transcribed text, even after the transcription is halted.
        // This should allow us to get the final corrections in, even if they take a bit longer to process.
        .compatibleOnChange(of: speechRecognizer.transcript) { newValue in
            guard !newValue.isEmpty else { return }
            text = newValue
        }
    }
}

#Preview {
    if #available(macOS 12.0, iOS 15.0, tvOS 16.0, watchOS 8.0, *) {
        DictationTextField("Foo", text: .constant("Bar"))
    } else {
        EmptyView()
    }
}
