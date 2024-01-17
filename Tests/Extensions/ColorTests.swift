import XCTest
import SwiftUI

@testable import SwiftUIElements

final class ColorTests: XCTestCase {
    
    @available(macOS 14.0, *)
    func testHslInitializer() throws {
        let theta: Float = 0.0001
        var color: Color.Resolved!
        
        color = Color(hue: 0, saturation: 1, lightness: 0.5).resolve(in: .init())
        XCTAssertEqual(color.red, 1, accuracy: theta)
        XCTAssertEqual(color.green, 0, accuracy: theta)
        XCTAssertEqual(color.blue, 0, accuracy: theta)
        
        color = Color(hue: 0, saturation: 1, lightness: 0).resolve(in: .init())
        XCTAssertEqual(color.red, 0, accuracy: theta)
        XCTAssertEqual(color.green, 0, accuracy: theta)
        XCTAssertEqual(color.blue, 0, accuracy: theta)
        
        color = Color(hue: 0, saturation: 1, lightness: 1).resolve(in: .init())
        XCTAssertEqual(color.red, 1, accuracy: theta)
        XCTAssertEqual(color.green, 1, accuracy: theta)
        XCTAssertEqual(color.blue, 1, accuracy: theta)
        
        color = Color(hue: 0, saturation: 1, lightness: 0.5).resolve(in: .init())
        XCTAssertEqual(color.red, 1, accuracy: theta)
        XCTAssertEqual(color.green, 0, accuracy: theta)
        XCTAssertEqual(color.blue, 0, accuracy: theta)
        
        color = Color(hue: 0.25, saturation: 0.52, lightness: 0.62).resolve(in: .init())
        XCTAssertEqual(color.red, 0.619, accuracy: 0.01)
        XCTAssertEqual(color.green, 0.816, accuracy: 0.01)
        XCTAssertEqual(color.blue, 0.424, accuracy: 0.01)
    }
}
