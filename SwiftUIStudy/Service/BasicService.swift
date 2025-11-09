//
//  BasicService.swift
//  SwiftUIStudy
//
//  Created by 최무빈 on 11/9/25.
//

import Foundation



class BasicService {
    
    // Singleton Pattern
    static let shared = BasicService()
    private init() {}
    
    
    // MARK: - 서버 주소
    private let baseURL: String = {
        guard let url = Bundle.main.infoDictionary?["ServerURL"] as? String,
              !url.isEmpty else {
            fatalError("API_BASE_URL이 설정되지 않았습니다. xcconfig 파일을 확인하세요.")
        }
        return url
    }()
    
    
    func getServerURL() {
        print("BASIC_SERVICE_URL: \(baseURL)")
    }
}
