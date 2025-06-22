import Testing
import Foundation
@testable import EngineeringCalculator

struct AngleUnitTests {
    
    // MARK: - Display Name Tests
    
    @Test("Display name should return correct values")
    func displayName() {
        #expect(AngleUnit.radian.displayName == "RAD")
        #expect(AngleUnit.degree.displayName == "DEG")
    }
    
    // MARK: - Radian Conversion Tests
    
    @Test("Degree to radian conversion should be accurate")
    func toRadiansFromDegree() {
        let angleUnit = AngleUnit.degree
        
        // 0도 = 0 라디안
        #expect(abs(angleUnit.toRadians(0) - 0) < 1e-10)
        
        // 90도 = π/2 라디안
        #expect(abs(angleUnit.toRadians(90) - Double.pi / 2) < 1e-10)
        
        // 180도 = π 라디안
        #expect(abs(angleUnit.toRadians(180) - Double.pi) < 1e-10)
        
        // 270도 = 3π/2 라디안
        #expect(abs(angleUnit.toRadians(270) - 3 * Double.pi / 2) < 1e-10)
        
        // 360도 = 2π 라디안
        #expect(abs(angleUnit.toRadians(360) - 2 * Double.pi) < 1e-10)
        
        // 음수 각도
        #expect(abs(angleUnit.toRadians(-90) - (-Double.pi / 2)) < 1e-10)
    }
    
    @Test("Radian to radian conversion should return same value")
    func toRadiansFromRadian() {
        let angleUnit = AngleUnit.radian
        
        // 라디안에서 라디안으로는 값이 그대로
        #expect(angleUnit.toRadians(0) == 0)
        #expect(angleUnit.toRadians(Double.pi / 2) == Double.pi / 2)
        #expect(angleUnit.toRadians(Double.pi) == Double.pi)
        #expect(angleUnit.toRadians(2 * Double.pi) == 2 * Double.pi)
        #expect(angleUnit.toRadians(-Double.pi) == -Double.pi)
    }
    
    // MARK: - From Radian Conversion Tests
    
    @Test("Radian to degree conversion should be accurate")
    func fromRadiansToDegree() {
        let angleUnit = AngleUnit.degree
        
        // 0 라디안 = 0도
        #expect(abs(angleUnit.fromRadians(0) - 0) < 1e-10)
        
        // π/2 라디안 = 90도
        #expect(abs(angleUnit.fromRadians(Double.pi / 2) - 90) < 1e-10)
        
        // π 라디안 = 180도
        #expect(abs(angleUnit.fromRadians(Double.pi) - 180) < 1e-10)
        
        // 3π/2 라디안 = 270도
        #expect(abs(angleUnit.fromRadians(3 * Double.pi / 2) - 270) < 1e-10)
        
        // 2π 라디안 = 360도
        #expect(abs(angleUnit.fromRadians(2 * Double.pi) - 360) < 1e-10)
        
        // 음수 각도
        #expect(abs(angleUnit.fromRadians(-Double.pi / 2) - (-90)) < 1e-10)
    }
    
    @Test("Radian to radian conversion should return same value")
    func fromRadiansToRadian() {
        let angleUnit = AngleUnit.radian
        
        // 라디안에서 라디안으로는 값이 그대로
        #expect(angleUnit.fromRadians(0) == 0)
        #expect(angleUnit.fromRadians(Double.pi / 2) == Double.pi / 2)
        #expect(angleUnit.fromRadians(Double.pi) == Double.pi)
        #expect(angleUnit.fromRadians(2 * Double.pi) == 2 * Double.pi)
        #expect(angleUnit.fromRadians(-Double.pi) == -Double.pi)
    }
    
    // MARK: - Toggle Tests
    
    @Test("Toggle should switch between radian and degree")
    func toggled() {
        #expect(AngleUnit.radian.toggled() == .degree)
        #expect(AngleUnit.degree.toggled() == .radian)
    }
    
    // MARK: - Codable Tests
    
    @Test("AngleUnit should be encodable and decodable")
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // Radian 인코딩/디코딩
        let radianData = try encoder.encode(AngleUnit.radian)
        let decodedRadian = try decoder.decode(AngleUnit.self, from: radianData)
        #expect(decodedRadian == .radian)
        
        // Degree 인코딩/디코딩
        let degreeData = try encoder.encode(AngleUnit.degree)
        let decodedDegree = try decoder.decode(AngleUnit.self, from: degreeData)
        #expect(decodedDegree == .degree)
    }
    
    // MARK: - CaseIterable Tests
    
    @Test("CaseIterable should contain all angle units")
    func caseIterable() {
        let allCases = AngleUnit.allCases
        #expect(allCases.count == 2)
        #expect(allCases.contains(.radian))
        #expect(allCases.contains(.degree))
    }
    
    // MARK: - Round Trip Conversion Tests
    
    @Test("Round trip conversion from degree should be accurate")
    func roundTripConversionDegreeToRadianToDegree() {
        let angleUnit = AngleUnit.degree
        let originalValue = 45.0
        
        let radians = angleUnit.toRadians(originalValue)
        let backToDegrees = angleUnit.fromRadians(radians)
        
        #expect(abs(backToDegrees - originalValue) < 1e-10)
    }
    
    @Test("Round trip conversion from radian should be accurate")
    func roundTripConversionRadianToDegreeToRadian() {
        let degreeUnit = AngleUnit.degree
        let originalValue = Double.pi / 4  // 45도
        
        let degrees = degreeUnit.fromRadians(originalValue)
        let backToRadians = degreeUnit.toRadians(degrees)
        
        #expect(abs(backToRadians - originalValue) < 1e-10)
    }
    
    // MARK: - Edge Case Tests
    
    @Test("Large angles should be converted correctly")
    func largeAngles() {
        let angleUnit = AngleUnit.degree
        
        // 매우 큰 각도
        let largeAngle = 3600.0  // 10바퀴
        let radians = angleUnit.toRadians(largeAngle)
        let expected = largeAngle * Double.pi / 180.0
        
        #expect(abs(radians - expected) < 1e-10)
    }
    
    @Test("Very small angles should be converted correctly")
    func verySmallAngles() {
        let angleUnit = AngleUnit.degree
        
        // 매우 작은 각도
        let smallAngle = 0.0001
        let radians = angleUnit.toRadians(smallAngle)
        let expected = smallAngle * Double.pi / 180.0
        
        #expect(abs(radians - expected) < 1e-15)
    }
} 