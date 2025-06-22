import Foundation

/// 계산 히스토리 모델
struct CalculationHistory: Identifiable, Codable, Equatable {
    /// 고유 식별자
    let id: UUID
    
    /// 입력된 수식
    let expression: String
    
    /// 계산 결과
    let result: Double
    
    /// 계산 시간
    let timestamp: Date
    
    /// 사용된 각도 단위
    let angleUnit: AngleUnit
    
    /// 에러 여부
    let hasError: Bool
    
    /// 에러 메시지 (에러가 있을 경우)
    let errorMessage: String?
    
    /// 기본 초기화 (성공적인 계산)
    init(expression: String, result: Double, angleUnit: AngleUnit = .degree) {
        self.id = UUID()
        self.expression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        self.result = result
        self.timestamp = Date()
        self.angleUnit = angleUnit
        self.hasError = false
        self.errorMessage = nil
    }
    
    /// 에러 계산을 위한 초기화
    init(expression: String, error: String, angleUnit: AngleUnit = .degree) {
        self.id = UUID()
        self.expression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        self.result = 0.0
        self.timestamp = Date()
        self.angleUnit = angleUnit
        self.hasError = true
        self.errorMessage = error
    }
    
    /// 완전한 커스텀 초기화
    init(
        id: UUID = UUID(),
        expression: String,
        result: Double,
        timestamp: Date = Date(),
        angleUnit: AngleUnit = .degree,
        hasError: Bool = false,
        errorMessage: String? = nil
    ) {
        self.id = id
        self.expression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        self.result = result
        self.timestamp = timestamp
        self.angleUnit = angleUnit
        self.hasError = hasError
        self.errorMessage = errorMessage
    }
    
    /// 포맷된 결과 문자열
    var formattedResult: String {
        if hasError {
            return errorMessage ?? "Error"
        }
        
        // 무한대 처리
        if result.isInfinite {
            return result > 0 ? "∞" : "-∞"
        }
        
        // NaN 처리
        if result.isNaN {
            return "Error"
        }
        
        // 정수인 경우 소수점 제거
        if result == floor(result) && abs(result) < 1e15 {
            return String(format: "%.0f", result)
        }
        
        // 매우 큰 수나 작은 수는 과학적 표기법 사용
        if abs(result) >= 1e10 || (abs(result) < 1e-4 && result != 0) {
            return String(format: "%.4e", result)
        }
        
        // 일반적인 경우 소수점 4자리까지
        return String(format: "%.4g", result)
    }
    
    /// 상대적 시간 문자열 (예: "2분 전", "1시간 전")
    var relativeTimeString: String {
        let timeInterval = Date().timeIntervalSince(timestamp)
        
        // 간단한 상대 시간 계산 (formatter 사용 대신)
        if timeInterval < 60 {
            return "방금 전"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)분 전"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)시간 전"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days)일 전"
        }
    }
    
    /// 절대 시간 문자열 (예: "2024-01-15 14:30")
    var absoluteTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: timestamp)
    }
    
    /// 히스토리 유효성 검증
    var isValid: Bool {
        return !expression.isEmpty && 
               (!hasError || errorMessage != nil)
    }
    
    /// 재사용 가능한 수식 (결과 포함)
    var reusableExpression: String {
        if hasError {
            return expression
        }
        return "\(expression) = \(formattedResult)"
    }
} 