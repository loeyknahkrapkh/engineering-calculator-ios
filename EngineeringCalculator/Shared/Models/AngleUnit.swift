import Foundation

/// 각도 단위를 나타내는 열거형
public enum AngleUnit: String, CaseIterable, Codable {
    case radian = "rad"
    case degree = "deg"
    
    /// 화면에 표시될 이름
    var displayName: String {
        switch self {
        case .radian:
            return "RAD"
        case .degree:
            return "DEG"
        }
    }
    
    /// 라디안으로 변환
    func toRadians(_ value: Double) -> Double {
        switch self {
        case .radian:
            return value
        case .degree:
            return value * .pi / 180.0
        }
    }
    
    /// 현재 단위로 변환 (라디안에서)
    func fromRadians(_ radians: Double) -> Double {
        switch self {
        case .radian:
            return radians
        case .degree:
            return radians * 180.0 / .pi
        }
    }
    
    /// 다음 단위로 토글
    func toggled() -> AngleUnit {
        switch self {
        case .radian:
            return .degree
        case .degree:
            return .radian
        }
    }
} 