//
//  Ex+ Font.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/6/25.
//
/*
    SwiftUI 에서 폰트를 사용하려면 기본적으로 info.plist 에 폰트를 추가해줘야한다.
    [ Project -> Info -> Fonts provided by application -> 폰트파일 추가 ]
 
    본 파일은 기존 폰트사용을 보다 편리하게 사용하기 위한 확장성 파일이다.
    본 파일에서는 2가지의 방식으로 구현했다.
 */


// Font 확장자는 기본적으로 SwiftUI를 임포트 해줘야한다.
import SwiftUI


extension Font {
    
    // [ 1번 째 방법 ]
    // 디자인이 나왔다면 그 디자인에서 사용하는 폰트를 모두 등록하는 방법이다.
    // 초기 설정이 좀 귀찮긴하지만 한 번 해두면 또 2번 째 방법보다 편하게 사용할 수 있다.
    
    
    // Bold
    static let pretendardBold14: Font = .custom("Pretendard-Bold", size: 14)
    // SemiBold
    static let pretendardSemiBold14: Font = .custom("Pretendard-SemiBold", size: 14)
    // Medium
    static let pretendardMedium14: Font = .custom("Pretendard-Medium", size: 14)
    // Regular
    static let pretendardRegular14: Font = .custom("Pretendard-Regular", size: 14)
    
    
    
    // [ 2번 째 방법 ]
    // 그냥 기존 폰트 설정하는 방법과 비슷한 방식이지만 아예 순정 Font.custom 는 불편해서 그 부분을 좀 개선한 버전
    
    enum Pretendard {
        case semibold
        case medium
        case bold
        case custom(String)
        
        var value: String {
            switch self {
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .bold:
                return "Pretendard-Bold"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func pre(_ type: Pretendard, size: CGFloat = 17) -> Font {
        return custom(type.value , size: size)
    }
    
    
}
