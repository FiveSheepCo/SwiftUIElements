import XCTest
import SwiftUI

@testable import SwiftUIElements

final class UI__BindingTests: XCTestCase {
    
    func testNegation() throws {
        class ViewModel: ObservableObject {
            @Published var enabled: Bool = false
            
            var binding: Binding<Bool> {
                Binding(get: { self.enabled }, set: { self.enabled = $0 })
            }
        }
        
        let model = ViewModel()
        let binding = model.binding.negated
        
        XCTAssertEqual(model.enabled, false)
        XCTAssertEqual(binding.wrappedValue, true)
        
        binding.wrappedValue = false
        XCTAssertEqual(model.enabled, true)
        XCTAssertEqual(binding.wrappedValue, false)
    }
    
    func testMapping() throws {
        class ViewModel: ObservableObject {
            @Published var enabled: Bool = false
            
            var binding: Binding<Bool> {
                Binding(get: { self.enabled }, set: { self.enabled = $0 })
            }
        }
        
        let model = ViewModel()
        let binding = model.binding.map(forward: { $0 ? 1 : 0 }, reverse: { $0 != 0 })
        
        XCTAssertEqual(model.enabled, false)
        XCTAssertEqual(binding.wrappedValue, 0)
        
        binding.wrappedValue = 1
        XCTAssertEqual(model.enabled, true)
        XCTAssertEqual(binding.wrappedValue, 1)
    }
    
    func testNilCoalescense() throws {
        class ViewModel: ObservableObject {
            @Published var enabled: Bool? = nil
            
            var binding: Binding<Bool?> {
                Binding(get: { self.enabled }, set: { self.enabled = $0 })
            }
        }
        
        let model = ViewModel()
        let binding = model.binding ?? false
        
        XCTAssertEqual(model.enabled, nil)
        XCTAssertEqual(binding.wrappedValue, false)
        
        binding.wrappedValue = false
        XCTAssertEqual(model.enabled, false)
        XCTAssertEqual(binding.wrappedValue, false)
        
        binding.wrappedValue = true
        XCTAssertEqual(model.enabled, true)
        XCTAssertEqual(binding.wrappedValue, true)
    }
}
