import SwiftUI

public extension View {
    
    /// Schedules a periodical task to be executed with a specified time interval.
    ///
    /// This function creates and starts a repeating timer that triggers a given action periodically.
    /// The start of the timer can be optionally delayed by a specified duration.
    ///
    /// - Parameters:
    ///   - timeInterval: The interval (in seconds) between each execution of the action.
    ///   - startDelay: An optional delay (in seconds) before the timer starts. If nil, the timer starts immediately.
    ///   - fireImmediately: A Boolean value that determines whether the action should be executed immediately
    ///   upon calling this method, before starting the periodic timer. Defaults to `false`.
    ///   - action: A closure that takes a Timer instance as its parameter and returns void. This closure is executed
    ///     each time the timer fires.
    ///
    /// - Returns: The instance (`Self`) on which this method is called, to potentially allow method chaining.
    func periodicalTask(
        timeInterval: TimeInterval,
        delayStartBy startDelay: TimeInterval? = nil,
        fireImmediately: Bool = false,
        @_inheritActorContext action: @escaping (Timer) -> Void
    ) -> Self {
        
        // Instantiate the timer
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: action)
        let runLoop = RunLoop.current
        
        if fireImmediately {
            // Dispatch the action closure immediately
            runLoop.perform {
                action(timer)
            }
        }
        
        if let startDelay {
            // Schedule the timer to be added to the current RunLoop after `startDelay` has passed
            Timer.scheduledTimer(withTimeInterval: startDelay, repeats: false) { _ in
                runLoop.add(timer, forMode: .common)
            }
        } else {
            // Add the timer to the current RunLoop
            runLoop.add(timer, forMode: .common)
        }
        
        // Preserve `Self` type
        return self
    }
}
